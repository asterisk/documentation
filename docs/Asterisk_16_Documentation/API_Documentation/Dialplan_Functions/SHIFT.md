---
search:
  boost: 0.5
title: SHIFT
---

# SHIFT()

### Synopsis

Removes and returns the first item off of a variable containing delimited text

### Description

``` title="Example: SHIFT example"

exten => s,1,Set(array=one,two,three)
exten => s,n,While($["${SET(var=${SHIFT(array)})}" != ""])
exten => s,n,NoOp(var is ${var})
exten => s,n,EndWhile


```
This would iterate over each value in array, left to right, and would result in NoOp(var is one), NoOp(var is two), and NoOp(var is three) being executed.<br>


### Syntax


```

SHIFT(varname[,delimiter])
```
##### Arguments


* `varname`

* `delimiter`


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 