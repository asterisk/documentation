---
search:
  boost: 0.5
title: RECEIVE TEXT
---

# RECEIVE TEXT

### Synopsis

Receives text from channels supporting it.

### Description

Receives a string of text on a channel. Most channels do not support the reception of text. Returns '-1' for failure or '1' for success, and the string in parenthesis.<br>


### Syntax


```

RECEIVE TEXT TIMEOUT 
```
##### Arguments


* `timeout` - The timeout to be the maximum time to wait for input in milliseconds, or '0' for infinite.<br>

### See Also

* [AGI Commands receive_char](/Certified-Asterisk_18.9_Documentation/API_Documentation/AGI_Commands/receive_char)
* [AGI Commands send_text](/Certified-Asterisk_18.9_Documentation/API_Documentation/AGI_Commands/send_text)
* [Dialplan Applications AGI](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/AGI)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 