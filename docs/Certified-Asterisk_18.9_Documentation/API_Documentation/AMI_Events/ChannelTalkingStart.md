---
search:
  boost: 0.5
title: ChannelTalkingStart
---

# ChannelTalkingStart

### Synopsis

Raised when talking is detected on a channel.

### Syntax


```


Event: ChannelTalkingStart
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

```
##### Arguments


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

### Class

CLASS
### See Also

* [Dialplan Functions TALK_DETECT](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/TALK_DETECT)
* [AMI Events ChannelTalkingStop](/Certified-Asterisk_18.9_Documentation/API_Documentation/AMI_Events/ChannelTalkingStop)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 