---
search:
  boost: 0.5
title: AorDetail
---

# AorDetail

### Synopsis

Provide details about an Address of Record (AoR) section.

### Syntax


```


Event: AorDetail
ObjectType: <value>
ObjectName: <value>
MinimumExpiration: <value>
MaximumExpiration: <value>
DefaultExpiration: <value>
QualifyFrequency: <value>
AuthenticateQualify: <value>
MaxContacts: <value>
RemoveExisting: <value>
RemoveUnavailable: <value>
Mailboxes: <value>
OutboundProxy: <value>
SupportPath: <value>
TotalContacts: <value>
ContactsRegistered: <value>
EndpointName: <value>

```
##### Arguments


* `ObjectType` - The object's type. This will always be 'aor'.<br>

* `ObjectName` - The name of this object.<br>

* `MinimumExpiration` - Minimum keep alive time for an AoR<br>

* `MaximumExpiration` - Maximum time to keep an AoR<br>

* `DefaultExpiration` - Default expiration time in seconds for contacts that are dynamically bound to an AoR.<br>

* `QualifyFrequency` - Interval at which to qualify an AoR<br>

* `AuthenticateQualify` - Authenticates a qualify challenge response if needed<br>

* `MaxContacts` - Maximum number of contacts that can bind to an AoR<br>

* `RemoveExisting` - Determines whether new contacts replace existing ones.<br>

* `RemoveUnavailable` - Determines whether new contacts should replace unavailable ones.<br>

* `Mailboxes` - Allow subscriptions for the specified mailbox(es)<br>

* `OutboundProxy` - Outbound proxy used when sending OPTIONS request<br>

* `SupportPath` - Enables Path support for REGISTER requests and Route support for other requests.<br>

* `TotalContacts` - The total number of contacts associated with this AoR.<br>

* `ContactsRegistered` - The number of non-permanent contacts associated with this AoR.<br>

* `EndpointName` - The name of the endpoint associated with this information.<br>

### Class

COMMAND

### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 