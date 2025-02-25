---
search:
  boost: 0.5
title: EXEC
---

# EXEC

### Synopsis

Executes a given Application

### Description

Executes _application_ with given _options_.<br>

Returns whatever the _application_ returns, or '-2' on failure to find _application_.<br>


/// note
exec does not evaluate dialplan functions and variables unless it is explicitly enabled by setting the **AGIEXECFULL** variable to 'yes'.
///


### Syntax


```

EXEC APPLICATION OPTIONS 
```
##### Arguments


* `application`

* `options`

### See Also

* [Dialplan Applications AGI](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/AGI)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 