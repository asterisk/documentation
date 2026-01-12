---
search:
  boost: 0.5
title: ModuleLoad
---

# ModuleLoad

### Synopsis

Module management.

### Description

Loads, unloads or reloads an Asterisk module in a running system.<br>


### Syntax


```


Action: ModuleLoad
ActionID: <value>
Module: <value>
LoadType: <value>
[Recursive: <value>]

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Module` - Asterisk module name (including .so extension) or subsystem identifier:<br>

    * `cdr`

    * `dnsmgr`

    * `extconfig`

    * `enum`

    * `acl`

    * `manager`

    * `http`

    * `logger`

    * `features`

    * `dsp`

    * `udptl`

    * `indications`

    * `cel`

    * `plc`

* `LoadType` - The operation to be done on module. Subsystem identifiers may only be reloaded.<br>

    * `load`

    * `unload`

    * `reload`

    * `refresh` - Completely unload and load again a specified module.<br>
If no module is specified for a 'reload' loadtype, all modules are reloaded.<br>

* `Recursive` - For 'refresh' operations, attempt to recursively unload any other modules that are dependent on this module, if that would allow it to successfully unload, and load them again afterwards.<br>

### See Also

* [AMI Actions Reload](/Asterisk_18_Documentation/API_Documentation/AMI_Actions/Reload)
* [AMI Actions ModuleCheck](/Asterisk_18_Documentation/API_Documentation/AMI_Actions/ModuleCheck)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 