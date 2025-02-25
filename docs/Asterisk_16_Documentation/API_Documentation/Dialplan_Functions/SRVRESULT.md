---
search:
  boost: 0.5
title: SRVRESULT
---

# SRVRESULT()

### Synopsis

Retrieve results from an SRVQUERY.

### Description

This function will retrieve results from a previous use of the SRVQUERY function.<br>


### Syntax


```

SRVRESULT(id,resultnum[,field])
```
##### Arguments


* `id` - The identifier returned by the SRVQUERY function.<br>

* `resultnum` - The number of the result that you want to retrieve.<br>
Results start at '1'. If this argument is specified as 'getnum', then it will return the total number of results that are available.<br>

* `field` - The field of the result to retrieve.<br>
The fields that can be retrieved are:<br>

    * `host`

    * `port`

    * `priority`

    * `weight`


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 