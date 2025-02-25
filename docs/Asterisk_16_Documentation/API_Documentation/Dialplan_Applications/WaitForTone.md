---
search:
  boost: 0.5
title: WaitForTone
---

# WaitForTone()

### Synopsis

Wait for tone

### Since

16.21.0, 18.7.0, 19.0.0

### Description

Waits for a single-frequency tone to be detected before dialplan execution continues.<br>


* `WAITFORTONESTATUS` - This indicates the result of the wait.<br>

    * `SUCCESS`

    * `ERROR`

    * `TIMEOUT`

    * `HANGUP`

### Syntax


```

WaitForTone(freq,[duration_ms,[timeout,[times,[options]]]])
```
##### Arguments


* `freq` - Frequency of the tone to wait for.<br>

* `duration_ms` - Minimum duration of tone, in ms. Default is 500ms. Using a minimum duration under 50ms is unlikely to produce accurate results.<br>

* `timeout` - Maximum amount of time, in seconds, to wait for specified tone. Default is forever.<br>

* `times` - Number of times the tone should be detected (subject to the provided timeout) before returning. Default is 1.<br>

* `options`

    * `d` - Custom decibel threshold to use. Default is 16.<br>


    * `s` - Squelch tone.<br>


### See Also

* [Dialplan Applications PlayTones](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/PlayTones)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 