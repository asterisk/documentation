---
search:
  boost: 0.5
title: MusicOnHoldStart
---

# MusicOnHoldStart

### Synopsis

Raised when music on hold has started on a channel.

### Syntax


```


Event: MusicOnHoldStart
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
Class: <value>

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

* `Class` - The class of music being played on the channel<br>

### Class

CALL
### See Also

* [AMI Events MusicOnHoldStop](/Asterisk_18_Documentation/API_Documentation/AMI_Events/MusicOnHoldStop)
* [Dialplan Applications StartMusicOnHold](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/StartMusicOnHold)
* [Dialplan Applications MusicOnHold](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/MusicOnHold)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 