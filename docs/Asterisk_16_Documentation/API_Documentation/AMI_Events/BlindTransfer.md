---
search:
  boost: 0.5
title: BlindTransfer
---

# BlindTransfer

### Synopsis

Raised when a blind transfer is complete.

### Syntax


```


    Event: BlindTransfer
    Result: <value>
    TransfererChannel: <value>
    TransfererChannelState: <value>
    TransfererChannelStateDesc: <value>
    TransfererCallerIDNum: <value>
    TransfererCallerIDName: <value>
    TransfererConnectedLineNum: <value>
    TransfererConnectedLineName: <value>
    TransfererLanguage: <value>
    TransfererAccountCode: <value>
    TransfererContext: <value>
    TransfererExten: <value>
    TransfererPriority: <value>
    TransfererUniqueid: <value>
    TransfererLinkedid: <value>
    TransfereeChannel: <value>
    TransfereeChannelState: <value>
    TransfereeChannelStateDesc: <value>
    TransfereeCallerIDNum: <value>
    TransfereeCallerIDName: <value>
    TransfereeConnectedLineNum: <value>
    TransfereeConnectedLineName: <value>
    TransfereeLanguage: <value>
    TransfereeAccountCode: <value>
    TransfereeContext: <value>
    TransfereeExten: <value>
    TransfereePriority: <value>
    TransfereeUniqueid: <value>
    TransfereeLinkedid: <value>
    BridgeUniqueid: <value>
    BridgeType: <value>
    BridgeTechnology: <value>
    BridgeCreator: <value>
    BridgeName: <value>
    BridgeNumChannels: <value>
    BridgeVideoSourceMode: <value>
    [BridgeVideoSource:] <value>
    IsExternal: <value>
    Context: <value>
    Extension: <value>

```
##### Arguments


* `Result` - Indicates if the transfer was successful or if it failed.<br>

    * `Fail` - An internal error occurred.<br>

    * `Invalid` - Invalid configuration for transfer (e.g. Not bridged)<br>

    * `Not Permitted` - Bridge does not permit transfers<br>

    * `Success` - Transfer completed successfully<br>

    /// note
A result of 'Success' does not necessarily mean that a target was succesfully contacted. It means that a party was succesfully placed into the dialplan at the expected location.
///


* `TransfererChannel`

* `TransfererChannelState` - A numeric code for the channel's current state, related to TransfererChannelStateDesc<br>

* `TransfererChannelStateDesc`

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

* `TransfererCallerIDNum`

* `TransfererCallerIDName`

* `TransfererConnectedLineNum`

* `TransfererConnectedLineName`

* `TransfererLanguage`

* `TransfererAccountCode`

* `TransfererContext`

* `TransfererExten`

* `TransfererPriority`

* `TransfererUniqueid`

* `TransfererLinkedid` - Uniqueid of the oldest channel associated with this channel.<br>

* `TransfereeChannel`

* `TransfereeChannelState` - A numeric code for the channel's current state, related to TransfereeChannelStateDesc<br>

* `TransfereeChannelStateDesc`

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

* `TransfereeCallerIDNum`

* `TransfereeCallerIDName`

* `TransfereeConnectedLineNum`

* `TransfereeConnectedLineName`

* `TransfereeLanguage`

* `TransfereeAccountCode`

* `TransfereeContext`

* `TransfereeExten`

* `TransfereePriority`

* `TransfereeUniqueid`

* `TransfereeLinkedid` - Uniqueid of the oldest channel associated with this channel.<br>

* `BridgeUniqueid`

* `BridgeType` - The type of bridge<br>

* `BridgeTechnology` - Technology in use by the bridge<br>

* `BridgeCreator` - Entity that created the bridge if applicable<br>

* `BridgeName` - Name used to refer to the bridge by its BridgeCreator if applicable<br>

* `BridgeNumChannels` - Number of channels in the bridge<br>

* `BridgeVideoSourceMode` - 
    * `none`

    * `talker`

    * `single`
The video source mode for the bridge.<br>

* `BridgeVideoSource` - If there is a video source for the bridge, the unique ID of the channel that is the video source.<br>

* `IsExternal` - Indicates if the transfer was performed outside of Asterisk. For instance, a channel protocol native transfer is external. A DTMF transfer is internal.<br>

    * `Yes`

    * `No`

* `Context` - Destination context for the blind transfer.<br>

* `Extension` - Destination extension for the blind transfer.<br>

### Class

CALL
### See Also

* [AMI Actions BlindTransfer](/Asterisk_16_Documentation/API_Documentation/AMI_Actions/BlindTransfer)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 