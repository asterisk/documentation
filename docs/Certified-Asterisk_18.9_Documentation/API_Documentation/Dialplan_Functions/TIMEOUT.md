---
search:
  boost: 0.5
title: TIMEOUT
---

# TIMEOUT()

### Synopsis

Gets or sets timeouts on the channel. Timeout values are in seconds.

### Description

The timeouts that can be manipulated are:<br>

absolute: The absolute maximum amount of time permitted for a call. Setting of 0 disables the timeout.<br>

digit: The maximum amount of time permitted between digits when the user is typing in an extension. When this timeout expires, after the user has started to type in an extension, the extension will be considered complete, and will be interpreted. Note that if an extension typed in is valid, it will not have to timeout to be tested, so typically at the expiry of this timeout, the extension will be considered invalid (and thus control would be passed to the i extension, or if it doesn't exist the call would be terminated). The default timeout is 5 seconds.<br>

response: The maximum amount of time permitted after falling through a series of priorities for a channel in which the user may begin typing an extension. If the user does not type an extension in this amount of time, control will pass to the t extension if it exists, and if not the call would be terminated. The default timeout is 10 seconds.<br>


### Syntax


```

TIMEOUT(timeouttype)
```
##### Arguments


* `timeouttype` - The timeout that will be manipulated. The possible timeout types are: 'absolute', 'digit' or 'response'<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 