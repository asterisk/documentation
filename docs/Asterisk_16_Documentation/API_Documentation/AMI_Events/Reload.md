---
search:
  boost: 0.5
title: Reload
---

# Reload

### Synopsis

Raised when a module has been reloaded in Asterisk.

### Syntax


```


    Event: Reload
    Module: <value>
    Status: <value>

```
##### Arguments


* `Module` - The name of the module that was reloaded, or 'All' if all modules were reloaded<br>

* `Status` - The numeric status code denoting the success or failure of the reload request.<br>

    * `0` - Success<br>

    * `1` - Request queued<br>

    * `2` - Module not found<br>

    * `3` - Error<br>

    * `4` - Reload already in progress<br>

    * `5` - Module uninitialized<br>

    * `6` - Reload not supported<br>

### Class

SYSTEM

### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 