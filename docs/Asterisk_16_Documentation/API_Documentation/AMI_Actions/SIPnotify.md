---
search:
  boost: 0.5
title: SIPnotify
---

# SIPnotify

### Synopsis

Send a SIP notify.

### Description

Sends a SIP Notify event.<br>

All parameters for this event must be specified in the body of this request via multiple 'Variable: name=value' sequences.<br>


### Syntax


```


    Action: SIPnotify
    ActionID: <value>
    Channel: <value>
    Variable: <value>
    [Call-ID:] <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Channel` - Peer to receive the notify.<br>

* `Variable` - At least one variable pair must be specified. _name_=_value_<br>

* `Call-ID` - When specified, SIP notity will be sent as a part of an existing dialog.<br>


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 