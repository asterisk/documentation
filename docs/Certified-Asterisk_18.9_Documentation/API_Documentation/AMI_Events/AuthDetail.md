---
search:
  boost: 0.5
title: AuthDetail
---

# AuthDetail

### Synopsis

Provide details about an authentication section.

### Syntax


```


Event: AuthDetail
ObjectType: <value>
ObjectName: <value>
Username: <value>
Password: <value>
Md5Cred: <value>
Realm: <value>
NonceLifetime: <value>
AuthType: <value>
EndpointName: <value>

```
##### Arguments


* `ObjectType` - The object's type. This will always be 'auth'.<br>

* `ObjectName` - The name of this object.<br>

* `Username` - Username to use for account<br>

* `Password` - Username to use for account<br>

* `Md5Cred` - MD5 Hash used for authentication.<br>

* `Realm` - SIP realm for endpoint<br>

* `NonceLifetime` - Lifetime of a nonce associated with this authentication config.<br>

* `AuthType` - Authentication type<br>

* `EndpointName` - The name of the endpoint associated with this information.<br>

### Class

COMMAND

### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 