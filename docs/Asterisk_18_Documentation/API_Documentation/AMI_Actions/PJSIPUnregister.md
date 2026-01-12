---
search:
  boost: 0.5
title: PJSIPUnregister
---

# PJSIPUnregister

### Synopsis

Unregister an outbound registration.

### Description

Unregisters the specified (or all) outbound registration(s) and stops future registration attempts. Call PJSIPRegister to start registration and schedule re-registrations according to configuration.<br>


### Syntax


```


Action: PJSIPUnregister
ActionID: <value>
Registration: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Registration` - The outbound registration to unregister or '*all' to unregister them all.<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 