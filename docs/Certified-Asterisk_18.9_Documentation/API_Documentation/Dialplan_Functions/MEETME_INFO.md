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

* [Dialplan Applications MeetMe](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/MeetMe)
* [Dialplan Applications MeetMeCount](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/MeetMeCount)
* [Dialplan Applications MeetMeAdmin](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/MeetMeAdmin)
* [Dialplan Applications MeetMeChannelAdmin](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/MeetMeChannelAdmin)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 