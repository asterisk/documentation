---
search:
  boost: 0.5
title: HangupHandlerPush
---

# HangupHandlerPush

### Synopsis

Raised when a hangup handler is added to the handler stack by the CHANNEL() function.

### Syntax


```


Event: HangupHandlerPush
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
Handler: <value>

```
##### Arguments


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

* `Handler` - Hangup handler parameter string passed to the Gosub application.<br>

### Class

DIALPLAN
### See Also

* [AMI Events HangupHandlerPop](/Certified-Asterisk_18.9_Documentation/API_Documentation/AMI_Events/HangupHandlerPop)
* [Dialplan Functions CHANNEL](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/CHANNEL)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 