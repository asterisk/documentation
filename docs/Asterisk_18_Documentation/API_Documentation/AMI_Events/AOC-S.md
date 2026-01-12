---
search:
  boost: 0.5
title: AOC-S
---

# AOC-S

### Synopsis

Raised when an Advice of Charge message is sent at the beginning of a call.

### Syntax


```


Event: AOC-S
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
Chargeable: <value>
RateType: <value>
Currency: <value>
Name: <value>
Cost: <value>
Multiplier: <value>
ChargingType: <value>
StepFunction: <value>
Granularity: <value>
Length: <value>
Scale: <value>
Unit: <value>
SpecialCode: <value>

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

* `Chargeable`

* `RateType`

    * `NotAvailable`

    * `Free`

    * `FreeFromBeginning`

    * `Duration`

    * `Flag`

    * `Volume`

    * `SpecialCode`

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

* `ChargingType`

* `StepFunction`

* `Granularity`

* `Length`

* `Scale`

* `Unit`

    * `Octect`

    * `Segment`

    * `Message`

* `SpecialCode`

### Class

AOC
### See Also

* [AMI Events AOC-D](/Asterisk_18_Documentation/API_Documentation/AMI_Events/AOC-D)
* [AMI Events AOC-E](/Asterisk_18_Documentation/API_Documentation/AMI_Events/AOC-E)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 