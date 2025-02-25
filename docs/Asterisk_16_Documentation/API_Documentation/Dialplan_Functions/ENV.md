---
search:
  boost: 0.5
title: ENV
---

# ENV()

### Synopsis

Gets or sets the environment variable specified.

### Description

Variables starting with 'AST\_' are reserved to the system and may not be set.<br>

Additionally, the following system variables are available as special built-in dialplan variables. These variables cannot be set or modified and are read-only.<br>


* `EPOCH` - Current unix style epoch<br>

* `SYSTEMNAME` - value of the 'systemname' option from 'asterisk.conf'<br>

* `ASTCACHEDIR` - value of the 'astcachedir' option from 'asterisk.conf'<br>

* `ASTETCDIR` - value of the 'astetcdir' option from 'asterisk.conf'<br>

* `ASTMODDIR` - value of the 'astmoddir' option from 'asterisk.conf'<br>

* `ASTVARLIBDIR` - value of the 'astvarlib' option from 'asterisk.conf'<br>

* `ASTDBDIR` - value of the 'astdbdir' option from 'asterisk.conf'<br>

* `ASTKEYDIR` - value of the 'astkeydir' option from 'asterisk.conf'<br>

* `ASTDATADIR` - value of the 'astdatadir' option from 'asterisk.conf'<br>

* `ASTAGIDIR` - value of the 'astagidir' option from 'asterisk.conf'<br>

* `ASTSPOOLDIR` - value of the 'astspooldir' option from 'asterisk.conf'<br>

* `ASTRUNDIR` - value of the 'astrundir' option from 'asterisk.conf'<br>

* `ASTLOGDIR` - value of the 'astlogdir' option from 'asterisk.conf'<br>

* `ASTSBINDIR` - value of the 'astsbindir' option from 'asterisk.conf'<br>

* `ENTITYID` - Global Entity ID set automatically, or from 'asterisk.conf'<br>

### Syntax


```

ENV(varname)
```
##### Arguments


* `varname` - Environment variable name<br>


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 