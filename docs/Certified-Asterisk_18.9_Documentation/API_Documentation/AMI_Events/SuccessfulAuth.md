---
search:
  boost: 0.5
title: SuccessfulAuth
---

# SuccessfulAuth

### Synopsis

Raised when a request successfully authenticates with a service.

### Syntax


```


Event: SuccessfulAuth
EventTV: <value>
Severity: <value>
Service: <value>
EventVersion: <value>
AccountID: <value>
SessionID: <value>
LocalAddress: <value>
RemoteAddress: <value>
UsingPassword: <value>
[Module: <value>]
[SessionTV: <value>]

```
##### Arguments


* `EventTV` - The time the event was detected.<br>

* `Severity` - A relative severity of the security event.<br>

    * `Informational`

    * `Error`

* `Service` - The Asterisk service that raised the security event.<br>

* `EventVersion` - The version of this event.<br>

* `AccountID` - The Service account associated with the security event notification.<br>

* `SessionID` - A unique identifier for the session in the service that raised the event.<br>

* `LocalAddress` - The address of the Asterisk service that raised the security event.<br>

* `RemoteAddress` - The remote address of the entity that caused the security event to be raised.<br>

* `UsingPassword` - Whether or not the authentication attempt included a password.<br>

* `Module` - If available, the name of the module that raised the event.<br>

* `SessionTV` - The timestamp reported by the session.<br>

### Class

SECURITY

### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 