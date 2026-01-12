---
search:
  boost: 0.5
title: SEND TEXT
---

# SEND TEXT

### Synopsis

Sends text to channels supporting it.

### Description

Sends the given text on a channel. Most channels do not support the transmission of text. Returns '0' if text is sent, or if the channel does not support text transmission. Returns '-1' only on error/hangup.<br>


### Syntax


```

SEND TEXT TEXT TO SEND 
```
##### Arguments


* `text to send` - Text consisting of greater than one word should be placed in quotes since the command only accepts a single argument.<br>

### See Also

* [AGI Commands receive_text](/Asterisk_18_Documentation/API_Documentation/AGI_Commands/receive_text)
* [Dialplan Applications AGI](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/AGI)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 