---
search:
  boost: 0.5
title: ExtensionStateList
---

# ExtensionStateList

### Synopsis

List the current known extension states.

### Description

This will list out all known extension states in a sequence of _ExtensionStatus_ events. When finished, a _ExtensionStateListComplete_ event will be emitted.<br>


### Syntax


```


    Action: ExtensionStateList
    ActionID: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

### See Also

* [AMI Actions ExtensionState](/Asterisk_16_Documentation/API_Documentation/AMI_Actions/ExtensionState)
* [Dialplan Functions HINT](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/HINT)
* [Dialplan Functions EXTENSION_STATE](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/EXTENSION_STATE)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 