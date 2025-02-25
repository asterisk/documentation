---
search:
  boost: 0.5
title: STRFTIME
---

# STRFTIME()

### Synopsis

Returns the current date/time in the specified format.

### Description

STRFTIME supports all of the same formats as the underlying C function *strftime(3)*. It also supports the following format: '%\[n\]q' - fractions of a second, with leading zeros.<br>

Example: '%3q' will give milliseconds and '%1q' will give tenths of a second. The default is set at milliseconds (n=3). The common case is to use it in combination with %S, as in '%S.%3q'.<br>


### Syntax


```

STRFTIME(epoch,timezone,format)
```
##### Arguments


* `epoch`

* `timezone`

* `format`

### See Also

* {{strftime(3)}}


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 