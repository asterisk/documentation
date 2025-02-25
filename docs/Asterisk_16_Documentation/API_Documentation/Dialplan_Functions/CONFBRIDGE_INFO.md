---
search:
  boost: 0.5
title: CONFBRIDGE_INFO
---

# CONFBRIDGE_INFO()

### Synopsis

Get information about a ConfBridge conference.

### Description

This function returns a non-negative integer for valid conference names and an empty string for invalid conference names.<br>


### Syntax


```

CONFBRIDGE_INFO(type,conf)
```
##### Arguments


* `type` - What conference information is requested.<br>

    * `admins` - Get the number of admin users in the conference.<br>

    * `locked` - Determine if the conference is locked. (0 or 1)<br>

    * `marked` - Get the number of marked users in the conference.<br>

    * `muted` - Determine if the conference is muted. (0 or 1)<br>

    * `parties` - Get the number of users in the conference.<br>

* `conf` - The name of the conference being referenced.<br>

### See Also

* [Dialplan Functions CONFBRIDGE_CHANNELS](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/CONFBRIDGE_CHANNELS)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 