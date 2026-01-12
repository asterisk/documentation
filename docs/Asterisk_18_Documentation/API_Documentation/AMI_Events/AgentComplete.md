---
search:
  boost: 0.5
title: AgentComplete
---

# AgentComplete

### Synopsis

Raised when a queue member has finished servicing a caller in the queue.

### Syntax


```


Event: AgentComplete
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
DestChannel: <value>
DestChannelState: <value>
DestChannelStateDesc: <value>
DestCallerIDNum: <value>
DestCallerIDName: <value>
DestConnectedLineNum: <value>
DestConnectedLineName: <value>
DestLanguage: <value>
DestAccountCode: <value>
DestContext: <value>
DestExten: <value>
DestPriority: <value>
DestUniqueid: <value>
DestLinkedid: <value>
Queue: <value>
MemberName: <value>
Interface: <value>
HoldTime: <value>
TalkTime: <value>
Reason: <value>

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

* `DestChannel`

* `DestChannelState` - A numeric code for the channel's current state, related to DestChannelStateDesc<br>

* `DestChannelStateDesc`

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

* `DestCallerIDNum`

* `DestCallerIDName`

* `DestConnectedLineNum`

* `DestConnectedLineName`

* `DestLanguage`

* `DestAccountCode`

* `DestContext`

* `DestExten`

* `DestPriority`

* `DestUniqueid`

* `DestLinkedid` - Uniqueid of the oldest channel associated with this channel.<br>

* `Queue` - The name of the queue.<br>

* `MemberName` - The name of the queue member.<br>

* `Interface` - The queue member's channel technology or location.<br>

* `HoldTime` - The time the channel was in the queue, expressed in seconds since 00:00, Jan 1, 1970 UTC.<br>

* `TalkTime` - The time the queue member talked with the caller in the queue, expressed in seconds since 00:00, Jan 1, 1970 UTC.<br>

* `Reason`

    * `caller`

    * `agent`

    * `transfer`

### Class

AGENT
### See Also

* [AMI Events AgentCalled](/Asterisk_18_Documentation/API_Documentation/AMI_Events/AgentCalled)
* [AMI Events AgentConnect](/Asterisk_18_Documentation/API_Documentation/AMI_Events/AgentConnect)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 