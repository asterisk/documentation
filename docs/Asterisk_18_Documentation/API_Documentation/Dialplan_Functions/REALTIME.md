---
search:
  boost: 0.5
title: REALTIME
---

# REALTIME()

### Synopsis

RealTime Read/Write Functions.

### Description

This function will read or write values from/to a RealTime repository. REALTIME(....) will read names/values from the repository, and REALTIME(....)= will write a new value/field to the repository. On a read, this function returns a delimited text string. The name/value pairs are delimited by _delim1_, and the name and value are delimited between each other with delim2. If there is no match, NULL will be returned by the function. On a write, this function will always return NULL.<br>


### Syntax


```

REALTIME(family,fieldmatch,matchvalue,delim1|field,delim2)
```
##### Arguments


* `family`

* `fieldmatch`

* `matchvalue`

* `delim1|field` - Use _delim1_ with _delim2_ on read and _field_ without _delim2_ on write<br>
If we are reading and _delim1_ is not specified, defaults to ','<br>

* `delim2` - Parameter only used when reading, if not specified defaults to '='<br>

### See Also

* [Dialplan Functions REALTIME_STORE](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/REALTIME_STORE)
* [Dialplan Functions REALTIME_DESTROY](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/REALTIME_DESTROY)
* [Dialplan Functions REALTIME_FIELD](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/REALTIME_FIELD)
* [Dialplan Functions REALTIME_HASH](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/REALTIME_HASH)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 