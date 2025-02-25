---
search:
  boost: 0.5
title: DeadlockStart
---

# DeadlockStart

### Synopsis

Raised when a probable deadlock has started. Delivery of this event is attempted but not guaranteed, and could fail for example if the manager itself is deadlocked.

### Syntax


```


    Event: DeadlockStart
    Mutex: <value>

```
##### Arguments


* `Mutex` - The mutex involved in the deadlock.<br>

### Class

SYSTEM

### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 