---
search:
  boost: 0.5
title: LocalOptimizationBegin
---

# LocalOptimizationBegin

### Synopsis

Raised when two halves of a Local Channel begin to optimize themselves out of the media path.

### Syntax


```


    Event: LocalOptimizationBegin
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
    SourceChannel: <value>
    SourceChannelState: <value>
    SourceChannelStateDesc: <value>
    SourceCallerIDNum: <value>
    SourceCallerIDName: <value>
    SourceConnectedLineNum: <value>
    SourceConnectedLineName: <value>
    SourceLanguage: <value>
    SourceAccountCode: <value>
    SourceContext: <value>
    SourceExten: <value>
    SourcePriority: <value>
    SourceUniqueid: <value>
    SourceLinkedid: <value>
    DestUniqueId: <value>
    Id: <value>

```
##### Arguments


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

* `SourceChannel`

* `SourceChannelState` - A numeric code for the channel's current state, related to SourceChannelStateDesc<br>

* `SourceChannelStateDesc`

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

* `SourceCallerIDNum`

* `SourceCallerIDName`

* `SourceConnectedLineNum`

* `SourceConnectedLineName`

* `SourceLanguage`

* `SourceAccountCode`

* `SourceContext`

* `SourceExten`

* `SourcePriority`

* `SourceUniqueid`

* `SourceLinkedid` - Uniqueid of the oldest channel associated with this channel.<br>

* `DestUniqueId` - The unique ID of the bridge into which the local channel is optimizing.<br>

* `Id` - Identification for the optimization operation.<br>

### Class

CALL
### See Also

* [AMI Events LocalOptimizationEnd](/Asterisk_16_Documentation/API_Documentation/AMI_Events/LocalOptimizationEnd)
* [AMI Actions LocalOptimizeAway](/Asterisk_16_Documentation/API_Documentation/AMI_Actions/LocalOptimizeAway)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 