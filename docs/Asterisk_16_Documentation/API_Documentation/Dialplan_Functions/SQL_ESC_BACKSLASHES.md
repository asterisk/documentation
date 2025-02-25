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

``` title="Example: Escape with backslashes example"

SELECT foo FROM bar WHERE baz='${SQL_ESC(${SQL_ESC_BACKSLASHES(${ARG1})})}'


```

### Syntax


```

SQL_ESC_BACKSLASHES(string)
```
##### Arguments


* `string`


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 