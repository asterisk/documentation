---
search:
  boost: 0.5
title: SayNumber
---

# SayNumber()

### Synopsis

Say Number.

### Description

This application will play the sounds that correspond to the given _digits_. Optionally, a _gender_ may be specified. This will use the language that is currently set for the channel. See the CHANNEL() function for more information on setting the language for the channel. If the channel variable **SAY\_DTMF\_INTERRUPT** is set to 'true' (case insensitive), then this application will react to DTMF in the same way as 'BackGround'.<br>


### Syntax


```

SayNumber(digits,[gender])
```
##### Arguments


* `digits`

* `gender`

### See Also

* [Dialplan Applications SayAlpha](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/SayAlpha)
* [Dialplan Applications SayDigits](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/SayDigits)
* [Dialplan Applications SayMoney](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/SayMoney)
* [Dialplan Applications SayPhonetic](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/SayPhonetic)
* [Dialplan Functions CHANNEL](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/CHANNEL)
* [Dialplan Functions SAYFILES](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/SAYFILES)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 