---
search:
  boost: 0.5
title: ConfbridgeMute
---

# ConfbridgeMute

### Synopsis

Mute a Confbridge user.

### Description


### Syntax


```


Action: ConfbridgeMute
ActionID: <value>
Conference: <value>
Channel: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Conference`

* `Channel` - If this parameter is not a complete channel name, the first channel with this prefix will be used.<br>
If this parameter is "all", all channels will be muted.<br>
If this parameter is "participants", all non-admin channels will be muted.<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 