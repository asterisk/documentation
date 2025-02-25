---
search:
  boost: 0.5
title: DAHDITransfer
---

# DAHDITransfer

### Synopsis

Transfer DAHDI Channel.

### Description

Simulate a flash hook event by the user connected to the channel.<br>


/// note
Valid only for analog channels.
///


### Syntax


```


    Action: DAHDITransfer
    ActionID: <value>
    DAHDIChannel: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `DAHDIChannel` - DAHDI channel number to transfer.<br>


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 