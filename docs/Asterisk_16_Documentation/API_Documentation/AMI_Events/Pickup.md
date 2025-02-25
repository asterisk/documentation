---
search:
  boost: 0.5
title: Pickup
---

# Pickup

### Synopsis

Raised when a call pickup occurs.

### Syntax


```


    Event: Pickup
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
    TargetChannel: <value>
    TargetChannelState: <value>
    TargetChannelStateDesc: <value>
    TargetCallerIDNum: <value>
    TargetCallerIDName: <value>
    TargetConnectedLineNum: <value>
    TargetConnectedLineName: <value>
    TargetLanguage: <value>
    TargetAccountCode: <value>
    TargetContext: <value>
    TargetExten: <value>
    TargetPriority: <value>
    TargetUniqueid: <value>
    TargetLinkedid: <value>

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

* `TargetChannel`

* `TargetChannelState` - A numeric code for the channel's current state, related to TargetChannelStateDesc<br>

* `TargetChannelStateDesc`

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

* `TargetCallerIDNum`

* `TargetCallerIDName`

* `TargetConnectedLineNum`

* `TargetConnectedLineName`

* `TargetLanguage`

* `TargetAccountCode`

* `TargetContext`

* `TargetExten`

* `TargetPriority`

* `TargetUniqueid`

* `TargetLinkedid` - Uniqueid of the oldest channel associated with this channel.<br>

### Class

CALL

### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 