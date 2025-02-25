---
search:
  boost: 0.5
title: Set
---

# Set()

### Synopsis

Set channel variable or function value.

### Description

This function can be used to set the value of channel variables or dialplan functions. When setting variables, if the variable name is prefixed with '\_', the variable will be inherited into channels created from the current channel. If the variable name is prefixed with '\_\_', the variable will be inherited into channels created from the current channel and all children channels.<br>


/// note
If (and only if), in */etc/asterisk/asterisk.conf*, you have a '\[compat\]' category, and you have 'app\_set = 1.4' under that, then the behavior of this app changes, and strips surrounding quotes from the right hand side as it did previously in 1.4. The advantages of not stripping out quoting, and not caring about the separator characters (comma and vertical bar) were sufficient to make these changes in 1.6. Confusion about how many backslashes would be needed to properly protect separators and quotes in various database access strings has been greatly reduced by these changes.
///


### Syntax


```

Set(name=value)
```
##### Arguments


* `name`

* `value`

### See Also

* [Dialplan Applications MSet](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/MSet)
* [Dialplan Functions GLOBAL](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/GLOBAL)
* [Dialplan Functions SET](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/SET)
* [Dialplan Functions ENV](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/ENV)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 