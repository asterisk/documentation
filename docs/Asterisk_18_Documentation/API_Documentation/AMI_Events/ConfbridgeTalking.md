---
search:
  boost: 0.5
title: ConfbridgeTalking
---

# ConfbridgeTalking

### Synopsis

Raised when a confbridge participant begins or ends talking.

### Syntax


```


Event: ConfbridgeTalking
Conference: <value>
BridgeUniqueid: <value>
BridgeType: <value>
BridgeTechnology: <value>
BridgeCreator: <value>
BridgeName: <value>
BridgeNumChannels: <value>
BridgeVideoSourceMode: <value>
[BridgeVideoSource: <value>]
Channel: <value>
ChannelState: <value>
ChannelStateDesc: <value>
CallerIDNum: <value>
CallerIDName: <value>
ConnectedLineNum: <value>
ConnectedLineName: <value>
Language: <value>
AccountCode: <value>
Context: <value>
Exten: <value>
Priority: <value>
Uniqueid: <value>
Linkedid: <value>
TalkingStatus: <value>
Admin: <value>

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

* `Channel`

* `ChannelState` - A numeric code for the channel's current state, related to ChannelStateDesc<br>

* `ChannelStateDesc`

    * `Down`

    * `Rsrvd`

    * `OffHook`

    * `Dialing`

    * `Ring`

    * `Ringing`

    * `Up`

    * `Busy`

    * `Dialing Offhook`

    * `Pre-ring`

    * `Unknown`

* `CallerIDNum`

* `CallerIDName`

* `ConnectedLineNum`

* `ConnectedLineName`

* `Language`

* `AccountCode`

* `Context`

* `Exten`

* `Priority`

* `Uniqueid`

* `Linkedid` - Uniqueid of the oldest channel associated with this channel.<br>

* `TalkingStatus`

    * `on`

    * `off`

* `Admin` - Identifies this user as an admin user.<br>

    * `Yes`

    * `No`

### Class

CALL
### See Also

* [Dialplan Applications ConfBridge](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/ConfBridge)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 