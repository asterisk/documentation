---
search:
  boost: 0.5
title: PrivacyManager
---

# PrivacyManager()

### Synopsis

Require phone number to be entered, if no CallerID sent

### Description

If no Caller*ID is sent, PrivacyManager answers the channel and asks the caller to enter their phone number. The caller is given _maxretries_ attempts to do so. The application does *nothing* if Caller*ID was received on the channel.<br>

The application sets the following channel variable upon completion:<br>


* `PRIVACYMGRSTATUS` - The status of the privacy manager's attempt to collect a phone number from the user.<br>

    * `SUCCESS`

    * `FAILED`

### Syntax


```

PrivacyManager([maxretries,[minlength,[options,[context]]]])
```
##### Arguments


* `maxretries` - Total tries caller is allowed to input a callerid. Defaults to '3'.<br>

* `minlength` - Minimum allowable digits in the input callerid number. Defaults to '10'.<br>

* `options` - Position reserved for options.<br>

* `context` - Context to check the given callerid against patterns.<br>

### See Also

* [Dialplan Applications Zapateller](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/Zapateller)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 