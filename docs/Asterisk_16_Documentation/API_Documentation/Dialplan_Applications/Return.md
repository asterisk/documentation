---
search:
  boost: 0.5
title: Return
---

# Return()

### Synopsis

Return from gosub routine.

### Description

Jumps to the last label on the stack, removing it. The return _value_, if any, is saved in the channel variable **GOSUB\_RETVAL**.<br>


### Syntax


```

Return([value])
```
##### Arguments


* `value` - Return value.<br>

### See Also

* [Dialplan Applications Gosub](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/Gosub)
* [Dialplan Applications StackPop](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/StackPop)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 