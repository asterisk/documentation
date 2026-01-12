---
search:
  boost: 0.5
title: DeviceStateChange
---

# DeviceStateChange

### Synopsis

Raised when a device state changes

### Description

This differs from the 'ExtensionStatus' event because this event is raised for all device state changes, not only for changes that affect dialplan hints.<br>


### Syntax


```


Event: DeviceStateChange
Device: <value>
State: <value>

```
##### Arguments


* `Device` - The device whose state has changed<br>

* `State` - The new state of the device<br>

### Class

CALL
### See Also

* [AMI Events ExtensionStatus](/Certified-Asterisk_18.9_Documentation/API_Documentation/AMI_Events/ExtensionStatus)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 