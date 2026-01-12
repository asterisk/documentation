---
search:
  boost: 0.5
title: WaitUntil
---

# WaitUntil()

### Synopsis

Wait (sleep) until the current time is the given epoch.

### Description

Waits until the given _epoch_.<br>

Sets **WAITUNTILSTATUS** to one of the following values:<br>


* `WAITUNTILSTATUS`

    * `OK` - Wait succeeded.

    * `FAILURE` - Invalid argument.

    * `HANGUP` - Channel hungup before time elapsed.

    * `PAST` - Time specified had already past.

### Syntax


```

WaitUntil(epoch)
```
##### Arguments


* `epoch`


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 