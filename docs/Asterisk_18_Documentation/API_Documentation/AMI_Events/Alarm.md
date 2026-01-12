---
search:
  boost: 0.5
title: Alarm
---

# Alarm

### Synopsis

Raised when an alarm is set on a DAHDI channel.

### Syntax


```


Event: Alarm
DAHDIChannel: <value>
Alarm: <value>

```
##### Arguments


* `DAHDIChannel` - The channel on which the alarm occurred.<br>

    /// note
This is not an Asterisk channel identifier.
///


* `Alarm` - A textual description of the alarm that occurred.<br>

### Class

SYSTEM

### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 