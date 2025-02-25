---
search:
  boost: 0.5
title: MessageWaiting
---

# MessageWaiting

### Synopsis

Raised when the state of messages in a voicemail mailbox has changed or when a channel has finished interacting with a mailbox.

### Description


/// note
The Channel related parameters are only present if a channel was involved in the manipulation of a mailbox. If no channel is involved, the parameters are not included with the event.
///


### Syntax


```


    Event: MessageWaiting
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
    Mailbox: <value>
    Waiting: <value>
    New: <value>
    Old: <value>

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

* `Mailbox` - The mailbox with the new message, specified as 'mailbox'@'context'<br>

* `Waiting` - Whether or not the mailbox has messages waiting for it.<br>

* `New` - The number of new messages.<br>

* `Old` - The number of old messages.<br>

### Class

CALL

### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 