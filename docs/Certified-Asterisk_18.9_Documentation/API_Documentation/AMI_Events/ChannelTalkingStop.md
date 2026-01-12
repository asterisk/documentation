---
search:
  boost: 0.5
title: ChannelTalkingStop
---

# ChannelTalkingStop

### Synopsis

Raised when talking is no longer detected on a channel.

### Syntax


```


Event: ChannelTalkingStop
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
Duration: <value>

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

* `Duration` - The length in time, in milliseconds, that talking was detected on the channel.<br>

### Class

CLASS
### See Also

* [Dialplan Functions TALK_DETECT](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/TALK_DETECT)
* [AMI Events ChannelTalkingStart](/Certified-Asterisk_18.9_Documentation/API_Documentation/AMI_Events/ChannelTalkingStart)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 