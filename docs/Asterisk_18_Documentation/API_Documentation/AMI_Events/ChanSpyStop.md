---
search:
  boost: 0.5
title: ChanSpyStop
---

# ChanSpyStop

### Synopsis

Raised when a channel has stopped spying.

### Syntax


```


Event: ChanSpyStop
SpyerChannel: <value>
SpyerChannelState: <value>
SpyerChannelStateDesc: <value>
SpyerCallerIDNum: <value>
SpyerCallerIDName: <value>
SpyerConnectedLineNum: <value>
SpyerConnectedLineName: <value>
SpyerLanguage: <value>
SpyerAccountCode: <value>
SpyerContext: <value>
SpyerExten: <value>
SpyerPriority: <value>
SpyerUniqueid: <value>
SpyerLinkedid: <value>
SpyeeChannel: <value>
SpyeeChannelState: <value>
SpyeeChannelStateDesc: <value>
SpyeeCallerIDNum: <value>
SpyeeCallerIDName: <value>
SpyeeConnectedLineNum: <value>
SpyeeConnectedLineName: <value>
SpyeeLanguage: <value>
SpyeeAccountCode: <value>
SpyeeContext: <value>
SpyeeExten: <value>
SpyeePriority: <value>
SpyeeUniqueid: <value>
SpyeeLinkedid: <value>

```
##### Arguments


* `SpyerChannel`

* `SpyerChannelState` - A numeric code for the channel's current state, related to SpyerChannelStateDesc<br>

* `SpyerChannelStateDesc`

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

* `SpyerCallerIDNum`

* `SpyerCallerIDName`

* `SpyerConnectedLineNum`

* `SpyerConnectedLineName`

* `SpyerLanguage`

* `SpyerAccountCode`

* `SpyerContext`

* `SpyerExten`

* `SpyerPriority`

* `SpyerUniqueid`

* `SpyerLinkedid` - Uniqueid of the oldest channel associated with this channel.<br>

* `SpyeeChannel`

* `SpyeeChannelState` - A numeric code for the channel's current state, related to SpyeeChannelStateDesc<br>

* `SpyeeChannelStateDesc`

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

* `SpyeeCallerIDNum`

* `SpyeeCallerIDName`

* `SpyeeConnectedLineNum`

* `SpyeeConnectedLineName`

* `SpyeeLanguage`

* `SpyeeAccountCode`

* `SpyeeContext`

* `SpyeeExten`

* `SpyeePriority`

* `SpyeeUniqueid`

* `SpyeeLinkedid` - Uniqueid of the oldest channel associated with this channel.<br>

### Class

CALL
### See Also

* [AMI Events ChanSpyStart](/Asterisk_18_Documentation/API_Documentation/AMI_Events/ChanSpyStart)
* [Dialplan Applications ChanSpy](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/ChanSpy)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 