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

``` title="Example: Prints 321"

exten => s,1,NoOp(${CHANNEL}) ; contains SIP/321-1
same => n,NoOp(${CUT(PASSTHRU(${CUT(CHANNEL,-,1)}),/,2)})


```

### Syntax


```

PASSTHRU([string])
```
##### Arguments


* `string`


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 