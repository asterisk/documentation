---
search:
  boost: 0.5
title: HANGUPCAUSE
---

# HANGUPCAUSE()

### Synopsis

Gets per-channel hangupcause information from the channel.

### Description

Gets technology-specific or translated Asterisk cause code information from the channel for the specified channel that resulted from a dial.<br>


### Syntax


```

HANGUPCAUSE(channel,type)
```
##### Arguments


* `channel` - The name of the channel for which to retrieve cause information.<br>

* `type` - Parameter describing which type of information is requested. Types are:<br>

    * `tech` - Technology-specific cause information<br>

    * `ast` - Translated Asterisk cause code<br>

### See Also

* [Dialplan Functions HANGUPCAUSE_KEYS](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/HANGUPCAUSE_KEYS)
* [Dialplan Applications HangupCauseClear](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/HangupCauseClear)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 