---
search:
  boost: 0.5
title: DEC
---

# DEC()

### Synopsis

Decrements the value of a variable, while returning the updated value to the dialplan

### Description

Decrements the value of a variable, while returning the updated value to the dialplan<br>

``` title="Example: Decrements MyVAR"

same => n,NoOp(${DEC(MyVAR)})


```

/// note
DEC($\{MyVAR\}) is wrong, as DEC expects the variable name, not its value
///


### Syntax


```

DEC(variable)
```
##### Arguments


* `variable` - The variable name to be manipulated, without the braces.<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 