---
search:
  boost: 0.5
title: SAY DATETIME
---

# SAY DATETIME

### Synopsis

Says a given time as specified by the format given.

### Description

Say a given time, returning early if any of the given DTMF digits are received on the channel. Returns '0' if playback completes without a digit being pressed, or the ASCII numerical value of the digit if one was pressed or '-1' on error/hangup.<br>


### Syntax


```

SAY DATETIME TIME ESCAPE_DIGITS FORMAT TIMEZONE 
```
##### Arguments


* `time` - Is number of seconds elapsed since 00:00:00 on January 1, 1970, Coordinated Universal Time (UTC)<br>

* `escape_digits`

* `format` - Is the format the time should be said in. See *voicemail.conf* (defaults to 'ABdY 'digits/at' IMp').<br>

* `timezone` - Acceptable values can be found in */usr/share/zoneinfo* Defaults to machine default.<br>

### See Also

* [AGI Commands say_alpha](/Certified-Asterisk_18.9_Documentation/API_Documentation/AGI_Commands/say_alpha)
* [AGI Commands say_digits](/Certified-Asterisk_18.9_Documentation/API_Documentation/AGI_Commands/say_digits)
* [AGI Commands say_number](/Certified-Asterisk_18.9_Documentation/API_Documentation/AGI_Commands/say_number)
* [AGI Commands say_phonetic](/Certified-Asterisk_18.9_Documentation/API_Documentation/AGI_Commands/say_phonetic)
* [AGI Commands say_date](/Certified-Asterisk_18.9_Documentation/API_Documentation/AGI_Commands/say_date)
* [AGI Commands say_time](/Certified-Asterisk_18.9_Documentation/API_Documentation/AGI_Commands/say_time)
* [Dialplan Applications AGI](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/AGI)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 