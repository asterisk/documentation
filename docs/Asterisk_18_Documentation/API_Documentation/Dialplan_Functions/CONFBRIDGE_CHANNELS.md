---
search:
  boost: 0.5
title: CONFBRIDGE_CHANNELS
---

# CONFBRIDGE_CHANNELS()

### Synopsis

Get a list of channels in a ConfBridge conference.

### Since

16.26.0, 18.12.0, 19.4.0

### Description

This function returns a comma-separated list of channels in a ConfBridge conference, optionally filtered by a type of participant.<br>


### Syntax


```

CONFBRIDGE_CHANNELS(type,conf)
```
##### Arguments


* `type` - What conference information is requested.<br>

    * `admins` - Get the number of admin users in the conference.<br>

    * `marked` - Get the number of marked users in the conference.<br>

    * `parties` - Get the number of total users in the conference.<br>

    * `active` - Get the number of active users in the conference.<br>

    * `waiting` - Get the number of waiting users in the conference.<br>

* `conf` - The name of the conference being referenced.<br>

### See Also

* [Dialplan Functions CONFBRIDGE_INFO](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/CONFBRIDGE_INFO)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 