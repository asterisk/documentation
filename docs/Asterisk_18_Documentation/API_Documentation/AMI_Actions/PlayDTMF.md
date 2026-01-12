---
search:
  boost: 0.5
title: PlayDTMF
---

# PlayDTMF

### Synopsis

Play DTMF signal on a specific channel.

### Description

Plays a dtmf digit on the specified channel.<br>


### Syntax


```


Action: PlayDTMF
ActionID: <value>
Channel: <value>
Digit: <value>
[Duration: <value>]
[Receive: <value>]

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Channel` - Channel name to send digit to.<br>

* `Digit` - The DTMF digit to play.<br>

* `Duration` - The duration, in milliseconds, of the digit to be played.<br>

* `Receive` - Emulate receiving DTMF on this channel instead of sending it out.<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 