---
search:
  boost: 0.5
title: MusicOnHold
---

# MusicOnHold()

### Synopsis

Play Music On Hold indefinitely.

### Description

Plays hold music specified by class. If omitted, the default music source for the channel will be used. Change the default class with Set(CHANNEL(musicclass)=...). If duration is given, hold music will be played specified number of seconds. If duration is omitted, music plays indefinitely. Returns '0' when done, '-1' on hangup.<br>

This application does not automatically answer and should be preceeded by an application such as Answer() or Progress().<br>


### Syntax


```

MusicOnHold(class,[duration])
```
##### Arguments


* `class`

* `duration`


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 