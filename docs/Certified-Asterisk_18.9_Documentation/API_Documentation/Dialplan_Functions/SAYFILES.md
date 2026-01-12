---
search:
  boost: 0.5
title: SAYFILES
---

# SAYFILES()

### Synopsis

Returns the ampersand-delimited file names that would be played by the Say applications (e.g. SayAlpha, SayDigits).

### Description

Returns the files that would be played by a Say application. These filenames could then be passed directly into Playback, BackGround, Read, Queue, or any application which supports playback of multiple ampersand-delimited files.<br>

``` title="Example: Read using the number 123"

same => n,Read(response,${SAYFILES(123,number)})


```

### Syntax


```

SAYFILES(value,type)
```
##### Arguments


* `value` - The value to be translated to filenames.<br>

* `type` - Say application type.<br>

    * `alpha` - Files played by SayAlpha(). Default if none is specified.<br>

    * `digits` - Files played by SayDigits().<br>

    * `money` - Files played by SayMoney(). Currently supported for English and US dollars only.<br>

    * `number` - Files played by SayNumber(). Currently supported for English only.<br>

    * `ordinal` - Files played by SayOrdinal(). Currently supported for English only.<br>

    * `phonetic` - Files played by SayPhonetic().<br>

### See Also

* [Dialplan Applications SayAlpha](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/SayAlpha)
* [Dialplan Applications SayDigits](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/SayDigits)
* [Dialplan Applications SayMoney](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/SayMoney)
* [Dialplan Applications SayNumber](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/SayNumber)
* [Dialplan Applications SayOrdinal](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/SayOrdinal)
* [Dialplan Applications SayPhonetic](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/SayPhonetic)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 