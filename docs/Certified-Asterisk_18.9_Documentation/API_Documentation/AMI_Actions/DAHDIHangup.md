---
search:
  boost: 0.5
title: DAHDIHangup
---

# DAHDIHangup

### Synopsis

Hangup DAHDI Channel.

### Description

Simulate an on-hook event by the user connected to the channel.<br>


/// note
Valid only for analog channels.
///


### Syntax


```


Action: DAHDIHangup
ActionID: <value>
DAHDIChannel: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `DAHDIChannel` - DAHDI channel number to hangup.<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 