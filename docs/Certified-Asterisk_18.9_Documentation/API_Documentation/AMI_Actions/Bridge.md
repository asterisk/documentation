---
search:
  boost: 0.5
title: Bridge
---

# Bridge

### Synopsis

Bridge two channels already in the PBX.

### Description

Bridge together two channels already in the PBX.<br>


### Syntax


```


Action: Bridge
ActionID: <value>
Channel1: <value>
Channel2: <value>
Tone: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Channel1` - Channel to Bridge to Channel2.<br>

* `Channel2` - Channel to Bridge to Channel1.<br>

* `Tone` - Play courtesy tone to Channel 2.<br>

    * `no`

    * `Channel1`

    * `Channel2`

    * `Both`

### See Also

* [Dialplan Applications Bridge](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/Bridge)
* [AMI Events BridgeCreate](/Certified-Asterisk_18.9_Documentation/API_Documentation/AMI_Events/BridgeCreate)
* [AMI Events BridgeEnter](/Certified-Asterisk_18.9_Documentation/API_Documentation/AMI_Events/BridgeEnter)
* [AMI Actions BridgeDestroy](/Certified-Asterisk_18.9_Documentation/API_Documentation/AMI_Actions/BridgeDestroy)
* [AMI Actions BridgeInfo](/Certified-Asterisk_18.9_Documentation/API_Documentation/AMI_Actions/BridgeInfo)
* [AMI Actions BridgeKick](/Certified-Asterisk_18.9_Documentation/API_Documentation/AMI_Actions/BridgeKick)
* [AMI Actions BridgeList](/Certified-Asterisk_18.9_Documentation/API_Documentation/AMI_Actions/BridgeList)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 