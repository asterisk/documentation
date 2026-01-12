---
search:
  boost: 0.5
title: DUNDILOOKUP
---

# DUNDILOOKUP()

### Synopsis

Do a DUNDi lookup of a phone number.

### Description

This will do a DUNDi lookup of the given phone number.<br>

This function will return the Technology/Resource found in the first result in the DUNDi lookup. If no results were found, the result will be blank.<br>


### Syntax


```

DUNDILOOKUP(number,context,options)
```
##### Arguments


* `number`

* `context` - If not specified the default will be 'e164'.<br>

* `options`

    * `b` - Bypass the internal DUNDi cache<br>



### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 