---
search:
  boost: 0.5
title: BridgeDestroy
---

# BridgeDestroy

### Synopsis

Destroy a bridge.

### Description

Deletes the bridge, causing channels to continue or hang up.<br>


### Syntax


```


    Action: BridgeDestroy
    ActionID: <value>
    BridgeUniqueid: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `BridgeUniqueid` - The unique ID of the bridge to destroy.<br>

### See Also

* [AMI Actions Bridge](/Asterisk_16_Documentation/API_Documentation/AMI_Actions/Bridge)
* [AMI Actions BridgeInfo](/Asterisk_16_Documentation/API_Documentation/AMI_Actions/BridgeInfo)
* [AMI Actions BridgeKick](/Asterisk_16_Documentation/API_Documentation/AMI_Actions/BridgeKick)
* [AMI Actions BridgeList](/Asterisk_16_Documentation/API_Documentation/AMI_Actions/BridgeList)
* [AMI Events BridgeDestroy](/Asterisk_16_Documentation/API_Documentation/AMI_Events/BridgeDestroy)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 