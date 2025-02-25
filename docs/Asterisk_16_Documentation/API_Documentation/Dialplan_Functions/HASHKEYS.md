---
search:
  boost: 0.5
title: HASHKEYS
---

# HASHKEYS()

### Synopsis

Retrieve the keys of the HASH() function.

### Description

Returns a comma-delimited list of the current keys of the associative array defined by the HASH() function. Note that if you iterate over the keys of the result, adding keys during iteration will cause the result of the HASHKEYS() function to change.<br>


### Syntax


```

HASHKEYS(hashname)
```
##### Arguments


* `hashname`


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 