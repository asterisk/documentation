---
search:
  boost: 0.5
title: ODBC_FETCH
---

# ODBC_FETCH()

### Synopsis

Fetch a row from a multirow query.

### Description

For queries which are marked as mode=multirow, the original query returns a _result-id_ from which results may be fetched. This function implements the actual fetch of the results.<br>

This also sets **ODBC\_FETCH\_STATUS**.<br>


* `ODBC_FETCH_STATUS`

    * `SUCESS` - If rows are available.

    * `FAILURE` - If no rows are available.

### Syntax


```

ODBC_FETCH(result-id)
```
##### Arguments


* `result-id`


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 