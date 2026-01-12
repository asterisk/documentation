---
search:
  boost: 0.5
title: SIPRemoveHeader
---

# SIPRemoveHeader()

### Synopsis

Remove SIP headers previously added with SIPAddHeader

### Description

SIPRemoveHeader() allows you to remove headers which were previously added with SIPAddHeader(). If no parameter is supplied, all previously added headers will be removed. If a parameter is supplied, only the matching headers will be removed.<br>

``` title="Example: Add 2 headers"

same => n,SIPAddHeader(P-Asserted-Identity: sip:foo@bar)
same => n,SIPAddHeader(P-Preferred-Identity: sip:bar@foo)


```
``` title="Example: Remove all headers"

same => n,SIPRemoveHeader()


```
``` title="Example: Remove all P- headers"

same => n,SIPRemoveHeader(P-)


```
``` title="Example: Remove only the PAI header (note the : at the end)"

same => n,SIPRemoveHeader(P-Asserted-Identity:)


```
Always returns '0'.<br>


### Syntax


```

SIPRemoveHeader([Header])
```
##### Arguments


* `Header`


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 