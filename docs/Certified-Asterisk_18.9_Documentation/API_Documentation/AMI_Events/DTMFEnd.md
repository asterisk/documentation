---
search:
  boost: 0.5
title: DTMFEnd
---

# DTMFEnd

### Synopsis

Raised when a DTMF digit has ended on a channel.

### Syntax


```


Event: DTMFEnd
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
Digit: <value>
DurationMs: <value>
Direction: <value>

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

* `Digit` - DTMF digit received or transmitted (0-9, A-E, # or *<br>

* `DurationMs` - Duration (in milliseconds) DTMF was sent/received<br>

* `Direction`

    * `Received`

    * `Sent`

### Class

DTMF
### See Also

* [AMI Events DTMFBegin](/Certified-Asterisk_18.9_Documentation/API_Documentation/AMI_Events/DTMFBegin)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 