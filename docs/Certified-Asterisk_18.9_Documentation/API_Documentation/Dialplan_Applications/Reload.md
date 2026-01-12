---
search:
  boost: 0.5
title: Reload
---

# Reload()

### Synopsis

Reloads an Asterisk module, blocking the channel until the reload has completed.

### Description

Reloads the specified (or all) Asterisk modules and reports success or failure. Success is determined by each individual module, and if all reloads are successful, that is considered an aggregate success. If multiple modules are specified and any module fails, then FAILURE will be returned. It is still possible that other modules did successfully reload, however.<br>

Sets **RELOADSTATUS** to one of the following values:<br>


* `RELOADSTATUS`

    * `SUCCESS` - Specified module(s) reloaded successfully.

    * `FAILURE` - Some or all of the specified modules failed to reload.

### Syntax


```

Reload([module])
```
##### Arguments


* `module` - The full name(s) of the target module(s) or resource(s) to reload. If omitted, everything will be reloaded.<br>
The full names MUST be specified (e.g. 'chan\_iax2' to reload IAX2 or 'pbx\_config' to reload the dialplan.<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 