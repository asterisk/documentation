---
search:
  boost: 0.5
title: LocalOptimizationEnd
---

# LocalOptimizationEnd

### Synopsis

Raised when two halves of a Local Channel have finished optimizing themselves out of the media path.

### Syntax


```


Event: LocalOptimizationEnd
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
Success: <value>
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

* `Success` - Indicates whether the local optimization succeeded.<br>

* `Id` - Identification for the optimization operation. Matches the _Id_ from a previous 'LocalOptimizationBegin'<br>

### Class

CALL
### See Also

* [AMI Events LocalOptimizationBegin](/Asterisk_18_Documentation/API_Documentation/AMI_Events/LocalOptimizationBegin)
* [AMI Actions LocalOptimizeAway](/Asterisk_18_Documentation/API_Documentation/AMI_Actions/LocalOptimizeAway)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 