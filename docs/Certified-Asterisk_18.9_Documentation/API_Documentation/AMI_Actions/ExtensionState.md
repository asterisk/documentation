---
search:
  boost: 0.5
title: ExtensionState
---

# ExtensionState

### Synopsis

Check Extension Status.

### Description

Report the extension state for given extension. If the extension has a hint, will use devicestate to check the status of the device connected to the extension.<br>

Will return an 'Extension Status' message. The response will include the hint for the extension and the status.<br>


### Syntax


```


Action: ExtensionState
ActionID: <value>
Exten: <value>
Context: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Exten` - Extension to check state on.<br>

* `Context` - Context for extension.<br>

### See Also

* [AMI Events ExtensionStatus](/Certified-Asterisk_18.9_Documentation/API_Documentation/AMI_Events/ExtensionStatus)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 