---
search:
  boost: 0.5
title: LOCK
---

# LOCK()

### Synopsis

Attempt to obtain a named mutex.

### Description

Attempts to grab a named lock exclusively, and prevents other channels from obtaining the same lock. LOCK will wait for the lock to become available. Returns '1' if the lock was obtained or '0' on error.<br>


/// note
To avoid the possibility of a deadlock, LOCK will only attempt to obtain the lock for 3 seconds if the channel already has another lock.
///


/// note
If 'live\_dangerously' in 'asterisk.conf' is set to 'no', this function can only be executed from the dialplan, and not directly from external protocols.
///


### Syntax


```

LOCK(lockname)
```
##### Arguments


* `lockname`


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 