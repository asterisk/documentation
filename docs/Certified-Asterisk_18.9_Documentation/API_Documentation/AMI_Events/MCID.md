---
search:
  boost: 0.5
title: MCID
---

# MCID

### Synopsis

Published when a malicious call ID request arrives.

### Syntax


```


Event: MCID
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
MCallerIDNumValid: <value>
MCallerIDNum: <value>
MCallerIDton: <value>
MCallerIDNumPlan: <value>
MCallerIDNumPres: <value>
MCallerIDNameValid: <value>
MCallerIDName: <value>
MCallerIDNameCharSet: <value>
MCallerIDNamePres: <value>
MCallerIDSubaddr: <value>
MCallerIDSubaddrType: <value>
MCallerIDSubaddrOdd: <value>
MCallerIDPres: <value>
MConnectedIDNumValid: <value>
MConnectedIDNum: <value>
MConnectedIDton: <value>
MConnectedIDNumPlan: <value>
MConnectedIDNumPres: <value>
MConnectedIDNameValid: <value>
MConnectedIDName: <value>
MConnectedIDNameCharSet: <value>
MConnectedIDNamePres: <value>
MConnectedIDSubaddr: <value>
MConnectedIDSubaddrType: <value>
MConnectedIDSubaddrOdd: <value>
MConnectedIDPres: <value>

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

* `MCallerIDNumValid`

* `MCallerIDNum`

* `MCallerIDton`

* `MCallerIDNumPlan`

* `MCallerIDNumPres`

* `MCallerIDNameValid`

* `MCallerIDName`

* `MCallerIDNameCharSet`

* `MCallerIDNamePres`

* `MCallerIDSubaddr`

* `MCallerIDSubaddrType`

* `MCallerIDSubaddrOdd`

* `MCallerIDPres`

* `MConnectedIDNumValid`

* `MConnectedIDNum`

* `MConnectedIDton`

* `MConnectedIDNumPlan`

* `MConnectedIDNumPres`

* `MConnectedIDNameValid`

* `MConnectedIDName`

* `MConnectedIDNameCharSet`

* `MConnectedIDNamePres`

* `MConnectedIDSubaddr`

* `MConnectedIDSubaddrType`

* `MConnectedIDSubaddrOdd`

* `MConnectedIDPres`

### Class

CALL

### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 