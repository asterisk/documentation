---
search:
  boost: 0.5
title: Hangup
---

# Hangup

### Synopsis

Raised when a channel is hung up.

### Syntax


```


Event: Hangup
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
Cause: <value>
Cause-txt: <value>

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

* `Cause` - A numeric cause code for why the channel was hung up.<br>

* `Cause-txt` - A description of why the channel was hung up.<br>

### Class

CALL
### See Also

* [AMI Events Newchannel](/Asterisk_18_Documentation/API_Documentation/AMI_Events/Newchannel)
* [AMI Events SoftHangupRequest](/Asterisk_18_Documentation/API_Documentation/AMI_Events/SoftHangupRequest)
* [AMI Events HangupRequest](/Asterisk_18_Documentation/API_Documentation/AMI_Events/HangupRequest)
* [AMI Events Newstate](/Asterisk_18_Documentation/API_Documentation/AMI_Events/Newstate)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 