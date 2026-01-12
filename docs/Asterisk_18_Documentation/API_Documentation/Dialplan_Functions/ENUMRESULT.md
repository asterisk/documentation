---
search:
  boost: 0.5
title: ENUMRESULT
---

# ENUMRESULT()

### Synopsis

Retrieve results from a ENUMQUERY.

### Description

This function will retrieve results from a previous use of the ENUMQUERY function.<br>


### Syntax


```

ENUMRESULT(id,resultnum)
```
##### Arguments


* `id` - The identifier returned by the ENUMQUERY function.<br>

* `resultnum` - The number of the result that you want to retrieve.<br>
Results start at '1'. If this argument is specified as 'getnum', then it will return the total number of results that are available or -1 on error.<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 