---
search:
  boost: 0.5
title: ChanIsAvail
---

# ChanIsAvail()

### Synopsis

Check channel availability

### Description

This application will check to see if any of the specified channels are available.<br>

This application sets the following channel variables:<br>


* `AVAILCHAN` - The name of the available channel, if one exists<br>

* `AVAILORIGCHAN` - The canonical channel name that was used to create the channel<br>

* `AVAILSTATUS` - The device state for the device<br>

* `AVAILCAUSECODE` - The cause code returned when requesting the channel<br>

### Syntax


```

ChanIsAvail(Technology/Resource&[Technology2/Resource2[&...]],[options]])
```
##### Arguments


* `Technology/Resource`

    * `Technology/Resource` **required** - Specification of the device(s) to check. These must be in the format of 'Technology/Resource', where _Technology_ represents a particular channel driver, and _Resource_ represents a resource available to that particular channel driver.<br>

    * `Technology2/Resource2[,Technology2/Resource2...]` - Optional extra devices to check<br>
If you need more than one enter them as Technology2/Resource2&Technology3/Resource3&.....<br>

* `options`

    * `a` - Check for all available channels, not only the first one<br>


    * `s` - Consider the channel unavailable if the channel is in use at all<br>


    * `t` - Simply checks if specified channels exist in the channel list<br>



### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 