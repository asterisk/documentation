---
search:
  boost: 0.5
title: RetryDial
---

# RetryDial()

### Synopsis

Place a call, retrying on failure allowing an optional exit extension.

### Description

This application will attempt to place a call using the normal Dial application. If no channel can be reached, the _announce_ file will be played. Then, it will wait _sleep_ number of seconds before retrying the call. After _retries_ number of attempts, the calling channel will continue at the next priority in the dialplan. If the _retries_ setting is set to 0, this application will retry endlessly. While waiting to retry a call, a 1 digit extension may be dialed. If that extension exists in either the context defined in **EXITCONTEXT** or the current one, The call will jump to that extension immediately. The _dialargs_ are specified in the same format that arguments are provided to the Dial application.<br>


### Syntax


```

RetryDial(announce,sleep,retries,dialargs)
```
##### Arguments


* `announce` - Filename of sound that will be played when no channel can be reached<br>

* `sleep` - Number of seconds to wait after a dial attempt failed before a new attempt is made<br>

* `retries` - Number of retries<br>
When this is reached flow will continue at the next priority in the dialplan<br>

* `dialargs` - Same format as arguments provided to the Dial application<br>

### See Also

* [Dialplan Applications Dial](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/Dial)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 