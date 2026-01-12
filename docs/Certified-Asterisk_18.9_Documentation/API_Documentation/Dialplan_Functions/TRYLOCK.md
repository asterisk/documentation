---
search:
  boost: 0.5
title: TRYLOCK
---

# TRYLOCK()

### Synopsis

Attempt to obtain a named mutex.

### Description

Attempts to grab a named lock exclusively, and prevents other channels from obtaining the same lock. Returns '1' if the lock was available or '0' otherwise.<br>


/// note
If 'live\_dangerously' in 'asterisk.conf' is set to 'no', this function can only be executed from the dialplan, and not directly from external protocols.
///


### Syntax


```

TRYLOCK(lockname)
```
##### Arguments


* `lockname`


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 