---
search:
  boost: 0.5
title: REPLACE
---

# REPLACE()

### Synopsis

Replace a set of characters in a given string with another character.

### Description

Iterates through a string replacing all the _find-chars_ with _replace-char_. _replace-char_ may be either empty or contain one character. If empty, all _find-chars_ will be deleted from the output.<br>


/// note
The replacement only occurs in the output. The original variable is not altered.
///


### Syntax


```

REPLACE(varname,find-chars[,replace-char])
```
##### Arguments


* `varname`

* `find-chars`

* `replace-char`


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 