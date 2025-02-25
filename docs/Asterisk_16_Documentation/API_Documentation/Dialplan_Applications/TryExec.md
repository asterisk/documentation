---
search:
  boost: 0.5
title: TryExec
---

# TryExec()

### Synopsis

Executes dialplan application, always returning.

### Description

Allows an arbitrary application to be invoked even when not hard coded into the dialplan. To invoke external applications see the application System. Always returns to the dialplan. The channel variable TRYSTATUS will be set to one of:<br>


* `TRYSTATUS`

    * `SUCCESS` - If the application returned zero.

    * `FAILED` - If the application returned non-zero.

    * `NOAPP` - If the application was not found or was not specified.

### Syntax


```

TryExec(appname(arguments))
```
##### Arguments


* `appname`

    * `arguments` **required**


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 