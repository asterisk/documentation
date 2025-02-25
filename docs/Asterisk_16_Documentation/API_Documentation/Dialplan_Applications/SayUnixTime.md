---
search:
  boost: 0.5
title: SayUnixTime
---

# SayUnixTime()

### Synopsis

Says a specified time in a custom format.

### Description

Uses some of the sound files stored in */var/lib/asterisk/sounds* to construct a phrase saying the specified date and/or time in the specified format.<br>


### Syntax


```

SayUnixTime([unixtime,[timezone,[format,[options]]]])
```
##### Arguments


* `unixtime` - time, in seconds since Jan 1, 1970. May be negative. Defaults to now.<br>

* `timezone` - timezone, see */usr/share/zoneinfo* for a list. Defaults to machine default.<br>

* `format` - a format the time is to be said in. See *voicemail.conf*. Defaults to 'ABdY "digits/at" IMp'<br>

* `options`

    * `j` - Allow the calling user to dial digits to jump to that extension. This option is automatically enabled if **SAY\_DTMF\_INTERRUPT** is present on the channel and set to 'true' (case insensitive)<br>


### See Also

* [Dialplan Functions STRFTIME](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/STRFTIME)
* [Dialplan Functions STRPTIME](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/STRPTIME)
* [Dialplan Functions IFTIME](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/IFTIME)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 