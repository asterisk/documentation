---
search:
  boost: 0.5
title: Cdr
---

# Cdr

### Synopsis

Raised when a CDR is generated.

### Description

The _Cdr_ event is only raised when the *cdr\_manager* backend is loaded and registered with the CDR engine.<br>


/// note
This event can contain additional fields depending on the configuration provided by *cdr\_manager.conf*.
///


### Syntax


```


Event: Cdr
AccountCode: <value>
Source: <value>
Destination: <value>
DestinationContext: <value>
CallerID: <value>
Channel: <value>
DestinationChannel: <value>
LastApplication: <value>
LastData: <value>
StartTime: <value>
AnswerTime: <value>
EndTime: <value>
Duration: <value>
BillableSeconds: <value>
Disposition: <value>
AMAFlags: <value>
UniqueID: <value>
UserField: <value>

```
##### Arguments


* `AccountCode` - The account code of the Party A channel.<br>

* `Source` - The Caller ID number associated with the Party A in the CDR.<br>

* `Destination` - The dialplan extension the Party A was executing.<br>

* `DestinationContext` - The dialplan context the Party A was executing.<br>

* `CallerID` - The Caller ID name associated with the Party A in the CDR.<br>

* `Channel` - The channel name of the Party A.<br>

* `DestinationChannel` - The channel name of the Party B.<br>

* `LastApplication` - The last dialplan application the Party A executed.<br>

* `LastData` - The parameters passed to the last dialplan application the Party A executed.<br>

* `StartTime` - The time the CDR was created.<br>

* `AnswerTime` - The earliest of either the time when Party A answered, or the start time of this CDR.<br>

* `EndTime` - The time when the CDR was finished. This occurs when the Party A hangs up or when the bridge between Party A and Party B is broken.<br>

* `Duration` - The time, in seconds, of _EndTime_ - _StartTime_.<br>

* `BillableSeconds` - The time, in seconds, of _AnswerTime_ - _StartTime_.<br>

* `Disposition` - The final known disposition of the CDR.<br>

    * `NO ANSWER` - The channel was not answered. This is the default disposition.<br>

    * `FAILED` - The channel attempted to dial but the call failed.<br>

        /// note
The congestion setting in *cdr.conf* can result in the 'AST\_CAUSE\_CONGESTION' hang up cause or the 'CONGESTION' dial status to map to this disposition.
///


    * `BUSY` - The channel attempted to dial but the remote party was busy.<br>

    * `ANSWERED` - The channel was answered. The hang up cause will no longer impact the disposition of the CDR.<br>

    * `CONGESTION` - The channel attempted to dial but the remote party was congested.<br>

* `AMAFlags` - A flag that informs a billing system how to treat the CDR.<br>

    * `OMIT` - This CDR should be ignored.<br>

    * `BILLING` - This CDR contains valid billing data.<br>

    * `DOCUMENTATION` - This CDR is for documentation purposes.<br>

* `UniqueID` - A unique identifier for the Party A channel.<br>

* `UserField` - A user defined field set on the channels. If set on both the Party A and Party B channel, the userfields of both are concatenated and separated by a ';'.<br>

### Class

CDR

### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 