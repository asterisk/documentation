---
search:
  boost: 0.5
title: ChallengeResponseFailed
---

# ChallengeResponseFailed

### Synopsis

Raised when a request's attempt to authenticate has been challenged, and the request failed the authentication challenge.

### Syntax


```


Event: ChallengeResponseFailed
EventTV: <value>
Severity: <value>
Service: <value>
EventVersion: <value>
AccountID: <value>
SessionID: <value>
LocalAddress: <value>
RemoteAddress: <value>
Challenge: <value>
Response: <value>
ExpectedResponse: <value>
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

* `Challenge` - The challenge that was sent.<br>

* `Response` - The response that was received.<br>

* `ExpectedResponse` - The expected response to the challenge.<br>

* `Module` - If available, the name of the module that raised the event.<br>

* `SessionTV` - The timestamp reported by the session.<br>

### Class

SECURITY

### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 