---
search:
  boost: 0.5
title: Congestion
---

# Congestion()

### Synopsis

Indicate the Congestion condition.

### Description

This application will indicate the congestion condition to the calling channel.<br>


### Syntax


```

Congestion([timeout])
```
##### Arguments


* `timeout` - If specified, the calling channel will be hung up after the specified number of seconds. Otherwise, this application will wait until the calling channel hangs up.<br>

### See Also

* [Dialplan Applications Busy](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/Busy)
* [Dialplan Applications Progress](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/Progress)
* [Dialplan Applications PlayTones](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/PlayTones)
* [Dialplan Applications Hangup](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/Hangup)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 