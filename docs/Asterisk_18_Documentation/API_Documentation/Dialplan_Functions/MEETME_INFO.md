---
search:
  boost: 0.5
title: MEETME_INFO
---

# MEETME_INFO()

### Synopsis

Query a given conference of various properties.

### Description


### Syntax


```

MEETME_INFO(keyword,confno)
```
##### Arguments


* `keyword` - Options:<br>

    * `lock` - Boolean of whether the corresponding conference is locked.<br>

    * `parties` - Number of parties in a given conference<br>

    * `activity` - Duration of conference in seconds.<br>

    * `dynamic` - Boolean of whether the corresponding conference is dynamic.<br>

* `confno` - Conference number to retrieve information from.<br>

### See Also

* [Dialplan Applications MeetMe](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/MeetMe)
* [Dialplan Applications MeetMeCount](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/MeetMeCount)
* [Dialplan Applications MeetMeAdmin](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/MeetMeAdmin)
* [Dialplan Applications MeetMeChannelAdmin](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/MeetMeChannelAdmin)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 