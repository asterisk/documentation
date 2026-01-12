---
search:
  boost: 0.5
title: LocalOptimizeAway
---

# LocalOptimizeAway

### Synopsis

Optimize away a local channel when possible.

### Description

A local channel created with "/n" will not automatically optimize away. Calling this command on the local channel will clear that flag and allow it to optimize away if it's bridged or when it becomes bridged.<br>


### Syntax


```


Action: LocalOptimizeAway
ActionID: <value>
Channel: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Channel` - The channel name to optimize away.<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 