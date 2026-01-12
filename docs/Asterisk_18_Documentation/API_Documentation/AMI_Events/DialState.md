---
search:
  boost: 0.5
title: DialState
---

# DialState

### Synopsis

Raised when dial status has changed.

### Syntax


```


Event: DialState
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
DialStatus: <value>
[Forward: <value>]

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

* `DialStatus` - The new state of the outbound dial attempt.<br>

    * `RINGING` - The outbound channel is ringing.<br>

    * `PROCEEDING` - The call to the outbound channel is proceeding.<br>

    * `PROGRESS` - Progress has been received on the outbound channel.<br>

* `Forward` - If the call was forwarded, where the call was forwarded to.<br>

### Class

CALL

### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 