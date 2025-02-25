---
search:
  boost: 0.5
title: DAHDIDNDon
---

# DAHDIDNDon

### Synopsis

Toggle DAHDI channel Do Not Disturb status ON.

### Description

Equivalent to the CLI command "dahdi set dnd **channel** on".<br>


/// note
Feature only supported by analog channels.
///


### Syntax


```


    Action: DAHDIDNDon
    ActionID: <value>
    DAHDIChannel: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `DAHDIChannel` - DAHDI channel number to set DND on.<br>


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 