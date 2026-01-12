---
search:
  boost: 0.5
title: SorceryMemoryCacheExpireObject
---

# SorceryMemoryCacheExpireObject

### Synopsis

Expire (remove) an object from a sorcery memory cache.

### Description

Expires (removes) an object from a sorcery memory cache. If full backend caching is enabled this action is not available and will fail. In this case the SorceryMemoryCachePopulate or SorceryMemoryCacheExpire AMI actions must be used instead.<br>


### Syntax


```


Action: SorceryMemoryCacheExpireObject
ActionID: <value>
Cache: <value>
Object: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Cache` - The name of the cache to expire the object from.<br>

* `Object` - The name of the object to expire.<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 