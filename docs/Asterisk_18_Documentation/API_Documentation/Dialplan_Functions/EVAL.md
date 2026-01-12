---
search:
  boost: 0.5
title: EVAL
---

# EVAL()

### Synopsis

Evaluate stored variables

### Description

Using EVAL basically causes a string to be evaluated twice. When a variable or expression is in the dialplan, it will be evaluated at runtime. However, if the results of the evaluation is in fact another variable or expression, using EVAL will have it evaluated a second time.<br>

Example: If the **MYVAR** contains **OTHERVAR**, then the result of $\{EVAL( **MYVAR**)\} in the dialplan will be the contents of **OTHERVAR**. Normally just putting **MYVAR** in the dialplan the result would be **OTHERVAR**.<br>


### Syntax


```

EVAL(variable)
```
##### Arguments


* `variable`


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 