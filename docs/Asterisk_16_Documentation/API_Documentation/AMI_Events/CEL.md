---
search:
  boost: 0.5
title: CEL
---

# CEL

### Synopsis

Raised when a Channel Event Log is generated for a channel.

### Syntax


```


    Event: CEL
    EventName: <value>
    AccountCode: <value>
    CallerIDnum: <value>
    CallerIDname: <value>
    CallerIDani: <value>
    CallerIDrdnis: <value>
    CallerIDdnid: <value>
    Exten: <value>
    Context: <value>
    Application: <value>
    AppData: <value>
    EventTime: <value>
    AMAFlags: <value>
    UniqueID: <value>
    LinkedID: <value>
    UserField: <value>
    Peer: <value>
    PeerAccount: <value>
    Extra: <value>

```
##### Arguments


* `EventName` - The name of the CEL event being raised. This can include both the system defined CEL events, as well as user defined events.<br>

    /// note
All events listed here may not be raised, depending on the configuration in *cel.conf*.
///


    * `CHAN_START` - A channel was created.<br>

    * `CHAN_END` - A channel was terminated.<br>

    * `ANSWER` - A channel answered.<br>

    * `HANGUP` - A channel was hung up.<br>

    * `BRIDGE_ENTER` - A channel entered a bridge.<br>

    * `BRIDGE_EXIT` - A channel left a bridge.<br>

    * `APP_START` - A channel entered into a tracked application.<br>

    * `APP_END` - A channel left a tracked application.<br>

    * `PARK_START` - A channel was parked.<br>

    * `PARK_END` - A channel was unparked.<br>

    * `BLINDTRANSFER` - A channel initiated a blind transfer.<br>

    * `ATTENDEDTRANSFER` - A channel initiated an attended transfer.<br>

    * `PICKUP` - A channel initated a call pickup.<br>

    * `FORWARD` - A channel is being forwarded to another destination.<br>

    * `LINKEDID_END` - The linked ID associated with this channel is being retired.<br>

    * `LOCAL_OPTIMIZE` - A Local channel optimization has occurred.<br>

    * `USER_DEFINED` - A user defined type.<br>

        /// note
This event is only present if 'show\_user\_defined' in *cel.conf* is 'True'. Otherwise, the user defined event will be placed directly in the _EventName_ field.
///


* `AccountCode` - The channel's account code.<br>

* `CallerIDnum` - The Caller ID number.<br>

* `CallerIDname` - The Caller ID name.<br>

* `CallerIDani` - The Caller ID Automatic Number Identification.<br>

* `CallerIDrdnis` - The Caller ID Redirected Dialed Number Identification Service.<br>

* `CallerIDdnid` - The Caller ID Dialed Number Identifier.<br>

* `Exten` - The dialplan extension the channel is currently executing in.<br>

* `Context` - The dialplan context the channel is currently executing in.<br>

* `Application` - The dialplan application the channel is currently executing.<br>

* `AppData` - The arguments passed to the dialplan _Application_.<br>

* `EventTime` - The time the CEL event occurred.<br>

* `AMAFlags` - A flag that informs a billing system how to treat the CEL.<br>

    * `OMIT` - This event should be ignored.<br>

    * `BILLING` - This event contains valid billing data.<br>

    * `DOCUMENTATION` - This event is for documentation purposes.<br>

* `UniqueID` - The unique ID of the channel.<br>

* `LinkedID` - The linked ID of the channel, which ties this event to other related channel's events.<br>

* `UserField` - A user defined field set on a channel, containing arbitrary application specific data.<br>

* `Peer` - If this channel is in a bridge, the channel that it is in a bridge with.<br>

* `PeerAccount` - If this channel is in a bridge, the accountcode of the channel it is in a bridge with.<br>

* `Extra` - Some events will have event specific data that accompanies the CEL record. This extra data is JSON encoded, and is dependent on the event in question.<br>

### Class

CEL

### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 