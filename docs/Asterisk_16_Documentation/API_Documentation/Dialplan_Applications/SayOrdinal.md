---
search:
  boost: 0.5
title: SayOrdinal
---

# SayOrdinal()

### Synopsis

Say Ordinal Number.

### Description

This application will play the ordinal sounds that correspond to the given _digits_ (e.g. 1st, 42nd). Currently only English is supported.<br>

Optionally, a _gender_ may be specified. This will use the language that is currently set for the channel. See the CHANNEL() function for more information on setting the language for the channel. If the channel variable **SAY\_DTMF\_INTERRUPT** is set to 'true' (case insensitive), then this application will react to DTMF in the same way as 'Background'.<br>


### Syntax


```

SayOrdinal(digits,[gender])
```
##### Arguments


* `digits`

* `gender`

### See Also

* [Dialplan Applications SayAlpha](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/SayAlpha)
* [Dialplan Applications SayDigits](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/SayDigits)
* [Dialplan Applications SayMoney](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/SayMoney)
* [Dialplan Applications SayNumber](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/SayNumber)
* [Dialplan Applications SayPhonetic](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/SayPhonetic)
* [Dialplan Functions CHANNEL](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/CHANNEL)
* [Dialplan Functions SAYFILES](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/SAYFILES)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 