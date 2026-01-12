---
search:
  boost: 0.5
title: EndpointList
---

# EndpointList

### Synopsis

Provide details about a contact's status.

### Syntax


```


Event: EndpointList
ObjectType: <value>
ObjectName: <value>
Transport: <value>
Aor: <value>
Auths: <value>
OutboundAuths: <value>
DeviceState: <value>
ActiveChannels: <value>

```
##### Arguments


* `ObjectType` - The object's type. This will always be 'endpoint'.<br>

* `ObjectName` - The name of this object.<br>

* `Transport` - The transport configurations associated with this endpoint.<br>

* `Aor` - The aor configurations associated with this endpoint.<br>

* `Auths` - The inbound authentication configurations associated with this endpoint.<br>

* `OutboundAuths` - The outbound authentication configurations associated with this endpoint.<br>

* `DeviceState` - The aggregate device state for this endpoint.<br>

* `ActiveChannels` - The number of active channels associated with this endpoint.<br>

### Class

COMMAND

### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 