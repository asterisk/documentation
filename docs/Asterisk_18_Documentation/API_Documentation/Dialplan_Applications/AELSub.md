---
search:
  boost: 0.5
title: AELSub
---

# AELSub()

### Synopsis

Launch subroutine built with AEL

### Description

Execute the named subroutine, defined in AEL, from another dialplan language, such as extensions.conf, Realtime extensions, or Lua.<br>

The purpose of this application is to provide a sane entry point into AEL subroutines, the implementation of which may change from time to time.<br>


### Syntax


```

AELSub(routine,[args])
```
##### Arguments


* `routine` - Named subroutine to execute.<br>

* `args`


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 