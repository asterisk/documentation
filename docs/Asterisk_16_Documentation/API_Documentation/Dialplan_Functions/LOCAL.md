---
search:
  boost: 0.5
title: LOCAL
---

# LOCAL()

### Synopsis

Manage variables local to the gosub stack frame.

### Description

Read and write a variable local to the gosub stack frame, once we Return() it will be lost (or it will go back to whatever value it had before the Gosub()).<br>


### Syntax


```

LOCAL(varname)
```
##### Arguments


* `varname`

### See Also

* [Dialplan Applications Gosub](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/Gosub)
* [Dialplan Applications GosubIf](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/GosubIf)
* [Dialplan Applications Return](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/Return)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 