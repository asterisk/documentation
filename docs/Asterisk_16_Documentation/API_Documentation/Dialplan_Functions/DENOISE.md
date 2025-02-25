---
search:
  boost: 0.5
title: DENOISE
---

# DENOISE()

### Synopsis

Apply noise reduction to audio on a channel.

### Description

The DENOISE function will apply noise reduction to audio on the channel that it is executed on. It is very useful for noisy analog lines, especially when adjusting gains or using AGC. Use 'rx' for audio received from the channel and 'tx' to apply the filter to the audio being sent to the channel.<br>

``` title="Example: Apply noise reduction"

exten => 1,1,Set(DENOISE(rx)=on)
exten => 1,2,Set(DENOISE(tx)=off)


```

### Syntax


```

DENOISE(channeldirection)
```
##### Arguments


* `channeldirection` - This can be either 'rx' or 'tx' the values that can be set to this are either 'on' and 'off'<br>


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 