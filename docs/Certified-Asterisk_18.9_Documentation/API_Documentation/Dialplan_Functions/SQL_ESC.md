---
search:
  boost: 0.5
title: SQL_ESC
---

# SQL_ESC()

### Synopsis

Escapes single ticks for use in SQL statements.

### Description

Used in SQL templates to escape data which may contain single ticks ''' which are otherwise used to delimit data.<br>

Example: SELECT foo FROM bar WHERE baz='$\{SQL\_ESC($\{ARG1\})\}'<br>


### Syntax


```

SQL_ESC(string)
```
##### Arguments


* `string`


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 