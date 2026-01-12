---
search:
  boost: 0.5
title: ARRAY
---

# ARRAY()

### Synopsis

Allows setting multiple variables at once.

### Description

The comma-delimited list passed as a value to which the function is set will be interpreted as a set of values to which the comma-delimited list of variable names in the argument should be set.<br>

Example: Set(ARRAY(var1,var2)=1,2) will set var1 to 1 and var2 to 2<br>


### Syntax


```

ARRAY(var1[,var2[,...][,varN]])
```
##### Arguments


* `var1`

* `var2`

* `varN`


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 