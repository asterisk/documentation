---
search:
  boost: 0.5
title: WaitForSilence
---

# WaitForSilence()

### Synopsis

Waits for a specified amount of silence.

### Description

Waits for up to _silencerequired_ milliseconds of silence, _iterations_ times. An optional _timeout_ specified the number of seconds to return after, even if we do not receive the specified amount of silence. Use _timeout_ with caution, as it may defeat the purpose of this application, which is to wait indefinitely until silence is detected on the line. This is particularly useful for reverse-911-type call broadcast applications where you need to wait for an answering machine to complete its spiel before playing a message.<br>

Typically you will want to include two or more calls to WaitForSilence when dealing with an answering machine; first waiting for the spiel to finish, then waiting for the beep, etc.<br>

``` title="Example: Wait for half a second of silence, twice"

same => n,WaitForSilence(500,2)


```
``` title="Example: Wait for one second of silence, once"

same => n,WaitForSilence(1000)


```
``` title="Example: Wait for 300 ms of silence, 3 times, and returns after 10 seconds, even if no silence detected"

same => n,WaitForSilence(300,3,10)


```
Sets the channel variable **WAITSTATUS** to one of these values:<br>


* `WAITSTATUS`

    * `SILENCE` - if exited with silence detected.

    * `TIMEOUT` - if exited without silence detected after timeout.

### Syntax


```

WaitForSilence([silencerequired,[iterations,[timeout]]])
```
##### Arguments


* `silencerequired` - If not specified, defaults to '1000' milliseconds.<br>

* `iterations` - If not specified, defaults to '1'.<br>

* `timeout` - Is specified only to avoid an infinite loop in cases where silence is never achieved.<br>

### See Also

* [Dialplan Applications WaitForNoise](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/WaitForNoise)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 