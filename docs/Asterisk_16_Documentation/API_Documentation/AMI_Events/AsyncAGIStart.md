---
search:
  boost: 0.5
title: AsyncAGIStart
---

# AsyncAGIStart

### Synopsis

Raised when a channel starts AsyncAGI command processing.

### Syntax


```


    Event: AsyncAGIStart
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
    Env: <value>

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

* `Env` - URL encoded string read from the AsyncAGI server.<br>

### Class

AGI
### See Also

* [AMI Events AsyncAGIEnd](/Asterisk_16_Documentation/API_Documentation/AMI_Events/AsyncAGIEnd)
* [AMI Events AsyncAGIExec](/Asterisk_16_Documentation/API_Documentation/AMI_Events/AsyncAGIExec)
* [Dialplan Applications AGI](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/AGI)
* [AMI Actions AGI](/Asterisk_16_Documentation/API_Documentation/AMI_Actions/AGI)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 