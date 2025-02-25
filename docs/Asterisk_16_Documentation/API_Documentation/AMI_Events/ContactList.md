---
search:
  boost: 0.5
title: ContactList
---

# ContactList

### Synopsis

Provide details about a contact section.

### Syntax


```


    Event: ContactList
    ObjectType: <value>
    ObjectName: <value>
    ViaAddr: <value>
    ViaPort: <value>
    QualifyTimeout: <value>
    CallId: <value>
    RegServer: <value>
    PruneOnBoot: <value>
    Path: <value>
    Endpoint: <value>
    AuthenticateQualify: <value>
    Uri: <value>
    QualifyFrequency: <value>
    UserAgent: <value>
    ExpirationTime: <value>
    OutboundProxy: <value>
    Status: <value>
    RoundtripUsec: <value>

```
##### Arguments


* `ObjectType` - The object's type. This will always be 'contact'.<br>

* `ObjectName` - The name of this object.<br>

* `ViaAddr` - IP address of the last Via header in REGISTER request. Will only appear in the event if available.<br>

* `ViaPort` - Port number of the last Via header in REGISTER request. Will only appear in the event if available.<br>

* `QualifyTimeout` - The elapsed time in decimal seconds after which an OPTIONS message is sent before the contact is considered unavailable.<br>

* `CallId` - Content of the Call-ID header in REGISTER request. Will only appear in the event if available.<br>

* `RegServer` - Asterisk Server name.<br>

* `PruneOnBoot` - If true delete the contact on Asterisk restart/boot.<br>

* `Path` - The Path header received on the REGISTER.<br>

* `Endpoint` - The name of the endpoint associated with this information.<br>

* `AuthenticateQualify` - A boolean indicating whether a qualify should be authenticated.<br>

* `Uri` - This contact's URI.<br>

* `QualifyFrequency` - The interval in seconds at which the contact will be qualified.<br>

* `UserAgent` - Content of the User-Agent header in REGISTER request<br>

* `ExpirationTime` - Absolute time that this contact is no longer valid after<br>

* `OutboundProxy` - The contact's outbound proxy.<br>

* `Status` - This contact's status.<br>

    * `Reachable`

    * `Unreachable`

    * `NonQualified`

    * `Unknown`

* `RoundtripUsec` - The round trip time in microseconds.<br>

### Class

COMMAND

### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 