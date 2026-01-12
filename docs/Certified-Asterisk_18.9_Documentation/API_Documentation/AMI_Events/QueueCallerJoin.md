---
search:
  boost: 0.5
title: QueueCallerJoin
---

# QueueCallerJoin

### Synopsis

Raised when a caller joins a Queue.

### Syntax


```


Event: QueueCallerJoin
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
Queue: <value>
Position: <value>
Count: <value>

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

* `Queue` - The name of the queue.<br>

* `Position` - This channel's current position in the queue.<br>

* `Count` - The total number of channels in the queue.<br>

### Class

AGENT
### See Also

* [AMI Events QueueCallerLeave](/Certified-Asterisk_18.9_Documentation/API_Documentation/AMI_Events/QueueCallerLeave)
* [Dialplan Applications Queue](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/Queue)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 