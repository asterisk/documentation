---
search:
  boost: 0.5
title: CUT
---

# CUT()

### Synopsis

Slices and dices strings, based upon a named delimiter.

### Description

Cut out information from a string ( _varname_), based upon a named delimiter.<br>


### Syntax


```

CUT(varname,char-delim,range-spec)
```
##### Arguments


* `varname` - Variable you want cut<br>

* `char-delim` - Delimiter, defaults to '-'<br>

* `range-spec` - Number of the field you want (1-based offset), may also be specified as a range (with '-') or group of ranges and fields (with '&')<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 