---
search:
  boost: 0.5
title: POP
---

# POP()

### Synopsis

Removes and returns the last item off of a variable containing delimited text

### Description

``` title="Example: POP example"

exten => s,1,Set(array=one,two,three)
exten => s,n,While($["${SET(var=${POP(array)})}" != ""])
exten => s,n,NoOp(var is ${var})
exten => s,n,EndWhile


```
This would iterate over each value in array, right to left, and would result in NoOp(var is three), NoOp(var is two), and NoOp(var is one) being executed.<br>


### Syntax


```

POP(varname[,delimiter])
```
##### Arguments


* `varname`

* `delimiter`


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 