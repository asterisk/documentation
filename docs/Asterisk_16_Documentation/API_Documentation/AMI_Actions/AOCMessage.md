---
search:
  boost: 0.5
title: AOCMessage
---

# AOCMessage

### Synopsis

Generate an Advice of Charge message on a channel.

### Description

Generates an AOC-D or AOC-E message on a channel.<br>


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

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Channel` - Channel name to generate the AOC message on.<br>

* `ChannelPrefix` - Partial channel prefix. By using this option one can match the beginning part of a channel name without having to put the entire name in. For example if a channel name is SIP/snom-00000001 and this value is set to SIP/snom, then that channel matches and the message will be sent. Note however that only the first matched channel has the message sent on it.<br>

* `MsgType` - Defines what type of AOC message to create, AOC-D or AOC-E<br>

    * `D`

    * `E`

* `ChargeType` - Defines what kind of charge this message represents.<br>

    * `NA`

    * `FREE`

    * `Currency`

    * `Unit`

* `UnitAmount(0)` - This represents the amount of units charged. The ETSI AOC standard specifies that this value along with the optional UnitType value are entries in a list. To accommodate this these values take an index value starting at 0 which can be used to generate this list of unit entries. For Example, If two unit entires were required this could be achieved by setting the paramter UnitAmount(0)=1234 and UnitAmount(1)=5678. Note that UnitAmount at index 0 is required when ChargeType=Unit, all other entries in the list are optional.<br>

* `UnitType(0)` - Defines the type of unit. ETSI AOC standard specifies this as an integer value between 1 and 16, but this value is left open to accept any positive integer. Like the UnitAmount parameter, this value represents a list entry and has an index parameter that starts at 0.<br>

* `CurrencyName` - Specifies the currency's name. Note that this value is truncated after 10 characters.<br>

* `CurrencyAmount` - Specifies the charge unit amount as a positive integer. This value is required when ChargeType==Currency.<br>

* `CurrencyMultiplier` - Specifies the currency multiplier. This value is required when ChargeType==Currency.<br>

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

### See Also

* [AMI Events AOC-D](/Asterisk_16_Documentation/API_Documentation/AMI_Events/AOC-D)
* [AMI Events AOC-E](/Asterisk_16_Documentation/API_Documentation/AMI_Events/AOC-E)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 