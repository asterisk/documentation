---
search:
  boost: 0.5
title: IdentifyDetail
---

# IdentifyDetail

### Synopsis

Provide details about an identify section.

### Syntax


```


Event: IdentifyDetail
ObjectType: <value>
ObjectName: <value>
Endpoint: <value>
SrvLookups: <value>
Match: <value>
MatchHeader: <value>
EndpointName: <value>

```
##### Arguments


* `ObjectType` - The object's type. This will always be 'identify'.<br>

* `ObjectName` - The name of this object.<br>

* `Endpoint` - Name of endpoint identified<br>

* `SrvLookups` - Perform SRV lookups for provided hostnames.<br>

* `Match` - IP addresses or networks to match against.<br>

* `MatchHeader` - Header/value pair to match against.<br>

* `EndpointName` - The name of the endpoint associated with this information.<br>

### Class

COMMAND

### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 