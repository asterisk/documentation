---
search:
  boost: 0.5
title: WaitExten
---

# WaitExten()

### Synopsis

Waits for an extension to be entered.

### Description

This application waits for the user to enter a new extension for a specified number of _seconds_.<br>


/// warning
Use of the application 'WaitExten' within a macro will not function as expected. Please use the 'Read' application in order to read DTMF from a channel currently executing a macro.
///


### Syntax


```

WaitExten([seconds,[options]])
```
##### Arguments


* `seconds` - Can be passed with fractions of a second. For example, '1.5' will ask the application to wait for 1.5 seconds.<br>

* `options`

    * `m(x)` - Provide music on hold to the caller while waiting for an extension.<br>

        * `x` - Specify the class for music on hold. *CHANNEL(musicclass) will be used instead if set*<br>


### See Also

* [Dialplan Applications BackGround](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/BackGround)
* [Dialplan Functions TIMEOUT](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/TIMEOUT)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 