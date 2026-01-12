---
search:
  boost: 0.5
title: RECEIVE CHAR
---

# RECEIVE CHAR

### Synopsis

Receives one character from channels supporting it.

### Description

Receives a character of text on a channel. Most channels do not support the reception of text. Returns the decimal value of the character if one is received, or '0' if the channel does not support text reception. Returns '-1' only on error/hangup.<br>


### Syntax


```

RECEIVE CHAR TIMEOUT 
```
##### Arguments


* `timeout` - The maximum time to wait for input in milliseconds, or '0' for infinite. Most channels<br>

### See Also

* [AGI Commands receive_text](/Certified-Asterisk_18.9_Documentation/API_Documentation/AGI_Commands/receive_text)
* [Dialplan Applications AGI](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/AGI)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 