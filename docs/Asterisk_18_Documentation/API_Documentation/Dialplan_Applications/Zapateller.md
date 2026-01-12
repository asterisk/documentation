---
search:
  boost: 0.5
title: Zapateller
---

# Zapateller()

### Synopsis

Block telemarketers with SIT.

### Description

Generates special information tone to block telemarketers from calling you.<br>

This application will set the following channel variable upon completion:<br>


* `ZAPATELLERSTATUS` - This will contain the last action accomplished by the Zapateller application. Possible values include:<br>

    * `NOTHING`

    * `ANSWERED`

    * `ZAPPED`

### Syntax


```

Zapateller(options)
```
##### Arguments


* `options` - Comma delimited list of options.<br>

    * `answer` - Causes the line to be answered before playing the tone.<br>


    * `nocallerid` - Causes Zapateller to only play the tone if there is no callerid information available.<br>



### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 