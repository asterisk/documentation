---
search:
  boost: 0.5
title: ContactStatus
---

# ContactStatus

### Synopsis

Raised when the state of a contact changes.

### Syntax


```


Event: ContactStatus
URI: <value>
ContactStatus: <value>
AOR: <value>
EndpointName: <value>
RoundtripUsec: <value>

```
##### Arguments


* `URI` - This contact's URI.<br>

* `ContactStatus` - New status of the contact.<br>

    * `Unknown`

    * `Unreachable`

    * `Reachable`

    * `Unqualified`

    * `Removed`

    * `Updated`

* `AOR` - The name of the associated aor.<br>

* `EndpointName` - The name of the associated endpoint.<br>

* `RoundtripUsec` - The RTT measured during the last qualify.<br>

### Class

SYSTEM

### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 