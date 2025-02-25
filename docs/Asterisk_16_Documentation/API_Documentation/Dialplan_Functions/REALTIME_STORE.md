---
search:
  boost: 0.5
title: REALTIME_STORE
---

# REALTIME_STORE()

### Synopsis

RealTime Store Function.

### Description

This function will insert a new set of values into the RealTime repository. If RT engine provides an unique ID of the stored record, REALTIME\_STORE(...)=.. creates channel variable named RTSTOREID, which contains value of unique ID. Currently, a maximum of 30 field/value pairs is supported.<br>


### Syntax


```

REALTIME_STORE(family,field1,fieldN[,...],field30)
```
##### Arguments


* `family`

* `field1`

* `fieldN`

* `field30`

### See Also

* [Dialplan Functions REALTIME](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/REALTIME)
* [Dialplan Functions REALTIME_DESTROY](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/REALTIME_DESTROY)
* [Dialplan Functions REALTIME_FIELD](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/REALTIME_FIELD)
* [Dialplan Functions REALTIME_HASH](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/REALTIME_HASH)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 