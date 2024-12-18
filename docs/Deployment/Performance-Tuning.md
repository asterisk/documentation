---
title: Performance Tuning
pageid: 36799664
---

These are some areas to consider when trying to performance tune your Asterisk installation.

## Threadpools

There are two threadpools of interest:  pjsip and stasis.

/// warning 
Any changes to threadpool settings require a full Asterisk restart. A reload is insufficient.
///

### PJSIP Threadpool:

The `system` section of pjsip.conf (or the ps_systems table in the database) contains 2 settings that control the threadpool used for the stack:

```conf title="pjsip.conf" linenums="1"
[system]
type=system
;
; <other settings>
;

; Sets the threadpool size at startup.
; Setting this higher can help Asterisk get through high startup loads
; such as when large numbers of phones are attempting to re-register or
; re-subscribe.
threadpool_initial_size=20

; When more threads are needed, how many should be created?
; Adding 5 at a time is probably safe.
threadpool_auto_increment=5

; Destroy idle threads after this timeout.
; Idle threads do have a memory overhead but it's slight as is the overhead of starting a new thread.
; However, starting and stopping threads frequently can cause memory fragmentation. If the call volume
; is fairly consistent, this parameter is less important since threads will tend to get continuous
; activity. In "spikey" situations, setting the timeout higher will decrease the probability
; of fragmentation. Don't obsess over this setting. Setting it to 2 minutes is probably safe
; for all PBX usage patterns.
threadpool_idle_timeout=120

; Set the maximum size of the pool.
; This is the most important settings. Setting it too low will slow the transaction rate possibly
; causing timeouts on clients. Setting it too high will use more memory, increase the chances of
; deadlocks and possibly cause other resources such as CPU and I/O to become exhausted.
; For a busy 8 core PBX, 100 is probably safe. Setting this to 0 will allow the pool to grow
; as high as the system will allow. This is probably not what you want. :) Setting it to 500
; is also probably not what you want. With that many threads, Asterisk will be thrashing and
; attempting to use more memory than can be allocated to a 32-bit process. If memory starts
; increasing, lowering this value might actually help.
threadpool_max_size=100

```

### Stasis Threadpool

Although the stasis message bus is not used much for simple call processing, it *is* used heavily for ARI and AGI processing, transfers, conference bridges, AMI, CDR and CEL processing, etc.  The threadpool is configured in stasis.conf:

```conf title="stasis.conf" linenums="1"
[threadpool]
;
; For a busy 8 core PBX, these settings are probably safe.
;
initial_size = 10
idle_timeout_sec = 120
;
; The notes about the pjsip max size apply here as well. Increasing to 100 threads is probably
; safe, but anything more will probably cause the same thrashing and memory over-utilization,
max_size = 60

```

If you don't need AMI, CDR, or CEL then disabling those modules will reduce resource usage.  The CDR module uses a lot of processing to create the CDR records and can easily get backed up on a busy system.

## PJSIP Protocol Tuning

### Timers

The `timer_t1` and `timer_b` settings are in the `system` section of pjsip.conf (or the ps_systems table in the database)

```conf title="pjsip.conf" linenums="1"
[system]
type=system
; Timer t1 sets the timeout after which pjsip gives up on waiting for a response from
; the remote party. The general rule is to set this to slightly higher than the round-trip
; time to the furthest remote party. Although the default of 500ms is safe, this timer
; controls other timing aspects of the of the stack so reducing it is in your best interest.
; Unless you have a provider or remote phones with more than a 100ms RTT, setting this to
; 100ms (the minimum) is probably safe. If you have outlier phones such as cell phones
; with VoIP clients, setting it to 250ms is probably safe.
timer_t1=100

; Timer B is technically the INVITE transaction timeout but it also controls other aspects
; of stack timing. It's default is 32 seconds but its minimum is (64 \* timer_t1) which
; would also be 32 seconds if timer_t1 were left at its default of 500ms. Unfortunately,
; this timer has the side effect of controlling how long completed transactions are kept in
; memory so on a busy PBX, a setting of 32 seconds will probably result in higher than
; necessary memory utilization. For most installations, 6400ms is fine.
timer_b=6400

```

### Identification Priority

The order in which endpoint identification methods are tried when an incoming request is received directly affects transaction rate.  The default order is set in the `global` of pjsip.conf (or the ps_globals table in the database).

```conf title="pjsip.conf" linenums="1"
[global]
type=global
; The default identifier order is ip,username,anonymous but for a PBX environment
; with lots of phones that register, identifying by ip address first is a waste of time.
; The order should be from the most likely to be used, to the least likely to be used
; which in this case would put username first for the phones, and ip second for providers.
endpoint_identifier_order=username,ip,anonymous

```

## Sorcery/Database

While storing pjsip objects in the pjsip.conf results in the fastest access time during call processing, a config change requires the entire file to be re-written and the res_pjsip module to be reloaded.  Using backend database for storage is most convenient for configuration but will be slowest for access time during call processing.  The solution is to use the database for storage and use sorcery to cache the objects.  This will result in the same access times as using pjsip.conf. 

### Setting up caching

The sorcery caches are defined in sorcery.conf.

```conf title="sorcery.conf" linenums="1"
[res_pjsip]

; maximum_objects: How many object to allow in the cache at 1 time.
; expire_on_reload: If res_pjsip is reloaded, should the cache be flushed?
; object_lifetime_maximum; How long should an object remain in the cache before it's flushed.

; There is only ever 1 row in the ps_globals table but it's referenced heavily and rarely
; changes. You may choose to leave this in pjsip.conf and comment out these 2 lines.
; On recent versions of Asterisk, the global section is only read on a pjsip reload which
; effectively caches the settings without an expiration time.
;global/cache=memory_cache,maximum_objects=2,expire_on_reload=yes,object_lifetime_maximum=3600
;global=realtime,ps_globals

; There is only ever 1 row in the ps_systems table and it's not referenced after startup.
; You may chose to leave this in pjsip.conf and comment out these 2 lines.
system/cache=memory_cache,maximum_objects=2,expire_on_reload=yes,object_lifetime_maximum=3600
system=realtime,ps_systems

; endpoints, aors, and auths are heavily read objects but are only written to when their
; configuration is changed. Set the maximum_objects to the number of extensions, plus the
; number of peered PBXes, plus the number of hosts defined for all providers (a provider
; with 10 hosts defined will use 10 endpoints, 10 aors and 1 auth). Add a few to spare.
; When a configuration change is made to an object, the specific object is flushed from the
; cache so the object_lifetime_maximum of 15 minutes is just a fail-safe.
endpoint/cache=memory_cache,maximum_objects=3000,expire_on_reload=yes,object_lifetime_maximum=900
endpoint=realtime,ps_endpoints

aor/cache=memory_cache,maximum_objects=3000,expire_on_reload=yes,object_lifetime_maximum=900
aor=realtime,ps_aors

auth/cache=memory_cache,maximum_objects=3000,expire_on_reload=yes,object_lifetime_maximum=900
auth=realtime,ps_auths

; contacts are both read from and written to regularly by Asterisk.
contact/cache=memory_cache,maximum_objects=3000,expire_on_reload=yes,object_lifetime_maximum=900
contact=realtime,ps_contacts


[res_pjsip_endpoint_identifier_ip]
; There will be 1 ip identifier for each host across all providers plus 1 for each peered PBX.
identify/cache=memory_cache,maximum_objects=150,expire_on_reload=yes,object_lifetime_maximum=900
identify=realtime,ps_endpoint_id_ips


;[res_pjsip_outbound_registration]
; There could be 1 outbound registration for each host across all providers depending on whether
; the provider requires them.
registration/cache=memory_cache,maximum_objects=150,expire_on_reload=yes,object_lifetime_maximum=900
registration=realtime,ps_registrations

```

### Flushing the caches:

The `sorcery memory cache` Asterisk CLI commands will allow flushing caches and individual objects from a specific cache.  There are also equivalent AMI commands (SorcerymemoryCache\*) that do the same.  After you make all pjsip configuration changes, call the appropriate AMI commands to flush objects and caches where appropriate.  This is necessary for Asterisk to see the changes made in the database immediately.

