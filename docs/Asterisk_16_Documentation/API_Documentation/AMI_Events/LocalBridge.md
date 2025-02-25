---
search:
  boost: 0.5
title: LocalBridge
---

# LocalBridge

### Synopsis

Raised when two halves of a Local Channel form a bridge.

### Syntax


```


    Event: LocalBridge
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
    Context: <value>
    Exten: <value>
    LocalOptimization: <value>

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

* `Context` - The context in the dialplan that Channel2 starts in.<br>

* `Exten` - The extension in the dialplan that Channel2 starts in.<br>

* `LocalOptimization`

    * `Yes`

    * `No`

### Class

CALL

### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 