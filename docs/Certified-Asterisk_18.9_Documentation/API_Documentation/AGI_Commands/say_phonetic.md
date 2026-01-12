---
search:
  boost: 0.5
title: SAY PHONETIC
---

# SAY PHONETIC

### Synopsis

Says a given character string with phonetics.

### Description

Say a given character string with phonetics, returning early if any of the given DTMF digits are received on the channel. Returns '0' if playback completes without a digit pressed, the ASCII numerical value of the digit if one was pressed, or '-1' on error/hangup.<br>


### Syntax


```

SAY PHONETIC STRING ESCAPE_DIGITS 
```
##### Arguments


* `string`

* `escape_digits`

### See Also

* [AGI Commands say_alpha](/Certified-Asterisk_18.9_Documentation/API_Documentation/AGI_Commands/say_alpha)
* [AGI Commands say_digits](/Certified-Asterisk_18.9_Documentation/API_Documentation/AGI_Commands/say_digits)
* [AGI Commands say_number](/Certified-Asterisk_18.9_Documentation/API_Documentation/AGI_Commands/say_number)
* [AGI Commands say_date](/Certified-Asterisk_18.9_Documentation/API_Documentation/AGI_Commands/say_date)
* [AGI Commands say_time](/Certified-Asterisk_18.9_Documentation/API_Documentation/AGI_Commands/say_time)
* [AGI Commands say_datetime](/Certified-Asterisk_18.9_Documentation/API_Documentation/AGI_Commands/say_datetime)
* [Dialplan Applications AGI](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/AGI)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 