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

``` title="Example: Escape example"

SELECT foo FROM bar WHERE baz='${SQL_ESC(${ARG1})}'


```

### Syntax


```

SQL_ESC(string)
```
##### Arguments


* `string`


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 