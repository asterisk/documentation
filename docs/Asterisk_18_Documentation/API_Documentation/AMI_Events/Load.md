---
search:
  boost: 0.5
title: Load
---

# Load

### Synopsis

Raised when a module has been loaded in Asterisk.

### Syntax


```


Event: Load
Module: <value>
Status: <value>

```
##### Arguments


* `Module` - The name of the module that was loaded<br>

* `Status` - The result of the load request.<br>

    * `Failure` - Module could not be loaded properly<br>

    * `Success` - Module loaded and configured<br>

    * `Decline` - Module is not configured<br>

### Class

SYSTEM

### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 