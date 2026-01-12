---
search:
  boost: 0.5
title: SIPAddHeader
---

# SIPAddHeader()

### Synopsis

Add a SIP header to the outbound call.

### Description

Adds a header to a SIP call placed with DIAL.<br>

Remember to use the X-header if you are adding non-standard SIP headers, like 'X-Asterisk-Accountcode:'. Use this with care. Adding the wrong headers may jeopardize the SIP dialog.<br>

Always returns '0'.<br>


### Syntax


```

SIPAddHeader(Header:Content)
```
##### Arguments


* `Header`

* `Content`


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 