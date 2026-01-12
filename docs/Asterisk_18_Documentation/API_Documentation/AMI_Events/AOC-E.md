---
search:
  boost: 0.5
title: AOC-E
---

# AOC-E

### Synopsis

Raised when an Advice of Charge message is sent at the end of a call.

### Syntax


```


Event: AOC-E
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
ChargingAssociation: <value>
Number: <value>
Plan: <value>
ID: <value>
Charge: <value>
Type: <value>
BillingID: <value>
TotalType: <value>
Currency: <value>
Name: <value>
Cost: <value>
Multiplier: <value>
Units: <value>
NumberOf: <value>
TypeOf: <value>

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

* `ChargingAssociation`

* `Number`

* `Plan`

* `ID`

* `Charge`

* `Type`

    * `NotAvailable`

    * `Free`

    * `Currency`

    * `Units`

* `BillingID`

    * `Normal`

    * `Reverse`

    * `CreditCard`

    * `CallForwardingUnconditional`

    * `CallForwardingBusy`

    * `CallForwardingNoReply`

    * `CallDeflection`

    * `CallTransfer`

    * `NotAvailable`

* `TotalType`

    * `SubTotal`

    * `Total`

* `Currency`

* `Name`

* `Cost`

* `Multiplier`

    * `1/1000`

    * `1/100`

    * `1/10`

    * `1`

    * `10`

    * `100`

    * `1000`

* `Units`

* `NumberOf`

* `TypeOf`

### Class

AOC
### See Also

* [AMI Actions AOCMessage](/Asterisk_18_Documentation/API_Documentation/AMI_Actions/AOCMessage)
* [AMI Events AOC-S](/Asterisk_18_Documentation/API_Documentation/AMI_Events/AOC-S)
* [AMI Events AOC-D](/Asterisk_18_Documentation/API_Documentation/AMI_Events/AOC-D)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 