---
search:
  boost: 0.5
title: ContactStatusDetail
---

# ContactStatusDetail

### Synopsis

Provide details about a contact's status.

### Syntax


```


    Event: ContactStatusDetail
    AOR: <value>
    URI: <value>
    Status: <value>
    RoundtripUsec: <value>
    EndpointName: <value>
    UserAgent: <value>
    RegExpire: <value>
    ViaAddress: <value>
    CallID: <value>
    ID: <value>
    AuthenticateQualify: <value>
    OutboundProxy: <value>
    Path: <value>
    QualifyFrequency: <value>
    QualifyTimeout: <value>

```
##### Arguments


* `AOR` - The AoR that owns this contact.<br>

* `URI` - This contact's URI.<br>

* `Status` - This contact's status.<br>

    * `Reachable`

    * `Unreachable`

    * `NonQualified`

    * `Unknown`

* `RoundtripUsec` - The round trip time in microseconds.<br>

* `EndpointName` - The name of the endpoint associated with this information.<br>

* `UserAgent` - Content of the User-Agent header in REGISTER request<br>

* `RegExpire` - Absolute time that this contact is no longer valid after<br>

* `ViaAddress` - IP address:port of the last Via header in REGISTER request. Will only appear in the event if available.<br>

* `CallID` - Content of the Call-ID header in REGISTER request. Will only appear in the event if available.<br>

* `ID` - The sorcery ID of the contact.<br>

* `AuthenticateQualify` - A boolean indicating whether a qualify should be authenticated.<br>

* `OutboundProxy` - The contact's outbound proxy.<br>

* `Path` - The Path header received on the REGISTER.<br>

* `QualifyFrequency` - The interval in seconds at which the contact will be qualified.<br>

* `QualifyTimeout` - The elapsed time in decimal seconds after which an OPTIONS message is sent before the contact is considered unavailable.<br>

### Class

COMMAND

### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 