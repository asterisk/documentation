---
search:
  boost: 0.5
title: AGC
---

# AGC()

### Synopsis

Apply automatic gain control to audio on a channel.

### Description

The AGC function will apply automatic gain control to the audio on the channel that it is executed on. Using 'rx' for audio received and 'tx' for audio transmitted to the channel. When using this function you set a target audio level. It is primarily intended for use with analog lines, but could be useful for other channels as well. The target volume is set with a number between '1-32768'. The larger the number the louder (more gain) the channel will receive.<br>

``` title="Example: Apply automatic gain control"

exten => 1,1,Set(AGC(rx)=8000)
exten => 1,2,Set(AGC(tx)=off)


```

### Syntax


```

AGC(channeldirection)
```
##### Arguments


* `channeldirection` - This can be either 'rx' or 'tx'<br>


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 