---
search:
  boost: 0.5
title: DeviceStateList
---

# DeviceStateList

### Synopsis

List the current known device states.

### Description

This will list out all known device states in a sequence of _DeviceStateChange_ events. When finished, a _DeviceStateListComplete_ event will be emitted.<br>


### Syntax


```


Action: DeviceStateList
ActionID: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

### See Also

* [AMI Events DeviceStateChange](/Certified-Asterisk_18.9_Documentation/API_Documentation/AMI_Events/DeviceStateChange)
* [Dialplan Functions DEVICE_STATE](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/DEVICE_STATE)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 