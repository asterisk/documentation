---
search:
  boost: 0.5
title: REGEX
---

# REGEX()

### Synopsis

Check string against a regular expression.

### Description

Return '1' on regular expression match or '0' otherwise<br>

Please note that the space following the double quotes separating the regex from the data is optional and if present, is skipped. If a space is desired at the beginning of the data, then put two spaces there; the second will not be skipped.<br>


### Syntax


```

REGEX("regular expression" string)
```
##### Arguments


* `"regular expression"`

* `string`


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 