---
search:
  boost: 0.5
title: VALID_EXTEN
---

# VALID_EXTEN()

### Synopsis

Determine whether an extension exists or not.

### Description

Returns a true value if the indicated _context_, _extension_, and _priority_ exist.<br>


/// warning
This function has been deprecated in favor of the 'DIALPLAN\_EXISTS()' function
///


### Syntax


```

VALID_EXTEN(context,extension,priority)
```
##### Arguments


* `context` - Defaults to the current context<br>

* `extension`

* `priority` - Priority defaults to '1'.<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 