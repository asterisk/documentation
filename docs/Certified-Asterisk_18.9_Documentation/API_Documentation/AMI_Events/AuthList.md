---
search:
  boost: 0.5
title: AuthList
---

# AuthList

### Synopsis

Provide details about an Address of Record (Auth) section.

### Syntax


```


Event: AuthList
ObjectType: <value>
ObjectName: <value>
Username: <value>
Md5Cred: <value>
Realm: <value>
AuthType: <value>
Password: <value>
NonceLifetime: <value>

```
##### Arguments


* `ObjectType` - The object's type. This will always be 'auth'.<br>

* `ObjectName` - The name of this object.<br>

* `Username` - Username to use for account<br>

* `Md5Cred` - MD5 Hash used for authentication.<br>

* `Realm` - SIP realm for endpoint<br>

* `AuthType` - Authentication type<br>

* `Password` - Plain text password used for authentication.<br>

* `NonceLifetime` - Lifetime of a nonce associated with this authentication config.<br>

### Class

COMMAND

### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 