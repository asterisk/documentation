---
search:
  boost: 0.5
title: GET VARIABLE
---

# GET VARIABLE

### Synopsis

Gets a channel variable.

### Description

Returns '0' if _variablename_ is not set. Returns '1' if _variablename_ is set and returns the variable in parentheses.<br>

Example return code: 200 result=1 (testvariable)<br>


### Syntax


```

GET VARIABLE VARIABLENAME 
```
##### Arguments


* `variablename`

### See Also

* [AGI Commands get_full_variable](/Asterisk_18_Documentation/API_Documentation/AGI_Commands/get_full_variable)
* [AGI Commands set_variable](/Asterisk_18_Documentation/API_Documentation/AGI_Commands/set_variable)
* [Dialplan Applications AGI](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/AGI)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 