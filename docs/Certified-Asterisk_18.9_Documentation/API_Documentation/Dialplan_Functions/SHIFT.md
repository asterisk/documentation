---
search:
  boost: 0.5
title: SHIFT
---

# SHIFT()

### Synopsis

Removes and returns the first item off of a variable containing delimited text

### Description

Example:<br>

exten => s,1,Set(array=one,two,three)<br>

exten => s,n,While($\["$\{SET(var=$\{SHIFT(array)\})\}" != ""\])<br>

exten => s,n,NoOp(var is $\{var\})<br>

exten => s,n,EndWhile<br>

This would iterate over each value in array, left to right, and would result in NoOp(var is one), NoOp(var is two), and NoOp(var is three) being executed.<br>


### Syntax


```

SHIFT(varname[,delimiter])
```
##### Arguments


* `varname`

* `delimiter`


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 