---
search:
  boost: 0.5
title: MeetmeLeave
---

# MeetmeLeave

### Synopsis

Raised when a user leaves a MeetMe conference.

### Syntax


```


Event: MeetmeLeave
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

* `Duration` - The length of time in seconds that the Meetme user was in the conference.<br>

### Class

CALL
### See Also

* [AMI Events MeetmeJoin](/Certified-Asterisk_18.9_Documentation/API_Documentation/AMI_Events/MeetmeJoin)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 