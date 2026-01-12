---
search:
  boost: 0.5
title: AGIExecEnd
---

# AGIExecEnd

### Synopsis

Raised when a received AGI command completes processing.

### Syntax


```


Event: AGIExecEnd
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
Command: <value>
CommandId: <value>
ResultCode: <value>
Result: <value>

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

* `Command` - The AGI command as received from the external source.<br>

* `CommandId` - Random identification number assigned to the execution of this command.<br>

* `ResultCode` - The numeric result code from AGI<br>

* `Result` - The text result reason from AGI<br>

### Class

AGI
### See Also

* [AMI Events AGIExecStart](/Asterisk_18_Documentation/API_Documentation/AMI_Events/AGIExecStart)
* [Dialplan Applications AGI](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/AGI)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 