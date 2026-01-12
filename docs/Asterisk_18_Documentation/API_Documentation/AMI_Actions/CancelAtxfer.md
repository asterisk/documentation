---
search:
  boost: 0.5
title: CancelAtxfer
---

# CancelAtxfer

### Synopsis

Cancel an attended transfer.

### Since

13.18.0, 14.7.0, 15.1.0, 16.0.0

### Description

Cancel an attended transfer. Note, this uses the configured cancel attended transfer feature option (atxferabort) to cancel the transfer. If not available this action will fail.<br>


### Syntax


```


Action: CancelAtxfer
ActionID: <value>
Channel: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Channel` - The transferer channel.<br>

### See Also

* [AMI Events AttendedTransfer](/Asterisk_18_Documentation/API_Documentation/AMI_Events/AttendedTransfer)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 