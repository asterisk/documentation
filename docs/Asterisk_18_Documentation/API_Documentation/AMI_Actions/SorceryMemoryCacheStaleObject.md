---
search:
  boost: 0.5
title: SorceryMemoryCacheStaleObject
---

# SorceryMemoryCacheStaleObject

### Synopsis

Mark an object in a sorcery memory cache as stale.

### Description

Marks an object as stale within a sorcery memory cache.<br>


### Syntax


```


Action: SorceryMemoryCacheStaleObject
ActionID: <value>
Cache: <value>
Object: <value>
[Reload: <value>]

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Cache` - The name of the cache to mark the object as stale in.<br>

* `Object` - The name of the object to mark as stale.<br>

* `Reload` - If true, then immediately reload the object from the backend cache instead of waiting for the next retrieval<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 