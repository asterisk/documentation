---
search:
  boost: 0.5
title: BridgeTechnologyUnsuspend
---

# BridgeTechnologyUnsuspend

### Synopsis

Unsuspend a bridging technology.

### Description

Clears a previously suspended bridging technology, which allows subsequently created bridges to use it.<br>


### Syntax


```


Action: BridgeTechnologyUnsuspend
ActionID: <value>
BridgeTechnology: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `BridgeTechnology` - The name of the bridging technology to unsuspend.<br>

### See Also

* [AMI Actions BridgeTechnologyList](/Asterisk_18_Documentation/API_Documentation/AMI_Actions/BridgeTechnologyList)
* [AMI Actions BridgeTechnologySuspend](/Asterisk_18_Documentation/API_Documentation/AMI_Actions/BridgeTechnologySuspend)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 