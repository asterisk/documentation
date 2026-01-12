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

Example: DEC(MyVAR) - Decrements MyVar<br>

Note: DEC($\{MyVAR\}) - Is wrong, as DEC expects the variable name, not its value<br>


### Syntax


```

DEC(variable)
```
##### Arguments


* `variable` - The variable name to be manipulated, without the braces.<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 