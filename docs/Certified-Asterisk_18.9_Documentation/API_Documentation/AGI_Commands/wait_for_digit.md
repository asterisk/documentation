---
search:
  boost: 0.5
title: WAIT FOR DIGIT
---

# WAIT FOR DIGIT

### Synopsis

Waits for a digit to be pressed.

### Description

Waits up to _timeout_ milliseconds for channel to receive a DTMF digit. Returns '-1' on channel failure, '0' if no digit is received in the timeout, or the numerical value of the ascii of the digit if one is received. Use '-1' for the _timeout_ value if you desire the call to block indefinitely.<br>


### Syntax


```

WAIT FOR DIGIT TIMEOUT 
```
##### Arguments


* `timeout`

### See Also

* [Dialplan Applications AGI](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/AGI)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 