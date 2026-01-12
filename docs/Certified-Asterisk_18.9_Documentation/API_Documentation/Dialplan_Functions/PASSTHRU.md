---
search:
  boost: 0.5
title: PASSTHRU
---

# PASSTHRU()

### Synopsis

Pass the given argument back as a value.

### Description

Literally returns the given _string_. The intent is to permit other dialplan functions which take a variable name as an argument to be able to take a literal string, instead.<br>


/// note
The functions which take a variable name need to be passed var and not $\{var\}. Similarly, use PASSTHRU() and not $\{PASSTHRU()\}.
///

Example: $\{CHANNEL\} contains SIP/321-1<br>

$\{CUT(PASSTHRU($\{CUT(CHANNEL,-,1)\}),/,2)\}) will return 321<br>


### Syntax


```

PASSTHRU([string])
```
##### Arguments


* `string`


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 