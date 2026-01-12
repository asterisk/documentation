---
search:
  boost: 0.5
title: SayMoney
---

# SayMoney()

### Synopsis

Say Money.

### Description

This application will play the currency sounds for the given floating point number in the current language. Currently only English and US Dollars is supported. If the channel variable **SAY\_DTMF\_INTERRUPT** is set to 'true' (case insensitive), then this application will react to DTMF in the same way as 'BackGround'.<br>


### Syntax


```

SayMoney(dollars)
```
##### Arguments


* `dollars`

### See Also

* [Dialplan Applications SayAlpha](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/SayAlpha)
* [Dialplan Applications SayNumber](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/SayNumber)
* [Dialplan Applications SayOrdinal](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/SayOrdinal)
* [Dialplan Applications SayPhonetic](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/SayPhonetic)
* [Dialplan Functions CHANNEL](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/CHANNEL)
* [Dialplan Functions SAYFILES](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/SAYFILES)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 