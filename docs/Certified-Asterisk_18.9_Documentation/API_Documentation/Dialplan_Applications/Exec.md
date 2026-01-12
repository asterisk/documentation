---
search:
  boost: 0.5
title: Exec
---

# Exec()

### Synopsis

Executes dialplan application.

### Description

Allows an arbitrary application to be invoked even when not hard coded into the dialplan. If the underlying application terminates the dialplan, or if the application cannot be found, Exec will terminate the dialplan.<br>

To invoke external applications, see the application System. If you would like to catch any error instead, see TryExec.<br>


### Syntax


```

Exec(appname(arguments))
```
##### Arguments


* `appname` - Application name and arguments of the dialplan application to execute.<br>

    * `arguments` **required**


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 