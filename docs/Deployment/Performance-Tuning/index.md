# Performance Tuning

/// note | Bad performance is not always Asterisk's fault!
While there are some key things listed on this page that can improve performance, it's also important to note that Asterisk will not always be the root cause of _bad_ performance. There are MANY things that can affect performance. For example, overall system load, SIP traffic load, different types of SIP traffic, configuration (realtime in particular), clock speed, CPU type, and other things can all be factors that hurt performance.
///

## Taskpools

As of Asterisk versions 20.17.0, 22.7.0, and 23.1.0, Threadpool has been deprecated in favor of Taskpool. Performance is significantly better using Taskpool and can be fine-tuned to your system specifications.

Taskpools were designed to improve the way taskprocessors are utilized. The previous iteration was threadpool, which had some limitations. Taskpool has the capability to have multiple taskprocessors to push tasks to, which can help balance the load if traffic is heavy. If all of the taskprocessors are busy, dynamic threads can be spun up to handle tasks. These dynamic threads will go away after a duration. If you notice this happening frequently, it might be a good idea to bump up the number of static threads, since these will stick around even when idle. There's no magic number here for what is too much or too little; it will come down to monitoring the system and seeing what typical values are. The taskprocessors can be viewed using 'core show taskprocessors' on the CLI. If all of the taskprocessors in question show around the same number of tasks, then it's likely additional taskprocessors are needed. The reason for this is because selecting a taskprocessor to use is based around the least used, starting with the first created taskpool taskprocessor. Here's an example where one pool is handling most of the tasks, while the others receive much less since the load does not need to be balanced between them because the tasks are being completed so quickly by the first taskprocessor:

```
Taskpool/s:pjsip-00000018 = 30196 processed tasks
Taskpool/s:pjsip-00000019 = 3317 processed tasks
Taskpool/s:pjsip-0000001a = 2 processed tasks
Taskpool/s:pjsip-0000001b = 1 processed tasks
```

As with the deprecated Threadpool, pjsip and stasis are the targets here for performance improvements.

### PJSIP Taskpool

/// note | Version Information
Taskpool for PJSIP was not introduced until 20.18.0, 22.8.0, and 23.2.0. This is a minor version later than when Taskpool was first introduced.
///

The 'system' section of pjsip.conf contains the options to configure taskpool for PJSIP.

```conf title="pjsip.conf" linenums="1"
[system]
type=system
;
; <other settings>
;

taskpool_minimum_size=4     ; Minimum number of taskprocessors in the res_pjsip
                            ; taskpool (default: "4")
taskpool_initial_size=4     ; Initial number of taskprocessors in the res_pjsip
                            ; taskpool (default: "4")
taskpool_auto_increment=1   ; The amount by which the number of taskprocessors is
                            ; incremented when necessary (default: "1")
taskpool_idle_timeout=60    ; Number of seconds before an idle taskprocessor
                            ; should be disposed of (default: "60")
taskpool_max_size=50        ; Maximum number of taskprocessors in the res_pjsip taskpool
                            ; A value of 0 indicates no maximum (default: "50")
```

### Stasis Taskpool

Stasis was a heavy consumer of threadpool and taskprocessors, producing many tasks. Switching over to taskpool, performance improvements could be seen anywhere from 6 to 12 times the amount of tasks as before. Taskpool for Stasis can be configured in stasis.conf:

```conf title="stasis.conf" linenums="1"
[taskpool]
minimum_size = 5        ; Minimum number of taskprocessors in taskpool.
initial_size = 5        ; Initial size of the taskpool.
                        ; 0 means the taskpool has no taskprocessors initially
                        ; until a task needs a taskprocessor.
idle_timeout_sec = 20   ; Number of seconds a taskprocessor should be idle before
                        ; dying. 0 means taskprocessors never time out.
max_size = 50           ; Maximum number of taskprocessors in the Stasis taskpool.
                        ; 0 means no limit to the number of taskprocessors in the
                        ; taskpool.
```

Just like threadpool, things that you don't need should be disabled to improve performance. For example, the AMI, CDR, and CEL modules can be quite taxing. It's best to disable them if they aren't being used.

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
; of stack timing. It's default is 32 seconds but its minimum is (64 * timer_t1) which
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
