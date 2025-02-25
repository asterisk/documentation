---
search:
  boost: 0.5
title: SAY TIME
---

# SAY TIME

### Synopsis

Says a given time.

### Description

Say a given time, returning early if any of the given DTMF digits are received on the channel. Returns '0' if playback completes without a digit being pressed, or the ASCII numerical value of the digit if one was pressed or '-1' on error/hangup.<br>


### Syntax


```

SAY TIME TIME ESCAPE_DIGITS 
```
##### Arguments


* `time` - Is number of seconds elapsed since 00:00:00 on January 1, 1970. Coordinated Universal Time (UTC).<br>

* `escape_digits`

### See Also

* [AGI Commands say_alpha](/Asterisk_16_Documentation/API_Documentation/AGI_Commands/say_alpha)
* [AGI Commands say_digits](/Asterisk_16_Documentation/API_Documentation/AGI_Commands/say_digits)
* [AGI Commands say_number](/Asterisk_16_Documentation/API_Documentation/AGI_Commands/say_number)
* [AGI Commands say_phonetic](/Asterisk_16_Documentation/API_Documentation/AGI_Commands/say_phonetic)
* [AGI Commands say_date](/Asterisk_16_Documentation/API_Documentation/AGI_Commands/say_date)
* [AGI Commands say_datetime](/Asterisk_16_Documentation/API_Documentation/AGI_Commands/say_datetime)
* [Dialplan Applications AGI](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/AGI)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 