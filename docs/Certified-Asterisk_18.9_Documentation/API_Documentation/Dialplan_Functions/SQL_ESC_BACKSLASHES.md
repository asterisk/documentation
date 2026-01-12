---
search:
  boost: 0.5
title: SQL_ESC_BACKSLASHES
---

# SQL_ESC_BACKSLASHES()

### Synopsis

Escapes backslashes for use in SQL statements.

### Description

Used in SQL templates to escape data which may contain backslashes '\' which are otherwise used to escape data.<br>

Example: SELECT foo FROM bar WHERE baz='$\{SQL\_ESC($\{SQL\_ESC\_BACKSLASHES($\{ARG1\})\})\}'<br>


### Syntax


```

SQL_ESC_BACKSLASHES(string)
```
##### Arguments


* `string`


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 