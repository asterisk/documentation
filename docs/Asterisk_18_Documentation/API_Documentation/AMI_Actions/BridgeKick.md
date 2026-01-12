---
search:
  boost: 0.5
title: BridgeKick
---

# BridgeKick

### Synopsis

Kick a channel from a bridge.

### Description

The channel is removed from the bridge.<br>


### Syntax


```


Action: BridgeKick
ActionID: <value>
[BridgeUniqueid: <value>]
Channel: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `BridgeUniqueid` - The unique ID of the bridge containing the channel to destroy. This parameter can be omitted, or supplied to insure that the channel is not removed from the wrong bridge.<br>

* `Channel` - The channel to kick out of a bridge.<br>

### See Also

* [AMI Actions Bridge](/Asterisk_18_Documentation/API_Documentation/AMI_Actions/Bridge)
* [AMI Actions BridgeDestroy](/Asterisk_18_Documentation/API_Documentation/AMI_Actions/BridgeDestroy)
* [AMI Actions BridgeInfo](/Asterisk_18_Documentation/API_Documentation/AMI_Actions/BridgeInfo)
* [AMI Actions BridgeList](/Asterisk_18_Documentation/API_Documentation/AMI_Actions/BridgeList)
* [AMI Events BridgeLeave](/Asterisk_18_Documentation/API_Documentation/AMI_Events/BridgeLeave)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 