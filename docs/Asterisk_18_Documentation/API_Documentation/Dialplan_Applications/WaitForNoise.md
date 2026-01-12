---
search:
  boost: 0.5
title: WaitForNoise
---

# WaitForNoise()

### Synopsis

Waits for a specified amount of noise.

### Description

Waits for up to _noiserequired_ milliseconds of noise, _iterations_ times. An optional _timeout_ specified the number of seconds to return after, even if we do not receive the specified amount of noise. Use _timeout_ with caution, as it may defeat the purpose of this application, which is to wait indefinitely until noise is detected on the line.<br>


### Syntax


```

WaitForNoise([noiserequired,[iterations,[timeout]]])
```
##### Arguments


* `noiserequired` - If not specified, defaults to '1000' milliseconds.<br>

* `iterations` - If not specified, defaults to '1'.<br>

* `timeout` - Is specified only to avoid an infinite loop in cases where silence is never achieved.<br>

### See Also

* [Dialplan Applications WaitForSilence](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/WaitForSilence)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 