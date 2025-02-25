---
search:
  boost: 0.5
title: IFMODULE
---

# IFMODULE()

### Synopsis

Checks if an Asterisk module is loaded in memory.

### Description

Checks if a module is loaded. Use the full module name as shown by the list in 'module list'. Returns '1' if module exists in memory, otherwise '0'<br>


### Syntax


```

IFMODULE(modulename.so)
```
##### Arguments


* `modulename.so` - Module name complete with '.so'<br>


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 