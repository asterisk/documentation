---
search:
  boost: 0.5
title: PlayMF
---

# PlayMF

### Synopsis

Play MF signal on a specific channel.

### Description

Plays an MF digit on the specified channel.<br>


### Syntax


```


Action: PlayMF
ActionID: <value>
Channel: <value>
Digit: <value>
[Duration: <value>]

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Channel` - Channel name to send digit to.<br>

* `Digit` - The MF digit to play.<br>

* `Duration` - The duration, in milliseconds, of the digit to be played.<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 