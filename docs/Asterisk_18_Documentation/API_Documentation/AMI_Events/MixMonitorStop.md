---
search:
  boost: 0.5
title: MixMonitorStop
---

# MixMonitorStop

### Synopsis

Raised when monitoring has stopped on a channel.

### Syntax


```


Event: MixMonitorStop
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

* [AMI Events MixMonitorStart](/Asterisk_18_Documentation/API_Documentation/AMI_Events/MixMonitorStart)
* [Dialplan Applications StopMixMonitor](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/StopMixMonitor)
* [AMI Actions StopMixMonitor](/Asterisk_18_Documentation/API_Documentation/AMI_Actions/StopMixMonitor)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 