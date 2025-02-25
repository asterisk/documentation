---
search:
  boost: 0.5
title: AttendedTransfer
---

# AttendedTransfer

### Synopsis

Raised when an attended transfer is complete.

### Description

The headers in this event attempt to describe all the major details of the attended transfer. The two transferer channels and the two bridges are determined based on their chronological establishment. So consider that Alice calls Bob, and then Alice transfers the call to Voicemail. The transferer and bridge headers would be arranged as follows:<br>

_OrigTransfererChannel_: Alice's channel in the bridge with Bob.<br>

_OrigBridgeUniqueid_: The bridge between Alice and Bob.<br>

_SecondTransfererChannel_: Alice's channel that called Voicemail.<br>

_SecondBridgeUniqueid_: Not present, since a call to Voicemail has no bridge.<br>

Now consider if the order were reversed; instead of having Alice call Bob and transfer him to Voicemail, Alice instead calls her Voicemail and transfers that to Bob. The transferer and bridge headers would be arranged as follows:<br>

_OrigTransfererChannel_: Alice's channel that called Voicemail.<br>

_OrigBridgeUniqueid_: Not present, since a call to Voicemail has no bridge.<br>

_SecondTransfererChannel_: Alice's channel in the bridge with Bob.<br>

_SecondBridgeUniqueid_: The bridge between Alice and Bob.<br>


### Syntax


```


    Event: AttendedTransfer
    Result: <value>
    OrigTransfererChannel: <value>
    OrigTransfererChannelState: <value>
    OrigTransfererChannelStateDesc: <value>
    OrigTransfererCallerIDNum: <value>
    OrigTransfererCallerIDName: <value>
    OrigTransfererConnectedLineNum: <value>
    OrigTransfererConnectedLineName: <value>
    OrigTransfererLanguage: <value>
    OrigTransfererAccountCode: <value>
    OrigTransfererContext: <value>
    OrigTransfererExten: <value>
    OrigTransfererPriority: <value>
    OrigTransfererUniqueid: <value>
    OrigTransfererLinkedid: <value>
    OrigBridgeUniqueid: <value>
    OrigBridgeType: <value>
    OrigBridgeTechnology: <value>
    OrigBridgeCreator: <value>
    OrigBridgeName: <value>
    OrigBridgeNumChannels: <value>
    OrigBridgeVideoSourceMode: <value>
    [OrigBridgeVideoSource:] <value>
    SecondTransfererChannel: <value>
    SecondTransfererChannelState: <value>
    SecondTransfererChannelStateDesc: <value>
    SecondTransfererCallerIDNum: <value>
    SecondTransfererCallerIDName: <value>
    SecondTransfererConnectedLineNum: <value>
    SecondTransfererConnectedLineName: <value>
    SecondTransfererLanguage: <value>
    SecondTransfererAccountCode: <value>
    SecondTransfererContext: <value>
    SecondTransfererExten: <value>
    SecondTransfererPriority: <value>
    SecondTransfererUniqueid: <value>
    SecondTransfererLinkedid: <value>
    SecondBridgeUniqueid: <value>
    SecondBridgeType: <value>
    SecondBridgeTechnology: <value>
    SecondBridgeCreator: <value>
    SecondBridgeName: <value>
    SecondBridgeNumChannels: <value>
    SecondBridgeVideoSourceMode: <value>
    [SecondBridgeVideoSource:] <value>
    DestType: <value>
    DestBridgeUniqueid: <value>
    DestApp: <value>
    LocalOneChannel: <value>
    LocalOneChannelState: <value>
    LocalOneChannelStateDesc: <value>
    LocalOneCallerIDNum: <value>
    LocalOneCallerIDName: <value>
    LocalOneConnectedLineNum: <value>
    LocalOneConnectedLineName: <value>
    LocalOneLanguage: <value>
    LocalOneAccountCode: <value>
    LocalOneContext: <value>
    LocalOneExten: <value>
    LocalOnePriority: <value>
    LocalOneUniqueid: <value>
    LocalOneLinkedid: <value>
    LocalTwoChannel: <value>
    LocalTwoChannelState: <value>
    LocalTwoChannelStateDesc: <value>
    LocalTwoCallerIDNum: <value>
    LocalTwoCallerIDName: <value>
    LocalTwoConnectedLineNum: <value>
    LocalTwoConnectedLineName: <value>
    LocalTwoLanguage: <value>
    LocalTwoAccountCode: <value>
    LocalTwoContext: <value>
    LocalTwoExten: <value>
    LocalTwoPriority: <value>
    LocalTwoUniqueid: <value>
    LocalTwoLinkedid: <value>
    DestTransfererChannel: <value>
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


* `OrigTransfererChannel`

* `OrigTransfererChannelState` - A numeric code for the channel's current state, related to OrigTransfererChannelStateDesc<br>

* `OrigTransfererChannelStateDesc`

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

* `OrigTransfererCallerIDNum`

* `OrigTransfererCallerIDName`

* `OrigTransfererConnectedLineNum`

* `OrigTransfererConnectedLineName`

* `OrigTransfererLanguage`

* `OrigTransfererAccountCode`

* `OrigTransfererContext`

* `OrigTransfererExten`

* `OrigTransfererPriority`

* `OrigTransfererUniqueid`

* `OrigTransfererLinkedid` - Uniqueid of the oldest channel associated with this channel.<br>

* `OrigBridgeUniqueid`

* `OrigBridgeType` - The type of bridge<br>

* `OrigBridgeTechnology` - Technology in use by the bridge<br>

* `OrigBridgeCreator` - Entity that created the bridge if applicable<br>

* `OrigBridgeName` - Name used to refer to the bridge by its BridgeCreator if applicable<br>

* `OrigBridgeNumChannels` - Number of channels in the bridge<br>

* `OrigBridgeVideoSourceMode` - 
    * `none`

    * `talker`

    * `single`
The video source mode for the bridge.<br>

* `OrigBridgeVideoSource` - If there is a video source for the bridge, the unique ID of the channel that is the video source.<br>

* `SecondTransfererChannel`

* `SecondTransfererChannelState` - A numeric code for the channel's current state, related to SecondTransfererChannelStateDesc<br>

* `SecondTransfererChannelStateDesc`

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

* `SecondTransfererCallerIDNum`

* `SecondTransfererCallerIDName`

* `SecondTransfererConnectedLineNum`

* `SecondTransfererConnectedLineName`

* `SecondTransfererLanguage`

* `SecondTransfererAccountCode`

* `SecondTransfererContext`

* `SecondTransfererExten`

* `SecondTransfererPriority`

* `SecondTransfererUniqueid`

* `SecondTransfererLinkedid` - Uniqueid of the oldest channel associated with this channel.<br>

* `SecondBridgeUniqueid`

* `SecondBridgeType` - The type of bridge<br>

* `SecondBridgeTechnology` - Technology in use by the bridge<br>

* `SecondBridgeCreator` - Entity that created the bridge if applicable<br>

* `SecondBridgeName` - Name used to refer to the bridge by its BridgeCreator if applicable<br>

* `SecondBridgeNumChannels` - Number of channels in the bridge<br>

* `SecondBridgeVideoSourceMode` - 
    * `none`

    * `talker`

    * `single`
The video source mode for the bridge.<br>

* `SecondBridgeVideoSource` - If there is a video source for the bridge, the unique ID of the channel that is the video source.<br>

* `DestType` - Indicates the method by which the attended transfer completed.<br>

    * `Bridge` - The transfer was accomplished by merging two bridges into one.<br>

    * `App` - The transfer was accomplished by having a channel or bridge run a dialplan application.<br>

    * `Link` - The transfer was accomplished by linking two bridges together using a local channel pair.<br>

    * `Threeway` - The transfer was accomplished by placing all parties into a threeway call.<br>

    * `Fail` - The transfer failed.<br>

* `DestBridgeUniqueid` - Indicates the surviving bridge when bridges were merged to complete the transfer<br>

    /// note
This header is only present when _DestType_ is 'Bridge' or 'Threeway'
///


* `DestApp` - Indicates the application that is running when the transfer completes<br>

    /// note
This header is only present when _DestType_ is 'App'
///


* `LocalOneChannel`

* `LocalOneChannelState` - A numeric code for the channel's current state, related to LocalOneChannelStateDesc<br>

* `LocalOneChannelStateDesc`

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

* `LocalOneCallerIDNum`

* `LocalOneCallerIDName`

* `LocalOneConnectedLineNum`

* `LocalOneConnectedLineName`

* `LocalOneLanguage`

* `LocalOneAccountCode`

* `LocalOneContext`

* `LocalOneExten`

* `LocalOnePriority`

* `LocalOneUniqueid`

* `LocalOneLinkedid` - Uniqueid of the oldest channel associated with this channel.<br>

* `LocalTwoChannel`

* `LocalTwoChannelState` - A numeric code for the channel's current state, related to LocalTwoChannelStateDesc<br>

* `LocalTwoChannelStateDesc`

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

* `LocalTwoCallerIDNum`

* `LocalTwoCallerIDName`

* `LocalTwoConnectedLineNum`

* `LocalTwoConnectedLineName`

* `LocalTwoLanguage`

* `LocalTwoAccountCode`

* `LocalTwoContext`

* `LocalTwoExten`

* `LocalTwoPriority`

* `LocalTwoUniqueid`

* `LocalTwoLinkedid` - Uniqueid of the oldest channel associated with this channel.<br>

* `DestTransfererChannel` - The name of the surviving transferer channel when a transfer results in a threeway call<br>

    /// note
This header is only present when _DestType_ is 'Threeway'
///


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

### Class

CALL
### See Also

* [AMI Actions AtxFer](/Asterisk_16_Documentation/API_Documentation/AMI_Actions/AtxFer)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 