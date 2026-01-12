---
search:
  boost: 0.5
title: DateTime
---

# DateTime()

### Synopsis

Says a specified time in a custom format.

### Description

Say the date and time in a specified format.<br>


### Syntax


```

DateTime([unixtime,[timezone,[format]]])
```
##### Arguments


* `unixtime` - time, in seconds since Jan 1, 1970. May be negative. Defaults to now.<br>

* `timezone` - timezone, see */usr/share/zoneinfo* for a list. Defaults to machine default.<br>

* `format` - a format the time is to be said in. See *voicemail.conf*. Defaults to 'ABdY "digits/at" IMp'<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 