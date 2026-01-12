---
search:
  boost: 0.5
title: REALTIME_HASH
---

# REALTIME_HASH()

### Synopsis

RealTime query function.

### Description

This function retrieves a single record from the RT engine, where _fieldmatch_ contains the value _matchvalue_ and formats the output suitably, such that it can be assigned to the HASH() function. The HASH() function then provides a suitable method for retrieving each field value of the record.<br>


### Syntax


```

REALTIME_HASH(family,fieldmatch,matchvalue)
```
##### Arguments


* `family`

* `fieldmatch`

* `matchvalue`

### See Also

* [Dialplan Functions REALTIME](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/REALTIME)
* [Dialplan Functions REALTIME_STORE](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/REALTIME_STORE)
* [Dialplan Functions REALTIME_DESTROY](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/REALTIME_DESTROY)
* [Dialplan Functions REALTIME_FIELD](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/REALTIME_FIELD)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 