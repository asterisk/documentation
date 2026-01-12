---
search:
  boost: 0.5
title: ConfbridgeList
---

# ConfbridgeList

### Synopsis

Raised as part of the ConfbridgeList action response list.

### Syntax


```


Event: ConfbridgeList
Conference: <value>
Admin: <value>
MarkedUser: <value>
WaitMarked: <value>
EndMarked: <value>
Waiting: <value>
Muted: <value>
Talking: <value>
AnsweredTime: <value>
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

```
##### Arguments


* `Conference` - The name of the Confbridge conference.<br>

* `Admin` - Identifies this user as an admin user.<br>

    * `Yes`

    * `No`

* `MarkedUser` - Identifies this user as a marked user.<br>

    * `Yes`

    * `No`

* `WaitMarked` - Must this user wait for a marked user to join?<br>

    * `Yes`

    * `No`

* `EndMarked` - Does this user get kicked after the last marked user leaves?<br>

    * `Yes`

    * `No`

* `Waiting` - Is this user waiting for a marked user to join?<br>

    * `Yes`

    * `No`

* `Muted` - The current mute status.<br>

    * `Yes`

    * `No`

* `Talking` - Is this user talking?<br>

    * `Yes`

    * `No`

* `AnsweredTime` - The number of seconds the channel has been up.<br>

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

### Class

REPORTING

### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 