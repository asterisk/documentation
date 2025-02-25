---
search:
  boost: 0.5
title: RequestNotAllowed
---

# RequestNotAllowed

### Synopsis

Raised when a request is not allowed by the service.

### Syntax


```


    Event: RequestNotAllowed
    EventTV: <value>
    Severity: <value>
    Service: <value>
    EventVersion: <value>
    AccountID: <value>
    SessionID: <value>
    LocalAddress: <value>
    RemoteAddress: <value>
    RequestType: <value>
    [Module:] <value>
    [SessionTV:] <value>
    [RequestParams:] <value>

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

* `RequestType` - The type of request attempted.<br>

* `Module` - If available, the name of the module that raised the event.<br>

* `SessionTV` - The timestamp reported by the session.<br>

* `RequestParams` - Parameters provided to the rejected request.<br>

### Class

SECURITY

### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 