---
search:
  boost: 0.5
title: AMI_CLIENT
---

# AMI_CLIENT()

### Synopsis

Checks attributes of manager accounts

### Description

Currently, the only supported parameter is "sessions" which will return the current number of active sessions for this AMI account.<br>


### Syntax


```

AMI_CLIENT(loginname,field)
```
##### Arguments


* `loginname` - Login name, specified in manager.conf<br>

* `field` - The manager account attribute to return<br>

    * `sessions` - The number of sessions for this AMI account<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 