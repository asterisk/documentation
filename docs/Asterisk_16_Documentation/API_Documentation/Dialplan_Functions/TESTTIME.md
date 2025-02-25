---
search:
  boost: 0.5
title: TESTTIME
---

# TESTTIME()

### Synopsis

Sets a time to be used with the channel to test logical conditions.

### Description

To test dialplan timing conditions at times other than the current time, use this function to set an alternate date and time. For example, you may wish to evaluate whether a location will correctly identify to callers that the area is closed on Christmas Day, when Christmas would otherwise fall on a day when the office is normally open.<br>


### Syntax


```

TESTTIME(date,time[,zone])
```
##### Arguments


* `date` - Date in ISO 8601 format<br>

* `time` - Time in HH:MM:SS format (24-hour time)<br>

* `zone` - Timezone name<br>

### See Also

* [Dialplan Applications GotoIfTime](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/GotoIfTime)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 