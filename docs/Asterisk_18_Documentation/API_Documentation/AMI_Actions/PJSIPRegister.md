---
search:
  boost: 0.5
title: PJSIPRegister
---

# PJSIPRegister

### Synopsis

Register an outbound registration.

### Description

Unregisters the specified (or all) outbound registration(s) then starts registration and schedules re-registrations according to configuration.<br>


### Syntax


```


Action: PJSIPRegister
ActionID: <value>
Registration: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Registration` - The outbound registration to register or '*all' to register them all.<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 