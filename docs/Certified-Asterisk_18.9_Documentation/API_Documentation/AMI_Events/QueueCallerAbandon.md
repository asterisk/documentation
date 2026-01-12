---
search:
  boost: 0.5
title: QueueCallerAbandon
---

# QueueCallerAbandon

### Synopsis

Raised when a caller abandons the queue.

### Syntax


```


Event: QueueCallerAbandon
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
OriginalPosition: <value>
HoldTime: <value>

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

* `OriginalPosition` - The channel's original position in the queue.<br>

* `HoldTime` - The time the channel was in the queue, expressed in seconds since 00:00, Jan 1, 1970 UTC.<br>

### Class

AGENT

### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 