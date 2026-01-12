---
search:
  boost: 0.5
title: POP
---

# POP()

### Synopsis

Removes and returns the last item off of a variable containing delimited text

### Description

Example:<br>

exten => s,1,Set(array=one,two,three)<br>

exten => s,n,While($\["$\{SET(var=$\{POP(array)\})\}" != ""\])<br>

exten => s,n,NoOp(var is $\{var\})<br>

exten => s,n,EndWhile<br>

This would iterate over each value in array, right to left, and would result in NoOp(var is three), NoOp(var is two), and NoOp(var is one) being executed.<br>


### Syntax


```

POP(varname[,delimiter])
```
##### Arguments


* `varname`

* `delimiter`


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 