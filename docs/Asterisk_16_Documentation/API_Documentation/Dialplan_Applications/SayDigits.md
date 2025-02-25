---
search:
  boost: 0.5
title: SayDigits
---

# SayDigits()

### Synopsis

Say Digits.

### Description

This application will play the sounds that correspond to the digits of the given number. This will use the language that is currently set for the channel. If the channel variable **SAY\_DTMF\_INTERRUPT** is set to 'true' (case insensitive), then this application will react to DTMF in the same way as 'Background'.<br>


### Syntax


```

SayDigits(digits)
```
##### Arguments


* `digits`

### See Also

* [Dialplan Applications SayAlpha](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/SayAlpha)
* [Dialplan Applications SayMoney](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/SayMoney)
* [Dialplan Applications SayNumber](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/SayNumber)
* [Dialplan Applications SayOrdinal](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/SayOrdinal)
* [Dialplan Applications SayPhonetic](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/SayPhonetic)
* [Dialplan Functions CHANNEL](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/CHANNEL)
* [Dialplan Functions SAYFILES](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/SAYFILES)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 