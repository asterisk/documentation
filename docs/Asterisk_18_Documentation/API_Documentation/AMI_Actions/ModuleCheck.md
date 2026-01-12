---
search:
  boost: 0.5
title: ModuleCheck
---

# ModuleCheck

### Synopsis

Check if module is loaded.

### Description

Checks if Asterisk module is loaded. Will return Success/Failure. An empty Version header is also returned (which doesn't contain the module revision number).<br>


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

* [AMI Actions ModuleLoad](/Asterisk_18_Documentation/API_Documentation/AMI_Actions/ModuleLoad)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 