---
search:
  boost: 0.5
title: WaitDigit
---

# WaitDigit()

### Synopsis

Waits for a digit to be entered.

### Description

This application waits for the user to press one of the accepted _digits_ for a specified number of _seconds_.<br>


* `WAITDIGITSTATUS` - This is the final status of the command<br>

    * `ERROR` - Parameters are invalid.

    * `DTMF` - An accepted digit was received.

    * `TIMEOUT` - The timeout passed before any acceptable digits were received.

    * `CANCEL` - The channel has hungup or was redirected.

* `WAITDIGITRESULT` - The digit that was received, only set if **WAITDIGITSTATUS** is 'DTMF'.<br>

### Syntax


```

WaitDigit([seconds,[digits]])
```
##### Arguments


* `seconds` - Can be passed with fractions of a second. For example, '1.5' will ask the application to wait for 1.5 seconds.<br>

* `digits` - Digits to accept, all others are ignored.<br>

### See Also

* [Dialplan Applications Wait](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/Wait)
* [Dialplan Applications WaitExten](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/WaitExten)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 