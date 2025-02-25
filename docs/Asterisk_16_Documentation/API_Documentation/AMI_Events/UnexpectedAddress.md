---
search:
  boost: 0.5
title: UnexpectedAddress
---

# UnexpectedAddress

### Synopsis

Raised when a request has a different source address then what is expected for a session already in progress with a service.

### Syntax


```


    Event: UnexpectedAddress
    EventTV: <value>
    Severity: <value>
    Service: <value>
    EventVersion: <value>
    AccountID: <value>
    SessionID: <value>
    LocalAddress: <value>
    RemoteAddress: <value>
    ExpectedAddress: <value>
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

* `ExpectedAddress` - The address that the request was expected to use.<br>

* `Module` - If available, the name of the module that raised the event.<br>

* `SessionTV` - The timestamp reported by the session.<br>

### Class

SECURITY

### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 