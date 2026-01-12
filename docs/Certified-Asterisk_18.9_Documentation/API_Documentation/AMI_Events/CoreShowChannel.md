---
search:
  boost: 0.5
title: CoreShowChannel
---

# CoreShowChannel

### Synopsis

Raised in response to a CoreShowChannels command.

### Syntax


```


Event: CoreShowChannel
ActionID: <value>
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
BridgeId: <value>
Application: <value>
ApplicationData: <value>
Duration: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

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

* `BridgeId` - Identifier of the bridge the channel is in, may be empty if not in one<br>

* `Application` - Application currently executing on the channel<br>

* `ApplicationData` - Data given to the currently executing application<br>

* `Duration` - The amount of time the channel has existed<br>

### Class

CALL
### See Also

* [AMI Actions CoreShowChannels](/Certified-Asterisk_18.9_Documentation/API_Documentation/AMI_Actions/CoreShowChannels)
* [AMI Events CoreShowChannelsComplete](/Certified-Asterisk_18.9_Documentation/API_Documentation/AMI_Events/CoreShowChannelsComplete)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 