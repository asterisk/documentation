---
search:
  boost: 0.5
title: MonitorStart
---

# MonitorStart

### Synopsis

Raised when monitoring has started on a channel.

### Syntax


```


Event: MonitorStart
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

CALL
### See Also

* [AMI Events MonitorStop](/Certified-Asterisk_18.9_Documentation/API_Documentation/AMI_Events/MonitorStop)
* [Dialplan Applications Monitor](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/Monitor)
* [AMI Actions Monitor](/Certified-Asterisk_18.9_Documentation/API_Documentation/AMI_Actions/Monitor)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 