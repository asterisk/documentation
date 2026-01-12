---
search:
  boost: 0.5
title: Getvar
---

# Getvar

### Synopsis

Gets a channel variable or function value.

### Description

Get the value of a channel variable or function return.<br>


/// note
If a channel name is not provided then the variable is considered global.
///


### Syntax


```


Action: Getvar
ActionID: <value>
Channel: <value>
Variable: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Channel` - Channel to read variable from.<br>

* `Variable` - Variable name, function or expression.<br>

### See Also

* [AMI Actions Setvar](/Certified-Asterisk_18.9_Documentation/API_Documentation/AMI_Actions/Setvar)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 