---
search:
  boost: 0.5
title: DUNDIQUERY
---

# DUNDIQUERY()

### Synopsis

Initiate a DUNDi query.

### Description

This will do a DUNDi lookup of the given phone number.<br>

The result of this function will be a numeric ID that can be used to retrieve the results with the 'DUNDIRESULT' function.<br>


### Syntax


```

DUNDIQUERY(number,context,options)
```
##### Arguments


* `number`

* `context` - If not specified the default will be 'e164'.<br>

* `options`

    * `b` - Bypass the internal DUNDi cache<br>



### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 