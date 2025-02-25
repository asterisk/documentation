---
search:
  boost: 0.5
title: MAILBOX_EXISTS
---

# MAILBOX_EXISTS()

### Synopsis

Tell if a mailbox is configured.

### Description


/// note
DEPRECATED. Use VM\_INFO(mailbox\[@context\],exists) instead.
///

Returns a boolean of whether the corresponding _mailbox_ exists. If _context_ is not specified, defaults to the 'default' context.<br>


### Syntax


```

MAILBOX_EXISTS(mailbox@context)
```
##### Arguments


* `mailbox`

* `context`

### See Also

* [Dialplan Functions VM_INFO](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/VM_INFO)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 