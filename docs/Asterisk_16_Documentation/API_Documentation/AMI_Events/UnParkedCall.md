---
search:
  boost: 0.5
title: UnParkedCall
---

# UnParkedCall

### Synopsis

Raised when a channel leaves a parking lot because it was retrieved from the parking lot and reconnected.

### Syntax


```


    Event: UnParkedCall
    ParkeeChannel: <value>
    ParkeeChannelState: <value>
    ParkeeChannelStateDesc: <value>
    ParkeeCallerIDNum: <value>
    ParkeeCallerIDName: <value>
    ParkeeConnectedLineNum: <value>
    ParkeeConnectedLineName: <value>
    ParkeeLanguage: <value>
    ParkeeAccountCode: <value>
    ParkeeContext: <value>
    ParkeeExten: <value>
    ParkeePriority: <value>
    ParkeeUniqueid: <value>
    ParkeeLinkedid: <value>
    ParkerChannel: <value>
    ParkerChannelState: <value>
    ParkerChannelStateDesc: <value>
    ParkerCallerIDNum: <value>
    ParkerCallerIDName: <value>
    ParkerConnectedLineNum: <value>
    ParkerConnectedLineName: <value>
    ParkerLanguage: <value>
    ParkerAccountCode: <value>
    ParkerContext: <value>
    ParkerExten: <value>
    ParkerPriority: <value>
    ParkerUniqueid: <value>
    ParkerLinkedid: <value>
    ParkerDialString: <value>
    Parkinglot: <value>
    ParkingSpace: <value>
    ParkingTimeout: <value>
    ParkingDuration: <value>
    RetrieverChannel: <value>
    RetrieverChannelState: <value>
    RetrieverChannelStateDesc: <value>
    RetrieverCallerIDNum: <value>
    RetrieverCallerIDName: <value>
    RetrieverConnectedLineNum: <value>
    RetrieverConnectedLineName: <value>
    RetrieverLanguage: <value>
    RetrieverAccountCode: <value>
    RetrieverContext: <value>
    RetrieverExten: <value>
    RetrieverPriority: <value>
    RetrieverUniqueid: <value>
    RetrieverLinkedid: <value>

```
##### Arguments


* `ParkeeChannel`

* `ParkeeChannelState` - A numeric code for the channel's current state, related to ParkeeChannelStateDesc<br>

* `ParkeeChannelStateDesc`

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

* `ParkeeCallerIDNum`

* `ParkeeCallerIDName`

* `ParkeeConnectedLineNum`

* `ParkeeConnectedLineName`

* `ParkeeLanguage`

* `ParkeeAccountCode`

* `ParkeeContext`

* `ParkeeExten`

* `ParkeePriority`

* `ParkeeUniqueid`

* `ParkeeLinkedid` - Uniqueid of the oldest channel associated with this channel.<br>

* `ParkerChannel`

* `ParkerChannelState` - A numeric code for the channel's current state, related to ParkerChannelStateDesc<br>

* `ParkerChannelStateDesc`

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

* `ParkerCallerIDNum`

* `ParkerCallerIDName`

* `ParkerConnectedLineNum`

* `ParkerConnectedLineName`

* `ParkerLanguage`

* `ParkerAccountCode`

* `ParkerContext`

* `ParkerExten`

* `ParkerPriority`

* `ParkerUniqueid`

* `ParkerLinkedid` - Uniqueid of the oldest channel associated with this channel.<br>

* `ParkerDialString` - Dial String that can be used to call back the parker on ParkingTimeout.<br>

* `Parkinglot` - Name of the parking lot that the parkee is parked in<br>

* `ParkingSpace` - Parking Space that the parkee is parked in<br>

* `ParkingTimeout` - Time remaining until the parkee is forcefully removed from parking in seconds<br>

* `ParkingDuration` - Time the parkee has been in the parking bridge (in seconds)<br>

* `RetrieverChannel`

* `RetrieverChannelState` - A numeric code for the channel's current state, related to RetrieverChannelStateDesc<br>

* `RetrieverChannelStateDesc`

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

* `RetrieverCallerIDNum`

* `RetrieverCallerIDName`

* `RetrieverConnectedLineNum`

* `RetrieverConnectedLineName`

* `RetrieverLanguage`

* `RetrieverAccountCode`

* `RetrieverContext`

* `RetrieverExten`

* `RetrieverPriority`

* `RetrieverUniqueid`

* `RetrieverLinkedid` - Uniqueid of the oldest channel associated with this channel.<br>

### Class

CALL

### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 