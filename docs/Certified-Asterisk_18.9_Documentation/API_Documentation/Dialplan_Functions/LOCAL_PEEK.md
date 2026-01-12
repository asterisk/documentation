---
search:
  boost: 0.5
title: LOCAL_PEEK
---

# LOCAL_PEEK()

### Synopsis

Retrieve variables hidden by the local gosub stack frame.

### Description

Read a variable _varname_ hidden by _n_ levels of gosub stack frames. Note that $\{LOCAL\_PEEK(0,foo)\} is the same as **foo**, since the value of _n_ peeks under 0 levels of stack frames; in other words, 0 is the current level. If _n_ exceeds the available number of stack frames, then an empty string is returned.<br>


### Syntax


```

LOCAL_PEEK(n,varname)
```
##### Arguments


* `n`

* `varname`

### See Also

* [Dialplan Applications Gosub](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/Gosub)
* [Dialplan Applications GosubIf](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/GosubIf)
* [Dialplan Applications Return](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/Return)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 