---
search:
  boost: 0.5
title: TONE_DETECT
---

# TONE_DETECT()

### Synopsis

Asynchronously detects a tone

### Since

16.21.0, 18.7.0, 19.0.0

### Description

The TONE\_DETECT function detects a single-frequency tone and keeps track of how many times the tone has been detected.<br>

When reading this function (instead of writing), supply 'tx' to get the number of times a tone has been detected in the TX direction and 'rx' to get the number of times a tone has been detected in the RX direction.<br>

``` title="Example: intercept2600"

same => n,Set(TONE_DETECT(2600,1000,g(got-2600,s,1))=) ; detect 2600 Hz
same => n,Wait(15)
same => n,NoOp(${TONE_DETECT(rx)})


```
``` title="Example: dropondialtone"

same => n,Set(TONE_DETECT(0,,bg(my-hangup,s,1))=) ; disconnect a call if we hear a busy signal
same => n,Goto(somewhere-else)
same => n(myhangup),Hangup()


```
``` title="Example: removedetector"

same => n,Set(TONE_DETECT(0,,x)=) ; remove the detector from the channel


```

### Syntax


```

TONE_DETECT(freq[,duration_ms,options])
```
##### Arguments


* `freq` - Frequency of the tone to detect. To disable frequency detection completely (e.g. for signal detection only), specify 0 for the frequency.<br>

* `duration_ms` - Minimum duration of tone, in ms. Default is 500ms. Using a minimum duration under 50ms is unlikely to produce accurate results.<br>

* `options`

    * `a` - Match immediately on Special Information Tones, instead of or in addition to a particular frequency.<br>


    * `b` - Match immediately on a busy signal, instead of or in addition to a particular frequency.<br>


    * `c` - Match immediately on a dial tone, instead of or in addition to a particular frequency.<br>


    * `d` - Custom decibel threshold to use. Default is 16.<br>


    * `g` - Go to the specified context,exten,priority if tone is received on this channel. Detection will not end automatically.<br>


    * `h` - Go to the specified context,exten,priority if tone is transmitted on this channel. Detection will not end automatically.<br>


    * `n` - Number of times the tone should be detected (subject to the provided timeout) before going to the destination provided in the 'g' or 'h' option. Default is 1.<br>


    * `p` - Match immediately on audible ringback tone, instead of or in addition to a particular frequency.<br>


    * `r` - Apply to received frames only. Default is both directions.<br>


    * `s` - Squelch tone.<br>


    * `t` - Apply to transmitted frames only. Default is both directions.<br>


    * `x` - Destroy the detector (stop detection).<br>



### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 