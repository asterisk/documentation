---
search:
  boost: 0.5
title: Setvar
---

# Setvar

### Synopsis

Sets a channel variable or function value.

### Description

This command can be used to set the value of channel variables or dialplan functions.<br>


/// note
If a channel name is not provided then the variable is considered global.
///


### Syntax


```


    Action: Setvar
    ActionID: <value>
    Channel: <value>
    Variable: <value>
    Value: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Channel` - Channel to set variable for.<br>

* `Variable` - Variable name, function or expression.<br>

* `Value` - Variable or function value.<br>

### See Also

* [AMI Actions Getvar](/Asterisk_16_Documentation/API_Documentation/AMI_Actions/Getvar)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 