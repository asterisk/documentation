---
search:
  boost: 0.5
title: AOC-D
---

# AOC-D

### Synopsis

Raised when an Advice of Charge message is sent during a call.

### Syntax


```


Event: AOC-D
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

* [AMI Actions AOCMessage](/Certified-Asterisk_18.9_Documentation/API_Documentation/AMI_Actions/AOCMessage)
* [AMI Events AOC-S](/Certified-Asterisk_18.9_Documentation/API_Documentation/AMI_Events/AOC-S)
* [AMI Events AOC-E](/Certified-Asterisk_18.9_Documentation/API_Documentation/AMI_Events/AOC-E)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 