---
search:
  boost: 0.5
title: AOCMessage
---

# AOCMessage

### Synopsis

Generate an Advice of Charge message on a channel.

### Description

Generates an AOC-S, AOC-D or AOC-E message on a channel.<br>


### Syntax


```


Action: AOCMessage
ActionID: <value>
Channel: <value>
ChannelPrefix: <value>
MsgType: <value>
ChargeType: <value>
UnitAmount(0): <value>
UnitType(0): <value>
CurrencyName: <value>
CurrencyAmount: <value>
CurrencyMultiplier: <value>
TotalType: <value>
AOCBillingId: <value>
ChargingAssociationId: <value>
ChargingAssociationNumber: <value>
ChargingAssociationPlan: <value>
ChargedItem: <value>
RateType: <value>
Time: <value>
TimeScale: <value>
Granularity: <value>
GranularityTimeScale: <value>
ChargingType: <value>
VolumeUnit: <value>
Code: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Channel` - Channel name to generate the AOC message on. This value is required unless ChannelPrefix is given.<br>

* `ChannelPrefix` - Partial channel prefix. By using this option one can match the beginning part of a channel name without having to put the entire name in. For example if a channel name is SIP/snom-00000001 and this value is set to SIP/snom, then that channel matches and the message will be sent. Note however that only the first matched channel has the message sent on it.<br>

* `MsgType` - Defines what type of AOC message to create, AOC-S, AOC-D or AOC-E<br>

    * `S`

    * `D`

    * `E`

* `ChargeType` - Defines what kind of charge this message represents for AOC-D and AOC-E.<br>

    * `NA`

    * `FREE`

    * `Currency`

    * `Unit`

* `UnitAmount(0)` - This represents the amount of units charged. The ETSI AOC standard specifies that this value along with the optional UnitType value are entries in a list. To accommodate this these values take an index value starting at 0 which can be used to generate this list of unit entries. For Example, If two unit entires were required this could be achieved by setting the paramter UnitAmount(0)=1234 and UnitAmount(1)=5678. Note that UnitAmount at index 0 is required when ChargeType=Unit, all other entries in the list are optional.<br>

* `UnitType(0)` - Defines the type of unit. ETSI AOC standard specifies this as an integer value between 1 and 16, but this value is left open to accept any positive integer. Like the UnitAmount parameter, this value represents a list entry and has an index parameter that starts at 0.<br>

* `CurrencyName` - Specifies the currency's name. Note that this value is truncated after 10 characters.<br>

* `CurrencyAmount` - Specifies the charge unit amount as a positive integer. This value is required when ChargeType==Currency (AOC-D or AOC-E) or RateType==Duration/Flat/Volume (AOC-S).<br>

* `CurrencyMultiplier` - Specifies the currency multiplier. This value is required when CurrencyAmount is given.<br>

    * `OneThousandth`

    * `OneHundredth`

    * `OneTenth`

    * `One`

    * `Ten`

    * `Hundred`

    * `Thousand`

* `TotalType` - Defines what kind of AOC-D total is represented.<br>

    * `Total`

    * `SubTotal`

* `AOCBillingId` - Represents a billing ID associated with an AOC-D or AOC-E message. Note that only the first 3 items of the enum are valid AOC-D billing IDs<br>

    * `Normal`

    * `ReverseCharge`

    * `CreditCard`

    * `CallFwdUnconditional`

    * `CallFwdBusy`

    * `CallFwdNoReply`

    * `CallDeflection`

    * `CallTransfer`

* `ChargingAssociationId` - Charging association identifier. This is optional for AOC-E and can be set to any value between -32768 and 32767<br>

* `ChargingAssociationNumber` - Represents the charging association party number. This value is optional for AOC-E.<br>

* `ChargingAssociationPlan` - Integer representing the charging plan associated with the ChargingAssociationNumber. The value is bits 7 through 1 of the Q.931 octet containing the type-of-number and numbering-plan-identification fields.<br>

* `ChargedItem` - Defines what part of the call is charged in AOC-S. Usually this is set to BasicCommunication, which refers to the time after the call is answered, but establishment (CallAttempt) or successful establishment (CallSetup) of a call can also be used. Other options are available, but these generally do not carry enough information to actually calculate the price of a call. It is possible to have multiple ChargedItem entries for a single call -- for example to charge for both the establishment of the call and the actual call. In this case, each ChargedItem is described by a ChargedItem: header and all other headers that follow it up to the next ChargedItem: header.<br>

    * `NA`

    * `SpecialArrangement`

    * `BasicCommunication`

    * `CallAttempt`

    * `CallSetup`

    * `UserUserInfo`

    * `SupplementaryService`

* `RateType` - Defines how an AOC-S ChargedItem is charged. The Duration option is only available when ChargedItem==BasicCommunication.<br>

    * `NA`

    * `Free`

    * `FreeFromBeginning`

    * `Duration`

    * `Flat`

    * `Volume`

    * `SpecialCode`

* `Time` - Specifies a positive integer which is the amount of time is paid for by one CurrencyAmount. This value is required when RateType==Duration.<br>

* `TimeScale` - Specifies the time multiplier. This value is required when Time is given.<br>

    * `OneHundredthSecond`

    * `OneTenthSecond`

    * `Second`

    * `TenSeconds`

    * `Minute`

    * `Hour`

    * `Day`

* `Granularity` - Specifies a positive integer which is the size of the charged time increments. This value is optional when RateType==Duration and ChargingType==StepFunction.<br>

* `GranularityTimeScale` - Specifies the granularity time multiplier. This value is required when Granularity is given.<br>

    * `OneHundredthSecond`

    * `OneTenthSecond`

    * `Second`

    * `TenSeconds`

    * `Minute`

    * `Hour`

    * `Day`

* `ChargingType` - Specifies whether the charge increases continuously with time or in increments of Time or, if provided, Granularity. This value is required when RateType==Duration.<br>

    * `ContinuousCharging`

    * `StepFunction`

* `VolumeUnit` - Specifies the quantity of which one unit is paid for by one CurrencyAmount. This value is required when RateType==Volume.<br>

    * `Octet`

    * `Segment`

    * `Message`

* `Code` - Specifies the charging code, which can be set to a value between 1 and 10. This value is required when ChargedItem==SpecialArrangement or RateType==SpecialCode.<br>

### See Also

* [AMI Events AOC-S](/Asterisk_18_Documentation/API_Documentation/AMI_Events/AOC-S)
* [AMI Events AOC-D](/Asterisk_18_Documentation/API_Documentation/AMI_Events/AOC-D)
* [AMI Events AOC-E](/Asterisk_18_Documentation/API_Documentation/AMI_Events/AOC-E)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 