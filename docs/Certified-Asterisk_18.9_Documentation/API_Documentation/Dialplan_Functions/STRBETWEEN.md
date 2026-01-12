---
search:
  boost: 0.5
title: STRBETWEEN
---

# STRBETWEEN()

### Synopsis

Inserts a substring between each character in a string.

### Description

Inserts a substring _find-string_ between each character in _varname_.<br>


/// note
The replacement only occurs in the output. The original variable is not altered.
///

``` title="Example: Add half-second pause between dialed digits"

same => n,Set(digits=5551212)
same => n,SendDTMF(${STRBETWEEN(digits,w)) ; this will send 5w5w5w1w2w1w2


```

### Syntax


```

STRBETWEEN(varname,insert-string)
```
##### Arguments


* `varname`

* `insert-string`


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 