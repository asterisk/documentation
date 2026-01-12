---
search:
  boost: 0.5
title: Originate
---

# Originate

### Synopsis

Originate a call.

### Description

Generates an outgoing call to a _Extension_/_Context_/_Priority_ or _Application_/_Data_<br>


### Syntax


```


Action: Originate
ActionID: <value>
Channel: <value>
Exten: <value>
Context: <value>
Priority: <value>
Application: <value>
Data: <value>
Timeout: <value>
CallerID: <value>
Variable: <value>
Account: <value>
EarlyMedia: <value>
Async: <value>
Codecs: <value>
ChannelId: <value>
OtherChannelId: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Channel` - Channel name to call.<br>

* `Exten` - Extension to use (requires 'Context' and 'Priority')<br>

* `Context` - Context to use (requires 'Exten' and 'Priority')<br>

* `Priority` - Priority to use (requires 'Exten' and 'Context')<br>

* `Application` - Application to execute.<br>

* `Data` - Data to use (requires 'Application').<br>

* `Timeout` - How long to wait for call to be answered (in ms.).<br>

* `CallerID` - Caller ID to be set on the outgoing channel.<br>

* `Variable` - Channel variable to set, multiple Variable: headers are allowed.<br>

* `Account` - Account code.<br>

* `EarlyMedia` - Set to 'true' to force call bridge on early media..<br>

* `Async` - Set to 'true' for fast origination.<br>

* `Codecs` - Comma-separated list of codecs to use for this call.<br>

* `ChannelId` - Channel UniqueId to be set on the channel.<br>

* `OtherChannelId` - Channel UniqueId to be set on the second local channel.<br>

### See Also

* [AMI Events OriginateResponse](/Certified-Asterisk_18.9_Documentation/API_Documentation/AMI_Events/OriginateResponse)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 