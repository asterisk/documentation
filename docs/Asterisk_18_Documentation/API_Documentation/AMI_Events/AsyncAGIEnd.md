---
search:
  boost: 0.5
title: AsyncAGIEnd
---

# AsyncAGIEnd

### Synopsis

Raised when a channel stops AsyncAGI command processing.

### Syntax


```


Event: AsyncAGIEnd
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

AGI
### See Also

* [AMI Events AsyncAGIStart](/Asterisk_18_Documentation/API_Documentation/AMI_Events/AsyncAGIStart)
* [AMI Events AsyncAGIExec](/Asterisk_18_Documentation/API_Documentation/AMI_Events/AsyncAGIExec)
* [Dialplan Applications AGI](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/AGI)
* [AMI Actions AGI](/Asterisk_18_Documentation/API_Documentation/AMI_Actions/AGI)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 