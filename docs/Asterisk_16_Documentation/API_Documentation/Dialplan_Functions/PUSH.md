---
search:
  boost: 0.5
title: PUSH
---

# PUSH()

### Synopsis

Appends one or more values to the end of a variable containing delimited text

### Description

``` title="Example: PUSH example"

exten => s,1,Set(PUSH(array)=one,two,three)


```
This would append one, two, and three to the end of the values stored in the variable "array".<br>


### Syntax


```

PUSH(varname[,delimiter])
```
##### Arguments


* `varname`

* `delimiter`


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 