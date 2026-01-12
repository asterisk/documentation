---
search:
  boost: 0.5
title: ModuleCheck
---

# ModuleCheck

### Synopsis

Check if module is loaded.

### Description

Checks if Asterisk module is loaded. Will return Success/Failure. For success returns, the module revision number is included.<br>


### Syntax


```


Action: ModuleCheck
ActionID: <value>
Module: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Module` - Asterisk module name (not including extension).<br>

### See Also

* [AMI Actions ModuleLoad](/Certified-Asterisk_18.9_Documentation/API_Documentation/AMI_Actions/ModuleLoad)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 