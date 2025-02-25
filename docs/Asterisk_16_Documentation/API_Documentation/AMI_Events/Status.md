---
search:
  boost: 0.5
title: Status
---

# Status

### Synopsis

Raised in response to a Status command.

### Syntax


```


    Event: Status
    [ActionID:] <value>
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
    Type: <value>
    DNID: <value>
    EffectiveConnectedLineNum: <value>
    EffectiveConnectedLineName: <value>
    TimeToHangup: <value>
    BridgeID: <value>
    Application: <value>
    Data: <value>
    Nativeformats: <value>
    Readformat: <value>
    Readtrans: <value>
    Writeformat: <value>
    Writetrans: <value>
    Callgroup: <value>
    Pickupgroup: <value>
    Seconds: <value>

```
##### Arguments


* `ActionID`

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

* `Type` - Type of channel<br>

* `DNID` - Dialed number identifier<br>

* `EffectiveConnectedLineNum`

* `EffectiveConnectedLineName`

* `TimeToHangup` - Absolute lifetime of the channel<br>

* `BridgeID` - Identifier of the bridge the channel is in, may be empty if not in one<br>

* `Application` - Application currently executing on the channel<br>

* `Data` - Data given to the currently executing channel<br>

* `Nativeformats` - Media formats the connected party is willing to send or receive<br>

* `Readformat` - Media formats that frames from the channel are received in<br>

* `Readtrans` - Translation path for media received in native formats<br>

* `Writeformat` - Media formats that frames to the channel are accepted in<br>

* `Writetrans` - Translation path for media sent to the connected party<br>

* `Callgroup` - Configured call group on the channel<br>

* `Pickupgroup` - Configured pickup group on the channel<br>

* `Seconds` - Number of seconds the channel has been active<br>

### Class

CALL
### See Also

* [AMI Actions Status](/Asterisk_16_Documentation/API_Documentation/AMI_Actions/Status)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 