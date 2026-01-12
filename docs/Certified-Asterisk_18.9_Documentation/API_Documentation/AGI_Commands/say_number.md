---
search:
  boost: 0.5
title: SAY NUMBER
---

# SAY NUMBER

### Synopsis

Says a given number.

### Description

Say a given number, returning early if any of the given DTMF digits are received on the channel. Returns '0' if playback completes without a digit being pressed, or the ASCII numerical value of the digit if one was pressed or '-1' on error/hangup.<br>


### Syntax


```

SAY NUMBER NUMBER ESCAPE_DIGITS GENDER 
```
##### Arguments


* `number`

* `escape_digits`

* `gender`

### See Also

* [AGI Commands say_alpha](/Certified-Asterisk_18.9_Documentation/API_Documentation/AGI_Commands/say_alpha)
* [AGI Commands say_digits](/Certified-Asterisk_18.9_Documentation/API_Documentation/AGI_Commands/say_digits)
* [AGI Commands say_phonetic](/Certified-Asterisk_18.9_Documentation/API_Documentation/AGI_Commands/say_phonetic)
* [AGI Commands say_date](/Certified-Asterisk_18.9_Documentation/API_Documentation/AGI_Commands/say_date)
* [AGI Commands say_time](/Certified-Asterisk_18.9_Documentation/API_Documentation/AGI_Commands/say_time)
* [AGI Commands say_datetime](/Certified-Asterisk_18.9_Documentation/API_Documentation/AGI_Commands/say_datetime)
* [Dialplan Applications AGI](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/AGI)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 