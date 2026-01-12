---
search:
  boost: 0.5
title: MeetMeCount
---

# MeetMeCount()

### Synopsis

MeetMe participant count.

### Description

Plays back the number of users in the specified MeetMe conference. If _var_ is specified, playback will be skipped and the value will be returned in the variable. Upon application completion, MeetMeCount will hangup the channel, unless priority 'n+1' exists, in which case priority progress will continue.<br>


### Syntax


```

MeetMeCount(confno,[var])
```
##### Arguments


* `confno` - Conference number.<br>

* `var`

### See Also

* [Dialplan Applications MeetMe](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/MeetMe)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 