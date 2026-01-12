---
search:
  boost: 0.5
title: Registry
---

# Registry

### Synopsis

Raised when an outbound registration completes.

### Syntax


```


Event: Registry
ChannelType: <value>
Username: <value>
Domain: <value>
Status: <value>
Cause: <value>

```
##### Arguments


* `ChannelType` - The type of channel that was registered (or not).<br>

* `Username` - The username portion of the registration.<br>

* `Domain` - The address portion of the registration.<br>

* `Status` - The status of the registration request.<br>

    * `Registered`

    * `Unregistered`

    * `Rejected`

    * `Failed`

* `Cause` - What caused the rejection of the request, if available.<br>

### Class

SYSTEM

### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 