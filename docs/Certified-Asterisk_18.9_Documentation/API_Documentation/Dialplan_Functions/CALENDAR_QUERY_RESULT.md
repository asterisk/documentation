---
search:
  boost: 0.5
title: CALENDAR_QUERY_RESULT
---

# CALENDAR_QUERY_RESULT()

### Synopsis

Retrieve data from a previously run CALENDAR_QUERY() call

### Description

After running CALENDAR\_QUERY and getting a result _id_, calling 'CALENDAR\_QUERY' with that _id_ and a _field_ will return the data for that field. If multiple events matched the query, and _entry_ is provided, information from that event will be returned.<br>


### Syntax


```

CALENDAR_QUERY_RESULT(id,field[,entry])
```
##### Arguments


* `id` - The query ID returned by 'CALENDAR\_QUERY'<br>

* `field`

    * `getnum` - number of events occurring during time range<br>

    * `summary` - A summary of the event<br>

    * `description` - The full event description<br>

    * `organizer` - The event organizer<br>

    * `location` - The event location<br>

    * `categories` - The categories of the event<br>

    * `priority` - The priority of the event<br>

    * `calendar` - The name of the calendar associted with the event<br>

    * `uid` - The unique identifier for the event<br>

    * `start` - The start time of the event (in seconds since epoch)<br>

    * `end` - The end time of the event (in seconds since epoch)<br>

    * `busystate` - The busy status of the event 0=FREE, 1=TENTATIVE, 2=BUSY<br>

* `entry` - Return data from a specific event returned by the query<br>

### See Also

* [Dialplan Functions CALENDAR_BUSY](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/CALENDAR_BUSY)
* [Dialplan Functions CALENDAR_EVENT](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/CALENDAR_EVENT)
* [Dialplan Functions CALENDAR_QUERY](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/CALENDAR_QUERY)
* [Dialplan Functions CALENDAR_WRITE](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/CALENDAR_WRITE)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 