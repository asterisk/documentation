---
search:
  boost: 0.5
title: CHANNEL STATUS
---

# CHANNEL STATUS

### Synopsis

Returns status of the connected channel.

### Description

Returns the status of the specified _channelname_. If no channel name is given then returns the status of the current channel.<br>

Return values:<br>


* `0` - Channel is down and available.<br>

* `1` - Channel is down, but reserved.<br>

* `2` - Channel is off hook.<br>

* `3` - Digits (or equivalent) have been dialed.<br>

* `4` - Line is ringing.<br>

* `5` - Remote end is ringing.<br>

* `6` - Line is up.<br>

* `7` - Line is busy.<br>

### Syntax


```

CHANNEL STATUS CHANNELNAME 
```
##### Arguments


* `channelname`

### See Also

* [Dialplan Applications AGI](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/AGI)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 