---
search:
  boost: 0.5
title: RaiseException
---

# RaiseException()

### Synopsis

Handle an exceptional condition.

### Description

This application will jump to the 'e' extension in the current context, setting the dialplan function EXCEPTION(). If the 'e' extension does not exist, the call will hangup.<br>


### Syntax


```

RaiseException(reason)
```
##### Arguments


* `reason`

### See Also

* [Dialplan Functions EXCEPTION](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/EXCEPTION)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 