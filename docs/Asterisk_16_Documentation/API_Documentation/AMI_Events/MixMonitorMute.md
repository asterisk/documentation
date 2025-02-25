---
search:
  boost: 0.5
title: MixMonitorMute
---

# MixMonitorMute

### Synopsis

Raised when monitoring is muted or unmuted on a channel.

### Syntax


```


    Event: MixMonitorMute
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
    Direction: <value>
    State: <value>

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

* `Direction` - Which part of the recording was muted or unmuted: read, write or both (from channel, to channel or both directions).<br>

* `State` - If the monitoring was muted or unmuted: 1 when muted, 0 when unmuted.<br>

### Class

CALL
### See Also

* [AMI Actions MixMonitorMute](/Asterisk_16_Documentation/API_Documentation/AMI_Actions/MixMonitorMute)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 