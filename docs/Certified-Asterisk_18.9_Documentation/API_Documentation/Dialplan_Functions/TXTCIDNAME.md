---
search:
  boost: 0.5
title: TXTCIDNAME
---

# TXTCIDNAME()

### Synopsis

TXTCIDNAME looks up a caller name via DNS.

### Description

This function looks up the given phone number in DNS to retrieve the caller id name. The result will either be blank or be the value found in the TXT record in DNS.<br>


### Syntax


```

TXTCIDNAME(number,zone-suffix)
```
##### Arguments


* `number`

* `zone-suffix` - If no _zone-suffix_ is given, the default will be 'e164.arpa'<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 