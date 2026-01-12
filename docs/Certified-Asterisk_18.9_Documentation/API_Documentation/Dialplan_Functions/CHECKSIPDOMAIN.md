---
search:
  boost: 0.5
title: CHECKSIPDOMAIN
---

# CHECKSIPDOMAIN()

### Synopsis

Checks if domain is a local domain.

### Description

This function checks if the _domain_ in the argument is configured as a local SIP domain that this Asterisk server is configured to handle. Returns the domain name if it is locally handled, otherwise an empty string. Check the 'domain=' configuration in *sip.conf*.<br>


### Syntax


```

CHECKSIPDOMAIN(domain)
```
##### Arguments


* `domain`


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 