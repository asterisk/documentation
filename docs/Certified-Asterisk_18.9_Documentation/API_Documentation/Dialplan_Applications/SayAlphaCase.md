---
search:
  boost: 0.5
title: SayAlphaCase
---

# SayAlphaCase()

### Synopsis

Say Alpha.

### Description

This application will play the sounds that correspond to the letters of the given _string_. Optionally, a _casetype_ may be specified. This will be used for case-insensitive or case-sensitive pronunciations. If the channel variable **SAY\_DTMF\_INTERRUPT** is set to 'true' (case insensitive), then this application will react to DTMF in the same way as 'BackGround'.<br>


### Syntax


```

SayAlphaCase(casetype,string)
```
##### Arguments


* `casetype`

    * `a` - Case sensitive (all) pronunciation. (Ex: SayAlphaCase(a,aBc); - lowercase a uppercase b lowercase c).<br>

    * `l` - Case sensitive (lower) pronunciation. (Ex: SayAlphaCase(l,aBc); - lowercase a b lowercase c).<br>

    * `n` - Case insensitive pronunciation. Equivalent to SayAlpha. (Ex: SayAlphaCase(n,aBc) - a b c).<br>

    * `u` - Case sensitive (upper) pronunciation. (Ex: SayAlphaCase(u,aBc); - a uppercase b c).<br>

* `string`

### See Also

* [Dialplan Applications SayDigits](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/SayDigits)
* [Dialplan Applications SayMoney](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/SayMoney)
* [Dialplan Applications SayNumber](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/SayNumber)
* [Dialplan Applications SayOrdinal](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/SayOrdinal)
* [Dialplan Applications SayPhonetic](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/SayPhonetic)
* [Dialplan Applications SayAlpha](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/SayAlpha)
* [Dialplan Functions CHANNEL](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/CHANNEL)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 