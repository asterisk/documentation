---
search:
  boost: 0.5
title: DialBegin
---

# DialBegin

### Synopsis

Raised when a dial action has started.

### Syntax


```


Event: DialBegin
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
DialString: <value>

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

* `DialString` - The non-technology specific device being dialed.<br>

### Class

CALL
### See Also

* [Dialplan Applications Dial](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/Dial)
* [Dialplan Applications Originate](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/Originate)
* [AMI Actions Originate](/Certified-Asterisk_18.9_Documentation/API_Documentation/AMI_Actions/Originate)
* [AMI Events DialEnd](/Certified-Asterisk_18.9_Documentation/API_Documentation/AMI_Events/DialEnd)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 