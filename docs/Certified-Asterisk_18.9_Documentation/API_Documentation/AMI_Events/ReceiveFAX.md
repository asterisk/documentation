---
search:
  boost: 0.5
title: ReceiveFAX
---

# ReceiveFAX

### Synopsis

Raised when a receive fax operation has completed.

### Syntax


```


Event: ReceiveFAX
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
LocalStationID: <value>
RemoteStationID: <value>
PagesTransferred: <value>
Resolution: <value>
TransferRate: <value>
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

* `LocalStationID` - The value of the **LOCALSTATIONID** channel variable<br>

* `RemoteStationID` - The value of the **REMOTESTATIONID** channel variable<br>

* `PagesTransferred` - The number of pages that have been transferred<br>

* `Resolution` - The negotiated resolution<br>

* `TransferRate` - The negotiated transfer rate<br>

* `FileName` - The files being affected by the fax operation<br>

### Class

CALL

### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 