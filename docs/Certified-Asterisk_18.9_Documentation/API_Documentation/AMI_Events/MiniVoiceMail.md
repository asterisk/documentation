---
search:
  boost: 0.5
title: MiniVoiceMail
---

# MiniVoiceMail

### Synopsis

Raised when a notification is sent out by a MiniVoiceMail application

### Syntax


```


Event: MiniVoiceMail
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
Action: <value>
Mailbox: <value>
Counter: <value>

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

* `Action` - What action was taken. Currently, this will always be 'SentNotification'<br>

* `Mailbox` - The mailbox that the notification was about, specified as 'mailbox'@'context'<br>

* `Counter` - A message counter derived from the 'MVM\_COUNTER' channel variable.<br>

### Class

CALL

### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 