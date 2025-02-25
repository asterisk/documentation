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
If no module is specified for a 'reload' loadtype, all modules are reloaded.<br>

### See Also

* [AMI Actions Reload](/Asterisk_16_Documentation/API_Documentation/AMI_Actions/Reload)
* [AMI Actions ModuleCheck](/Asterisk_16_Documentation/API_Documentation/AMI_Actions/ModuleCheck)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 