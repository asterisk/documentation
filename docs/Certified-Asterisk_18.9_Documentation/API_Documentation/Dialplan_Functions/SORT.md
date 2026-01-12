---
search:
  boost: 0.5
title: SORT
---

# SORT()

### Synopsis

Sorts a list of key/vals into a list of keys, based upon the vals.

### Description

Takes a comma-separated list of keys and values, each separated by a colon, and returns a comma-separated list of the keys, sorted by their values. Values will be evaluated as floating-point numbers.<br>


### Syntax


```

SORT(keyval,keyvaln[,...])
```
##### Arguments


* `keyval`

    * `key1` **required**

    * `val1` **required**

* `keyvaln`

    * `key2` **required**

    * `val2` **required**


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 