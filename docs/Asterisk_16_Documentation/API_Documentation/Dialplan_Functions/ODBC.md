---
search:
  boost: 0.5
title: ODBC
---

# ODBC()

### Synopsis

Controls ODBC transaction properties.

### Description

The ODBC() function allows setting several properties to influence how a connected database processes transactions.<br>


### Syntax


```

ODBC(property[,argument])
```
##### Arguments


* `property`

    * `transaction` - Gets or sets the active transaction ID. If set, and the transaction ID does not exist and a _database name_ is specified as an argument, it will be created.<br>

    * `forcecommit` - Controls whether a transaction will be automatically committed when the channel hangs up. Defaults to forcecommit value from the relevant DSN (which defaults to false). If a _transaction ID_ is specified in the optional argument, the property will be applied to that ID, otherwise to the current active ID.<br>

    * `isolation` - Controls the data isolation on uncommitted transactions. May be one of the following: 'read\_committed', 'read\_uncommitted', 'repeatable\_read', or 'serializable'. Defaults to the database setting in *res\_odbc.conf* or 'read\_committed' if not specified. If a _transaction ID_ is specified as an optional argument, it will be applied to that ID, otherwise the current active ID.<br>

* `argument`


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 