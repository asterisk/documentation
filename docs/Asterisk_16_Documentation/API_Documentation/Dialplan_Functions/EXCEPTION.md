---
search:
  boost: 0.5
title: EXCEPTION
---

# EXCEPTION()

### Synopsis

Retrieve the details of the current dialplan exception.

### Description

Retrieve the details (specified _field_) of the current dialplan exception.<br>


### Syntax


```

EXCEPTION(field)
```
##### Arguments


* `field` - The following fields are available for retrieval:<br>

    * `reason` - INVALID, ERROR, RESPONSETIMEOUT, ABSOLUTETIMEOUT, or custom value set by the RaiseException() application<br>

    * `context` - The context executing when the exception occurred.<br>

    * `exten` - The extension executing when the exception occurred.<br>

    * `priority` - The numeric priority executing when the exception occurred.<br>

### See Also

* [Dialplan Applications RaiseException](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/RaiseException)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 