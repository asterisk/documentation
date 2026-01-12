---
search:
  boost: 0.5
title: SAY DATE
---

# SAY DATE

### Synopsis

Says a given date.

### Description

Say a given date, returning early if any of the given DTMF digits are received on the channel. Returns '0' if playback completes without a digit being pressed, or the ASCII numerical value of the digit if one was pressed or '-1' on error/hangup.<br>


### Syntax


```

SAY DATE DATE ESCAPE_DIGITS 
```
##### Arguments


* `date` - Is number of seconds elapsed since 00:00:00 on January 1, 1970. Coordinated Universal Time (UTC).<br>

* `escape_digits`

### See Also

* [AGI Commands say_alpha](/Asterisk_18_Documentation/API_Documentation/AGI_Commands/say_alpha)
* [AGI Commands say_digits](/Asterisk_18_Documentation/API_Documentation/AGI_Commands/say_digits)
* [AGI Commands say_number](/Asterisk_18_Documentation/API_Documentation/AGI_Commands/say_number)
* [AGI Commands say_phonetic](/Asterisk_18_Documentation/API_Documentation/AGI_Commands/say_phonetic)
* [AGI Commands say_time](/Asterisk_18_Documentation/API_Documentation/AGI_Commands/say_time)
* [AGI Commands say_datetime](/Asterisk_18_Documentation/API_Documentation/AGI_Commands/say_datetime)
* [Dialplan Applications AGI](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/AGI)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 