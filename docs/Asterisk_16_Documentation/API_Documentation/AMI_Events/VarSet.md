---
search:
  boost: 0.5
title: VarSet
---

# VarSet

### Synopsis

Raised when a variable local to the gosub stack frame is set due to a subroutine call.

### Syntax


```


    Event: VarSet
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
    Variable: <value>
    Value: <value>

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

* `Variable` - The LOCAL variable being set.<br>

    /// note
The variable name will always be enclosed with 'LOCAL()'
///


* `Value` - The new value of the variable.<br>

### Class

DIALPLAN
### See Also

* [Dialplan Applications Gosub](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/Gosub)
* [AGI Commands gosub](/Asterisk_16_Documentation/API_Documentation/AGI_Commands/gosub)
* [Dialplan Functions LOCAL](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/LOCAL)
* [Dialplan Functions LOCAL_PEEK](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/LOCAL_PEEK)

### Synopsis

Raised when a variable is shared between channels.

### Syntax


```


    Event: VarSet
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
    Variable: <value>
    Value: <value>

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

* `Variable` - The SHARED variable being set.<br>

    /// note
The variable name will always be enclosed with 'SHARED()'
///


* `Value` - The new value of the variable.<br>

### Class

DIALPLAN
### See Also

* [Dialplan Functions SHARED](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/SHARED)

### Synopsis

Raised when a variable is set to a particular value.

### Syntax


```


    Event: VarSet
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
    Variable: <value>
    Value: <value>

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

* `Variable` - The variable being set.<br>

* `Value` - The new value of the variable.<br>

### Class

DIALPLAN

### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 