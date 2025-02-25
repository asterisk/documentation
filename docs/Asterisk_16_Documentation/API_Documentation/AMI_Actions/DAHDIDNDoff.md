---
search:
  boost: 0.5
title: DAHDIDNDoff
---

# DAHDIDNDoff

### Synopsis

Toggle DAHDI channel Do Not Disturb status OFF.

### Description

Equivalent to the CLI command "dahdi set dnd **channel** off".<br>


/// note
Feature only supported by analog channels.
///


### Syntax


```


    Action: DAHDIDNDoff
    ActionID: <value>
    DAHDIChannel: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `DAHDIChannel` - DAHDI channel number to set DND off.<br>


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 