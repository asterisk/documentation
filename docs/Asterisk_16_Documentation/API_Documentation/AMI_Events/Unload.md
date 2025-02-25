---
search:
  boost: 0.5
title: Unload
---

# Unload

### Synopsis

Raised when a module has been unloaded in Asterisk.

### Syntax


```


    Event: Unload
    Module: <value>
    Status: <value>

```
##### Arguments


* `Module` - The name of the module that was unloaded<br>

* `Status` - The result of the unload request.<br>

    * `Success` - Module unloaded successfully<br>

### Class

SYSTEM

### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 