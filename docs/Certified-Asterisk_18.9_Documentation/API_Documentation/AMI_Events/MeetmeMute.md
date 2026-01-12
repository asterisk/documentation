---
search:
  boost: 0.5
title: MeetmeMute
---

# MeetmeMute

### Synopsis

Raised when a MeetMe user is muted or unmuted.

### Syntax


```


Event: MeetmeMute
Meetme: <value>
User: <value>
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
Duration: <value>
Status: <value>

```
##### Arguments


* `Meetme` - The identifier for the MeetMe conference.<br>

* `User` - The identifier of the MeetMe user who joined.<br>

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

* `Duration` - The length of time in seconds that the Meetme user has been in the conference at the time of this event.<br>

* `Status`

    * `on`

    * `off`

### Class

CALL

### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 