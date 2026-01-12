---
search:
  boost: 0.5
title: DAHDIChannel
---

# DAHDIChannel

### Synopsis

Raised when a DAHDI channel is created or an underlying technology is associated with a DAHDI channel.

### Syntax


```


Event: DAHDIChannel
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
DAHDIGroup: <value>
DAHDISpan: <value>
DAHDIChannel: <value>

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

* `DAHDIGroup` - The DAHDI logical group associated with this channel.<br>

* `DAHDISpan` - The DAHDI span associated with this channel.<br>

* `DAHDIChannel` - The DAHDI channel associated with this channel.<br>

### Class

CALL

### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 