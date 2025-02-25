---
search:
  boost: 0.5
title: STRREPLACE
---

# STRREPLACE()

### Synopsis

Replace instances of a substring within a string with another string.

### Description

Searches for all instances of the _find-string_ in provided variable and replaces them with _replace-string_. If _replace-string_ is an empty string, this will effectively delete that substring. If _max-replacements_ is specified, this function will stop after performing replacements _max-replacements_ times.<br>


/// note
The replacement only occurs in the output. The original variable is not altered.
///


### Syntax


```

STRREPLACE(varname,find-string[,replace-string[,max-replacements]])
```
##### Arguments


* `varname`

* `find-string`

* `replace-string`

* `max-replacements`


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 