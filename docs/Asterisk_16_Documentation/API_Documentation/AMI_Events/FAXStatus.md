---
search:
  boost: 0.5
title: FAXStatus
---

# FAXStatus

### Synopsis

Raised periodically during a fax transmission.

### Syntax


```


    Event: FAXStatus
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
    Operation: <value>
    Status: <value>
    LocalStationID: <value>
    FileName: <value>

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

* `Operation`

    * `gateway`

    * `receive`

    * `send`

* `Status` - A text message describing the current status of the fax<br>

* `LocalStationID` - The value of the **LOCALSTATIONID** channel variable<br>

* `FileName` - The files being affected by the fax operation<br>

### Class

CALL

### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 