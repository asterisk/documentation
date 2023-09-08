---
title: Sorcery Caching
pageid: 32375620
---

# Sorcery Caching

Since Asterisk 12, Asterisk has had a generic data access/storage layer called "sorcery", with pluggable "wizards" that each create, retrieve, update, and delete data from various backends. For instance, there is a sorcery wizard that reads configuration data from .conf files. There is a sorcery wizard that uses the Asterisk Realtime Architecture to interface with databases and other alternative backends. There are also sorcery wizards that use the AstDB and a simple in-memory container.

Starting in Asterisk 13.5.0, a new "memory_cache" wizard has been created. This allows for a cached copy of an object to be stored locally in cases where retrieval from a remote backend (such as a relational database) might be expensive. Memory caching is a flexible way to provide per object type caching, meaning that you are not forced into an all-or-nothing situation if you decide to cache. Caching also provides configuration options to allow for cached entries to automatically be updated or expired.

## Cachable Objects

Not all configurable objects are managed by sorcery. The following is a list of objects that are managed by the sorcery subsystem in Asterisk.

* PJSIP endpoint
* PJSIP AOR
* PJSIP contact
* PJSIP identify
* PJSIP ACL
* PJSIP resource_list
* PJSIP phoneprov
* PJSIP registration
* PJSIP subscription_persistence
* PJSIP inbound-publication
* PJSIP asterisk-publication
* PJSIP system
* PJSIP global
* PJSIP auth
* PJSIP outbound-publish
* PJSIP transport
* External MWI mailboxes
On this Page


## When Should I Use Caching?

First, if you are using default sorcery backends for objects (i.e. you have not altered `sorcery.conf` at all), then caching will likely not have any positive effect on your configuration. However, if you are using the "realtime" sorcery wizard or any other that retrieves data from outside the Asterisk process, then caching could be a good fit for certain object types.

There are two overall flavors of caching. The first type is a method that caches individually retrieved objects. In other words, when an object is retrieved from the backend, that object is also placed in the cache. That object can then be retrieved individually from the cache the next time it is needed. This type of caching works well for values that are

* Read more often than they are written
* Retrieved one-at-a-time.

For the first point, you will be able to know this better than anyone else. For instance, if you tend to configure PJSIP authentication very infrequently, but there are many calls, subscriptions, and qualifies that require authentication, then caching PJSIP auths is probably a good idea. If you are constantly tweaking PJSIP endpoint configuration for some reason, then you might find that caching isn't necessarily as good a fit for PJSIP endpoints.

For the second point, it may not always be obvious which types of objects are typically looked up one-at-a-time and which ones are typically looked up in multiples. The following object types are likely a bad fit for caching since they tend to be looked up in multiples:

* PJSIP contact
* PJSIP identify
* PJSIP global
* PJSIP system
* PJSIP registrations
* PJSIP ACLs
* PJSIP outbound-publishes
* PJSIP subscription_persistence

The rest of the objects listed are most typically retrieved one-at-a-time and would be good for caching in this manner.

The second type of caching instead pulls all objects from the database up front. These objects are all stored in memory, and since it is known that the cache has all objects, multiple objects can be retrieved from the cache at once. This means that **any** object type is a good fit for this type of caching.

## How do I enable Caching?

If you are familiar with enabling realtime for a sorcery object, then enabling caching should not seem difficult. Here is an example of what it might look like if you have configured PJSIP endpoints to use a cache:

sorcery.conf

```
[res_pjsip]
endpoint/cache=memory_cache
endpoint=realtime,ps_endpoints

```

Let's break this down line-by-line. The first line starts with "endpoint/cache". "endpoint" is the name of the object type. "/cache" is a cue to sorcery that the wizard being specified on this line is a cache. And "memory_cache" is the name of the caching wizard that has been added in Asterisk 14.0.0. The second line is the familiar line that specifies that endpoints can be retrieved from realtime by following the "ps_endpoints" configuration line in `extconfig.conf`.

The order of the lines is important. You will want to specify the memory_cache wizard before the realtime wizard so that the memory_cache is looked in before realtime when retrieving an item.

## How does the cache behave?

By default, the cache will simply store objects in memory. There will be no limits to the number of objects stored in the cache, and the items in the cache will never be updated or expire, no matter whether the backend has been updated to have new configuration values. The cache entry in `sorcery.conf` is configurable, though, so you can modify the behavior to suit your setup. Options for the memory cache are comma-separated on the line in `sorcery.conf` that defines the cache. For instance, you might have something like the following:

sorcery.conf

```
[res_pjsip]
endpoint/cache = memory_cache,maximum_objects=150,expire_on_reload=yes,object_lifetime_maximum=3600
endpoint = realtime,ps_endpoints

```

The following configuration options are recognized by the memory cache:

#### name

The name of a cache is used when referring to a specific cache when running an AMI or CLI command. If no name is provided for a cache, then the default is <configuration section>/<object type>. PJSIP endpoints, for instance, have a default cache name of "res_pjsip/endpoint".

#### maximum_objects

This option specifies the maximum number of objects that can be in the cache at a given time. If the cache is full and a new item is to be added, then the oldest item in the cache is removed to make room for the new item. If this option is not set or if its value is set to 0, then there is no limit on the number of objects in the cache.

#### object_lifetime_maximum

This option specifies the number of seconds an object may occupy the cache before it is automatically removed. This time is measured from when the object is initially added to the cache, not the time when the object was last accessed. If this option is not set or if its value is set to 0, then objects will stay in the cache forever.


#### object_lifetime_stale

This option specifies the number of seconds an object may occupy the cache until it is considered stale. When a stale object is retrieved from the cache, the stale object is given to the requestor, and a background task is initiated to update the object in the cache by querying whatever backend stores are configured. If a new object is retrieved from the backend, then the stale cached object is replaced with the new object. If the backend no longer has an object with the same ID as the one that has become stale, then the stale object is removed from the cache. If this option is not set or if its value is 0, then objects in the cache will never be marked stale.

#### expire_on_reload

This option specifies whether a reload of a module should automatically remove all of its objects from the cache. For instance, if this option is enabled, and you are caching PJSIP endpoints, then a module reload of `res_pjsip.so` would clear all PJSIP endpoints from the cache. By default this option is not enabled.

## What AMI and CLI commands does the cache provide?

### CLI

#### sorcery memory cache show <cache name>

This CLI command displays the configuration for the given cache and tells the number of items currently in the cache.

#### sorcery memory cache dump <cache name>

This CLI command displays all objects in the given cache. In addition to the name of the object, the command also displays the number of seconds until the object becomes stale and the number of seconds until the object will be removed from the cache.

#### sorcery memory cache expire <cache name> [object name]

This CLI command is used to remove objects from a given cache. If no object name is specified, then all objects in the cache are removed. If an object name is specified, then only the specified object is removed.

#### sorcery memory cache stale <cache name> [object_name]

This CLI command is used to mark an item in the cache as stale. If no object name is specified, then all objects in the cache are marked stale. If an object name is specified, then only the specified object is marked stale. For information on what it means for an object to be stale, see [here](#expire-or-stale)

### AMI

!!! info ""
    Since AMI commands are XML-documented in the source, there should be a dedicated wiki page with this information.

[//]: # (end-info)

#### SorceryMemoryCacheExpireObject

This command has the following syntax:

```
Action: SorceryMemoryCacheExpireObject
Cache: <cache name>
Object: <object name>

```

Issuing this command will cause the specified object in the specified cache to be removed. Like all AMI commands, an optional ActionID may be specified.

#### SorceryMemoryCacheExpire

This command has the following syntax:

```
Action: SorceryMemoryCacheExpire
Cache: <cache name>

```

Issuing this command will cause all objects in the specified cache to be removed. Like all AMI commands, an optional ActionID may be specified.

#### SorceryMemoryCacheStaleObject

This command has the following syntax:

```
Action: SorceryMemoryCacheStaleObject
Cache: <cache name>
Object: <object name>

```

Issuing this command will cause the specified object in the specified cache to be marked as stale. For more information on what it means for an object to be stale, see [here](#expire-or-stale).  Like all AMI commands, an optional ActionID may be specified.

#### SorceryMemoryCacheStale

This command has the following syntax:

```
Action: SorceryMemoryCacheStale
Cache: <cache name>

```

Issuing this command will cause all objects in the specified cache to be marked as stale. For more information on what it means for an object to be stale, see [here](#expire-or-stale).  Like all AMI commands, an optional ActionID may be specified.

### What are some caching strategies?

#### Hands-on or hands-off?

The hands-on approach to caching is that you set your cache to have no maximum number of objects, and objects never expire or become stale on their own. Instead, whenever you make changes to the backend store, you issue an AMI or CLI command to remove objects or mark them stale. The hands-off approach to caching is to fine-tune the maximum number of objects, stale timeout, and expire timeout such that you never have to think about the cache again after you set it up the first time.

The hands-on approach is a good fit either for installations where configuration rarely changes, or where there is some automation involved when configuration changes are made. For instance, if you are setting up a PBX for a small office where you are likely to make configuration changes a few times a year, then the hands-on approach may be a good fit. If your configuration is managed through a GUI that fires off a script when the "submit" button is pressed, then the hands-on approach may be a good fit since your scripts can be modified to manually expire objects or mark them stale. The main disadvantage to the hands-on approach is that if you forget to manually expire a cached object or if you make a mistake in your tooling, you're likely to have some big problems since configuration changes will seemingly not have any effect.

The hands-off approach is a good fit for configurations that change frequently or for deployments with inconsistent usage among users. If configuration is changing frequently, then it makes sense for objects in the cache to become stale and automatically get refreshed. If you have some users on the system that maybe use the system once a week, it makes sense for them to get removed from the cache as more frequent users occupy it. The biggest disadvantage to the hands-off approach is the potential for churn if your settings are overzealous. For instance, if you allow a maximum of 15 objects in a cache but it's common for 20 to be used, then the cache may constantly be shuffling which objects are stored in it. Similarly, if you set a stale object timeout low, then it is possible that objects in the cache will frequently be replacing themselves with identical copies.

There is also a hybrid approach. In the hybrid approach, you're mostly hands-off, but you can be hands-on for "emergency" changes. For instance, if there is a misconfiguration that is resulting in calls not being able to be sent to a user, then you may want to get that configuration updated and immediately remove the cached object so that the new configuration can be added to the cache instead.

#### Expire or Stale?

One question that may enter your mind is whether to have objects expire or whether they should become stale.

Letting objects expire has the advantage that they no longer are occupying cache space. For objects that are infrequently accessed, this can be a good thing since they otherwise will be taking up space and being useless. For objects that are accessed frequency, expiration is likely a bad choice. This is because if the object has been removed from the cache, then attempting to retrieve the object will require a cache miss, followed by a backend hit to retrieve the object. If the object configuration has not been altered, then this equates to a waste of cycles.

Letting objects become stale has the advantage that retrievals will always be quick. This is because even if the object is stale, the stale cached object is returned. It's left up to a background task to update the cached object with new data from the backend. The main disadvantage to objects being stale is that infrequently accessed objects will remain in the cache long after their useful lifetime.

One approach to take is a hybrid approach. You can set objects to become stale after an amount of time, and then later, the object will become expired. This way, objects that are retrieved frequently will stay up to date as they become stale, and objects that are rarely accessed will expire after a while.

## An example configuration

Below is a sample sorcery.conf file that uses realtime as the backend store for some PJSIP objects.

sorcery.conf

```
 [res_pjsip]
endpoint/cache = memory_cache,object_lifetime_stale=600,object_lifetime_maximum=1800,expire_on_reload=yes
endpoint = realtime,ps_endpoints
auth/cache=memory_cache,expire_on_reload=yes
auth = realtime,ps_auths
aor/cache = memory_cache,object_lifetime_stale=1500,object_lifetime_maximum=1800,expire_on_reload=yes
aor = realtime,ps_aors

```

In this particular setup, the administrator has set different options for different object caches.

* For endpoints, the administrator decided that cached endpoint configuration may occasionally need updating. Endpoints therefore will be marked stale after 10 minutes. If an endpoint happens to make it 30 minutes without being retrieved, then the endpoint will be ejected from the cache entirely.
* For auths, the administrator realized that auth so rarely changes that there is no reason to set any sort of extra parameters. On those odd occasions where auth is updated, the admin will just manually expire the old auth.
* AORs, like endpoints, may require refreshing after a while, but because the AOR configurations are changed much more infrequently, it takes 25 minutes for the object to become stale.
* All objects expire on a reload since a reload likely means that there was some large-scale change and everything should start from scratch.

This is just an example. It is not necessarily going to be a good fit for everyone's needs.

## Pre-caching all objects

When introducing caching, we discussed a second form of caching, where all objects are pre-loaded from the realtime backend and placed in the cache. Why would this be necessary?

Consider if you have configured AORs to be cached. At some point, Asterisk tried to retrieve AOR "alice". This AOR was found in a database, and it was added to the cache. Now, Asterisk gets told to retrieve all AORs. If Asterisk just looks in the cache, all it will get is "alice". The cache has no way of knowing whether it has all values cached or not. Thus, rather than even asking the cache, Asterisk skips straight to going to the database directly. The cache did not serve us much good there.

However, Asterisk can be told to pre-load all objects of a certain type and cache those. This way, the cache knows that it has all objects of a certain type. Therefore, if multiple objects need to be retrieved, Asterisk can ask the cache for those items and not have to hit the realtime backend at all. Here's an example configuration:

sorcery.conf

```
[res_pjsip]
identify/cache = memory_cache,object_lifetime_stale=600,object_lifetime_maximum=1800,expire_on_reload=yes,full_backend_cache=yes
identify = realtime,ps_endpoint_id_ips

```

Just like with the previous section's configuration, we have configured an object to be retrieved from realtime and cached in memory. Notice, though, that we have added `full_backend_cache=yes` to the end of the line. This is what causes Asterisk to pre-cache the objects. Normally, PJSIP "identify" objects would be a bad fit for caching since we tend to retrieve them all at once rather than one-at-a-time. By pre-caching all objects though, Asterisk can now retrieve all of them directly from the cache. Also notice that the other caching options are still relevant here. Rather than having the options apply to individual objects, they now apply to all of the retrieved objects. So if Asterisk retrieved 10 identifys during pre-cache, when the stale lifetime rolls around, all 10 will be marked stale and Asterisk will once again retrieve all of the objects from the backend.

### CLI

#### sorcery memory cache populate <cache name>

This CLI command is used to manually tell Asterisk to remove all objects from the cache and repopulate that cache with all objects from the backend.

### AMI

#### SorceryMemoryCachePopulate

This command has the following syntax:

```
Action: SorceryMemoryCachePopulate
Cache: <cache name>

```

Issuing this command has the same effect as the CLI "sorcery memory cache populate" command. It will invalidate all cached entries from the particular cache and then repopulate it with all objects from the backend.

### When to use this Caching method

Pre-caching the entire backend is a good idea if you find that caching individual objects is not working for you. The tradeoff is that you will use more memory this way since all objects are retrieved from the cache at once.

