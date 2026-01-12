---
search:
  boost: 0.5
title: QueueCallerLeave
---

# QueueCallerLeave

### Synopsis

Raised when a caller leaves a Queue.

### Syntax


```


Event: QueueCallerLeave
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
Count: <value>
Position: <value>

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

* `Count` - The total number of channels in the queue.<br>

* `Position` - This channel's current position in the queue.<br>

### Class

AGENT
### See Also

* [AMI Events QueueCallerJoin](/Certified-Asterisk_18.9_Documentation/API_Documentation/AMI_Events/QueueCallerJoin)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 