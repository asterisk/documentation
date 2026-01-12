---
search:
  boost: 0.5
title: PJSIP_DIAL_CONTACTS
---

# PJSIP_DIAL_CONTACTS()

### Synopsis

Return a dial string for dialing all contacts on an AOR.

### Description

Returns a properly formatted dial string for dialing all contacts on an AOR.<br>


### Syntax


```

PJSIP_DIAL_CONTACTS(endpoint[,aor[,request_user]])
```
##### Arguments


* `endpoint` - Name of the endpoint<br>

* `aor` - Name of an AOR to use, if not specified the configured AORs on the endpoint are used<br>

* `request_user` - Optional request user to use in the request URI<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 