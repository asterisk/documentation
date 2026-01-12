---
search:
  boost: 0.5
title: DAHDIDialOffhook
---

# DAHDIDialOffhook

### Synopsis

Dial over DAHDI channel while offhook.

### Description

Generate DTMF control frames to the bridged peer.<br>


### Syntax


```


Action: DAHDIDialOffhook
ActionID: <value>
DAHDIChannel: <value>
Number: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `DAHDIChannel` - DAHDI channel number to dial digits.<br>

* `Number` - Digits to dial.<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 