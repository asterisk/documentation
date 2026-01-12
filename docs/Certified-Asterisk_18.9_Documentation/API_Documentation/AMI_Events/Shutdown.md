---
search:
  boost: 0.5
title: Shutdown
---

# Shutdown

### Synopsis

Raised when Asterisk is shutdown or restarted.

### Syntax


```


Event: Shutdown
Shutdown: <value>
Restart: <value>

```
##### Arguments


* `Shutdown` - Whether the shutdown is proceeding cleanly (all channels were hungup successfully) or uncleanly (channels will be terminated)<br>

    * `Uncleanly`

    * `Cleanly`

* `Restart` - Whether or not a restart will occur.<br>

    * `True`

    * `False`

### Class

SYSTEM

### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 