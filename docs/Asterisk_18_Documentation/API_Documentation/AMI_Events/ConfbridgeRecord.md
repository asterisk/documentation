---
search:
  boost: 0.5
title: ConfbridgeRecord
---

# ConfbridgeRecord

### Synopsis

Raised when a conference starts recording.

### Syntax


```


Event: ConfbridgeRecord
Conference: <value>
BridgeUniqueid: <value>
BridgeType: <value>
BridgeTechnology: <value>
BridgeCreator: <value>
BridgeName: <value>
BridgeNumChannels: <value>
BridgeVideoSourceMode: <value>
[BridgeVideoSource: <value>]

```
##### Arguments


* `Conference` - The name of the Confbridge conference.<br>

* `BridgeUniqueid`

* `BridgeType` - The type of bridge<br>

* `BridgeTechnology` - Technology in use by the bridge<br>

* `BridgeCreator` - Entity that created the bridge if applicable<br>

* `BridgeName` - Name used to refer to the bridge by its BridgeCreator if applicable<br>

* `BridgeNumChannels` - Number of channels in the bridge<br>

* `BridgeVideoSourceMode` - 
    * `none`

    * `talker`

    * `single`
The video source mode for the bridge.<br>

* `BridgeVideoSource` - If there is a video source for the bridge, the unique ID of the channel that is the video source.<br>

### Class

CALL
### See Also

* [AMI Events ConfbridgeStopRecord](/Asterisk_18_Documentation/API_Documentation/AMI_Events/ConfbridgeStopRecord)
* [Dialplan Applications ConfBridge](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/ConfBridge)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 