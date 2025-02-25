---
search:
  boost: 0.5
title: UserEvent
---

# UserEvent

### Synopsis

A user defined event raised from the dialplan.

### Description

Event may contain additional arbitrary parameters in addition to optional bridge and endpoint snapshots. Multiple snapshots of the same type are prefixed with a numeric value.<br>


### Syntax


```


    Event: UserEvent
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
    UserEvent: <value>

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

* `UserEvent` - The event name, as specified in the dialplan.<br>

### Class

USER
### See Also

* [Dialplan Applications UserEvent](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/UserEvent)
* [AMI Events UserEvent](/Asterisk_16_Documentation/API_Documentation/AMI_Events/UserEvent)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 