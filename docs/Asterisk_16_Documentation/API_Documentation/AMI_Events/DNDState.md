---
search:
  boost: 0.5
title: DNDState
---

# DNDState

### Synopsis

Raised when the Do Not Disturb state is changed on a DAHDI channel.

### Syntax


```


    Event: DNDState
    DAHDIChannel: <value>
    Status: <value>

```
##### Arguments


* `DAHDIChannel` - The DAHDI channel on which DND status changed.<br>

    /// note
This is not an Asterisk channel identifier.
///


* `Status`

    * `enabled`

    * `disabled`

### Class

SYSTEM

### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 