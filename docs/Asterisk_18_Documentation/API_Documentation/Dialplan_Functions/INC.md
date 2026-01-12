---
search:
  boost: 0.5
title: INC
---

# INC()

### Synopsis

Increments the value of a variable, while returning the updated value to the dialplan

### Description

Increments the value of a variable, while returning the updated value to the dialplan<br>

Example: INC(MyVAR) - Increments MyVar<br>

Note: INC($\{MyVAR\}) - Is wrong, as INC expects the variable name, not its value<br>


### Syntax


```

INC(variable)
```
##### Arguments


* `variable` - The variable name to be manipulated, without the braces.<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 