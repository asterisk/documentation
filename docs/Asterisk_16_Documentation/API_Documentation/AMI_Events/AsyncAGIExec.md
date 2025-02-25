---
search:
  boost: 0.5
title: AsyncAGIExec
---

# AsyncAGIExec

### Synopsis

Raised when AsyncAGI completes an AGI command.

### Syntax


```


    Event: AsyncAGIExec
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
    [CommandID:] <value>
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

* `CommandID` - Optional command ID sent by the AsyncAGI server to identify the command.<br>

* `Result` - URL encoded result string from the executed AGI command.<br>

### Class

AGI
### See Also

* [AMI Events AsyncAGIStart](/Asterisk_16_Documentation/API_Documentation/AMI_Events/AsyncAGIStart)
* [AMI Events AsyncAGIEnd](/Asterisk_16_Documentation/API_Documentation/AMI_Events/AsyncAGIEnd)
* [Dialplan Applications AGI](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/AGI)
* [AMI Actions AGI](/Asterisk_16_Documentation/API_Documentation/AMI_Actions/AGI)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 