---
search:
  boost: 0.5
title: CALENDAR_WRITE
---

# CALENDAR_WRITE()

### Synopsis

Write an event to a calendar

### Description

``` title="Example: Set calendar fields"

same => n,Set(CALENDAR_WRITE(calendar,field1,field2,field3)=val1,val2,val3)


```
The field and value arguments can easily be set/passed using the HASHKEYS() and HASH() functions<br>


* `CALENDAR_SUCCESS` - The status of the write operation to the calendar<br>

    * `1` - The event was successfully written to the calendar.

    * `0` - The event was not written to the calendar due to network issues, permissions, etc.

### Syntax


```

CALENDAR_WRITE(calendar,field[,...])
```
##### Arguments


* `calendar` - The calendar to write to<br>

* `field`

    * `summary` - A summary of the event<br>

    * `description` - The full event description<br>

    * `organizer` - The event organizer<br>

    * `location` - The event location<br>

    * `categories` - The categories of the event<br>

    * `priority` - The priority of the event<br>

    * `uid` - The unique identifier for the event<br>

    * `start` - The start time of the event (in seconds since epoch)<br>

    * `end` - The end time of the event (in seconds since epoch)<br>

    * `busystate` - The busy status of the event 0=FREE, 1=TENTATIVE, 2=BUSY<br>

### See Also

* [Dialplan Functions CALENDAR_BUSY](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/CALENDAR_BUSY)
* [Dialplan Functions CALENDAR_EVENT](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/CALENDAR_EVENT)
* [Dialplan Functions CALENDAR_QUERY](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/CALENDAR_QUERY)
* [Dialplan Functions CALENDAR_QUERY_RESULT](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/CALENDAR_QUERY_RESULT)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 