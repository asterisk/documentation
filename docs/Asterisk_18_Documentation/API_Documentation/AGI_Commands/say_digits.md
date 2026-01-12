---
search:
  boost: 0.5
title: SAY DIGITS
---

# SAY DIGITS

### Synopsis

Says a given digit string.

### Description

Say a given digit string, returning early if any of the given DTMF digits are received on the channel. Returns '0' if playback completes without a digit being pressed, or the ASCII numerical value of the digit if one was pressed or '-1' on error/hangup.<br>


### Syntax


```

SAY DIGITS NUMBER ESCAPE_DIGITS 
```
##### Arguments


* `number`

* `escape_digits`

### See Also

* [AGI Commands say_alpha](/Asterisk_18_Documentation/API_Documentation/AGI_Commands/say_alpha)
* [AGI Commands say_number](/Asterisk_18_Documentation/API_Documentation/AGI_Commands/say_number)
* [AGI Commands say_phonetic](/Asterisk_18_Documentation/API_Documentation/AGI_Commands/say_phonetic)
* [AGI Commands say_date](/Asterisk_18_Documentation/API_Documentation/AGI_Commands/say_date)
* [AGI Commands say_time](/Asterisk_18_Documentation/API_Documentation/AGI_Commands/say_time)
* [AGI Commands say_datetime](/Asterisk_18_Documentation/API_Documentation/AGI_Commands/say_datetime)
* [Dialplan Applications AGI](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/AGI)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 