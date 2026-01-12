---
search:
  boost: 0.5
title: DTMFBegin
---

# DTMFBegin

### Synopsis

Raised when a DTMF digit has started on a channel.

### Syntax


```


Event: DTMFBegin
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

* `Direction`

    * `Received`

    * `Sent`

### Class

DTMF
### See Also

* [AMI Events DTMFEnd](/Asterisk_18_Documentation/API_Documentation/AMI_Events/DTMFEnd)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 