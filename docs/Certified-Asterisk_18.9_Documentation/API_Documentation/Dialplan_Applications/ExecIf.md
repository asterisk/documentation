---
search:
  boost: 0.5
title: ExecIf
---

# ExecIf()

### Synopsis

Executes dialplan application, conditionally.

### Description

If _expr_ is true, execute and return the result of _appiftrue(args)_.<br>

If _expr_ is true, but _appiftrue_ is not found, then the application will return a non-zero value.<br>


### Syntax


```

ExecIf(expression?appiftrue:[appiffalse])
```
##### Arguments


* `expression`

* `execapp`

    * `appiftrue (*params* )` **required**

        * `args` **required**

    * `appiffalse (*params* )`

        * `args` **required**


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 