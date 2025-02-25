---
search:
  boost: 0.5
title: REALTIME_FIELD
---

# REALTIME_FIELD()

### Synopsis

RealTime query function.

### Description

This function retrieves a single item, _fieldname_ from the RT engine, where _fieldmatch_ contains the value _matchvalue_. When written to, the REALTIME\_FIELD() function performs identically to the REALTIME() function.<br>


### Syntax


```

REALTIME_FIELD(family,fieldmatch,matchvalue,fieldname)
```
##### Arguments


* `family`

* `fieldmatch`

* `matchvalue`

* `fieldname`

### See Also

* [Dialplan Functions REALTIME](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/REALTIME)
* [Dialplan Functions REALTIME_STORE](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/REALTIME_STORE)
* [Dialplan Functions REALTIME_DESTROY](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/REALTIME_DESTROY)
* [Dialplan Functions REALTIME_HASH](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/REALTIME_HASH)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 