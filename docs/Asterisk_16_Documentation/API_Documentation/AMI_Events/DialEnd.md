---
search:
  boost: 0.5
title: DialEnd
---

# DialEnd

### Synopsis

Raised when a dial action has completed.

### Syntax


```


    Event: DialEnd
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
    [Forward:] <value>

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

* `DialStatus` - The result of the dial operation.<br>

    * `ABORT` - The call was aborted.<br>

    * `ANSWER` - The caller answered.<br>

    * `BUSY` - The caller was busy.<br>

    * `CANCEL` - The caller cancelled the call.<br>

    * `CHANUNAVAIL` - The requested channel is unavailable.<br>

    * `CONGESTION` - The called party is congested.<br>

    * `CONTINUE` - The dial completed, but the caller elected to continue in the dialplan.<br>

    * `GOTO` - The dial completed, but the caller jumped to a dialplan location.<br>
If known, the location the caller is jumping to will be appended to the result following a ":".<br>

    * `NOANSWER` - The called party failed to answer.<br>

* `Forward` - If the call was forwarded, where the call was forwarded to.<br>

### Class

CALL
### See Also

* [Dialplan Applications Dial](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/Dial)
* [Dialplan Applications Originate](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/Originate)
* [AMI Actions Originate](/Asterisk_16_Documentation/API_Documentation/AMI_Actions/Originate)
* [AMI Events DialBegin](/Asterisk_16_Documentation/API_Documentation/AMI_Events/DialBegin)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 