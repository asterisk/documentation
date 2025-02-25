---
search:
  boost: 0.5
title: ENUMQUERY
---

# ENUMQUERY()

### Synopsis

Initiate an ENUM query.

### Description

This will do a ENUM lookup of the given phone number.<br>


### Syntax


```

ENUMQUERY(number,method-type,zone-suffix)
```
##### Arguments


* `number`

* `method-type` - If no _method-type_ is given, the default will be 'sip'.<br>

* `zone-suffix` - If no _zone-suffix_ is given, the default will be 'e164.arpa'<br>


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 