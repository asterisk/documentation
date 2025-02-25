---
search:
  boost: 0.5
title: UNLOCK
---

# UNLOCK()

### Synopsis

Unlocks a named mutex.

### Description

Unlocks a previously locked mutex. Returns '1' if the channel had a lock or '0' otherwise.<br>


/// note
It is generally unnecessary to unlock in a hangup routine, as any locks held are automatically freed when the channel is destroyed.
///


/// note
If 'live\_dangerously' in 'asterisk.conf' is set to 'no', this function can only be executed from the dialplan, and not directly from external protocols.
///


### Syntax


```

UNLOCK(lockname)
```
##### Arguments


* `lockname`


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 