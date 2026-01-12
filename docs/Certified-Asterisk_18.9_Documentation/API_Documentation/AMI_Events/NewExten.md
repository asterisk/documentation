---
search:
  boost: 0.5
title: NewExten
---

# NewExten

### Synopsis

Raised when a channel enters a new context, extension, priority.

### Syntax


```


Event: NewExten
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
Extension: <value>
Application: <value>
AppData: <value>

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

* `Extension` - Deprecated in 12, but kept for backward compatability. Please use 'Exten' instead.<br>

* `Application` - The application about to be executed.<br>

* `AppData` - The data to be passed to the application.<br>

### Class

DIALPLAN

### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 