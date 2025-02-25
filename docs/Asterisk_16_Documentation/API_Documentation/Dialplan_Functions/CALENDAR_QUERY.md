---
search:
  boost: 0.5
title: CALENDAR_QUERY
---

# CALENDAR_QUERY()

### Synopsis

Query a calendar server and store the data on a channel

### Description

Get a list of events in the currently accessible timeframe of the _calendar_ The function returns the id for accessing the result with CALENDAR\_QUERY\_RESULT()<br>


### Syntax


```

CALENDAR_QUERY(calendar[,start[,end]])
```
##### Arguments


* `calendar` - The calendar that should be queried<br>

* `start` - The start time of the query (in seconds since epoch)<br>

* `end` - The end time of the query (in seconds since epoch)<br>

### See Also

* [Dialplan Functions CALENDAR_BUSY](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/CALENDAR_BUSY)
* [Dialplan Functions CALENDAR_EVENT](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/CALENDAR_EVENT)
* [Dialplan Functions CALENDAR_QUERY_RESULT](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/CALENDAR_QUERY_RESULT)
* [Dialplan Functions CALENDAR_WRITE](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/CALENDAR_WRITE)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 