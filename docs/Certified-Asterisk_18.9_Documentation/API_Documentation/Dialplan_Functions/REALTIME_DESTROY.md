---
search:
  boost: 0.5
title: REALTIME_DESTROY
---

# REALTIME_DESTROY()

### Synopsis

RealTime Destroy Function.

### Description

This function acts in the same way as REALTIME(....) does, except that it destroys the matched record in the RT engine.<br>


/// note
If 'live\_dangerously' in 'asterisk.conf' is set to 'no', this function can only be read from the dialplan, and not directly from external protocols. It can, however, be executed as a write operation ('REALTIME\_DESTROY(family, fieldmatch)=ignored')
///


### Syntax


```

REALTIME_DESTROY(family,fieldmatch,matchvalue,delim1,delim2)
```
##### Arguments


* `family`

* `fieldmatch`

* `matchvalue`

* `delim1`

* `delim2`

### See Also

* [Dialplan Functions REALTIME](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/REALTIME)
* [Dialplan Functions REALTIME_STORE](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/REALTIME_STORE)
* [Dialplan Functions REALTIME_FIELD](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/REALTIME_FIELD)
* [Dialplan Functions REALTIME_HASH](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/REALTIME_HASH)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 