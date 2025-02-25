---
search:
  boost: 0.5
title: UNSHIFT
---

# UNSHIFT()

### Synopsis

Inserts one or more values to the beginning of a variable containing delimited text

### Description

``` title="Example: UNSHIFT example"

exten => s,1,Set(UNSHIFT(array)=one,two,three)


```
This would insert one, two, and three before the values stored in the variable "array".<br>


### Syntax


```

UNSHIFT(varname[,delimiter])
```
##### Arguments


* `varname`

* `delimiter`


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 