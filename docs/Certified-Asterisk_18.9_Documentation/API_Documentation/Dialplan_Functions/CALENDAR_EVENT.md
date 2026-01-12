---
search:
  boost: 0.5
title: CALENDAR_EVENT
---

# CALENDAR_EVENT()

### Synopsis

Get calendar event notification data from a notification call.

### Description

Whenever a calendar event notification call is made, the event data may be accessed with this function.<br>


### Syntax


```

CALENDAR_EVENT(field)
```
##### Arguments


* `field`

    * `summary` - The VEVENT SUMMARY property or Exchange event 'subject'<br>

    * `description` - The text description of the event<br>

    * `organizer` - The organizer of the event<br>

    * `location` - The location of the event<br>

    * `categories` - The categories of the event<br>

    * `priority` - The priority of the event<br>

    * `calendar` - The name of the calendar associated with the event<br>

    * `uid` - The unique identifier for this event<br>

    * `start` - The start time of the event<br>

    * `end` - The end time of the event<br>

    * `busystate` - The busy state of the event 0=FREE, 1=TENTATIVE, 2=BUSY<br>

### See Also

* [Dialplan Functions CALENDAR_BUSY](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/CALENDAR_BUSY)
* [Dialplan Functions CALENDAR_QUERY](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/CALENDAR_QUERY)
* [Dialplan Functions CALENDAR_QUERY_RESULT](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/CALENDAR_QUERY_RESULT)
* [Dialplan Functions CALENDAR_WRITE](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/CALENDAR_WRITE)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 