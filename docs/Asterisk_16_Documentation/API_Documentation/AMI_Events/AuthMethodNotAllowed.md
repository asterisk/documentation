---
search:
  boost: 0.5
title: AuthMethodNotAllowed
---

# AuthMethodNotAllowed

### Synopsis

Raised when a request used an authentication method not allowed by the service.

### Syntax


```


    Event: AuthMethodNotAllowed
    EventTV: <value>
    Severity: <value>
    Service: <value>
    EventVersion: <value>
    AccountID: <value>
    SessionID: <value>
    LocalAddress: <value>
    RemoteAddress: <value>
    AuthMethod: <value>
    [Module:] <value>
    [SessionTV:] <value>

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

* `AuthMethod` - The authentication method attempted.<br>

* `Module` - If available, the name of the module that raised the event.<br>

* `SessionTV` - The timestamp reported by the session.<br>

### Class

SECURITY

### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 