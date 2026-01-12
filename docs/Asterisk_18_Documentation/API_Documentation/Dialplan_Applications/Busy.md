---
search:
  boost: 0.5
title: Busy
---

# Busy()

### Synopsis

Indicate the Busy condition.

### Description

This application will indicate the busy condition to the calling channel.<br>


### Syntax


```

Busy([timeout])
```
##### Arguments


* `timeout` - If specified, the calling channel will be hung up after the specified number of seconds. Otherwise, this application will wait until the calling channel hangs up.<br>

### See Also

* [Dialplan Applications Congestion](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/Congestion)
* [Dialplan Applications Progress](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/Progress)
* [Dialplan Applications PlayTones](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/PlayTones)
* [Dialplan Applications Hangup](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/Hangup)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 