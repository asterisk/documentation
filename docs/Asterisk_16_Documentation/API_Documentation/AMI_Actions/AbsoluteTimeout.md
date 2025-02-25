---
search:
  boost: 0.5
title: AbsoluteTimeout
---

# AbsoluteTimeout

### Synopsis

Set absolute timeout.

### Description

Hangup a channel after a certain time. Acknowledges set time with 'Timeout Set' message.<br>


### Syntax


```


    Action: AbsoluteTimeout
    ActionID: <value>
    Channel: <value>
    Timeout: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Channel` - Channel name to hangup.<br>

* `Timeout` - Maximum duration of the call (sec).<br>


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 