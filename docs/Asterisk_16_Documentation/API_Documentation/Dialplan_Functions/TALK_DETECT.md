---
search:
  boost: 0.5
title: TALK_DETECT
---

# TALK_DETECT()

### Synopsis

Raises notifications when Asterisk detects silence or talking on a channel.

### Since

12.4.0

### Description

The TALK\_DETECT function enables events on the channel it is applied to. These events can be emitted over AMI, ARI, and potentially other Asterisk modules that listen for the internal notification.<br>

The function has two parameters that can optionally be passed when 'set' on a channel: _dsp\_talking\_threshold_ and _dsp\_silence\_threshold_.<br>

dsp_talking_threshold is the time in milliseconds of sound above what the dsp has established as base line silence for a user before a user is considered to be talking. By default, the value of silencethreshold from dsp.conf is used. If this value is set too tight events may be falsely triggered by variants in room noise.<br>

Valid values are 1 through 2\^31.<br>

dsp_silence_threshold is the time in milliseconds of sound falling within what the dsp has established as baseline silence before a user is considered be silent. If this value is set too low events indicating the user has stopped talking may get falsely sent out when the user briefly pauses during mid sentence.<br>

The best way to approach this option is to set it slightly above the maximum amount of ms of silence a user may generate during natural speech.<br>

By default this value is 2500ms. Valid values are 1 through 2\^31.<br>

``` title="Example: Enable talk detection"

same => n,Set(TALK_DETECT(set)=)


```
``` title="Example: Update existing talk detection's silence threshold to 1200 ms"

same => n,Set(TALK_DETECT(set)=1200)


```
``` title="Example: Remove talk detection"

same => n,Set(TALK_DETECT(remove)=)


```
``` title="Example: Enable and set talk threshold to 128"

same => n,Set(TALK_DETECT(set)=,128)


```
This function will set the following variables:<br>


/// note
The TALK\_DETECT function uses an audiohook to inspect the voice media frames on a channel. Other functions, such as JITTERBUFFER, DENOISE, and AGC use a similar mechanism. Audiohooks are processed in the order in which they are placed on the channel. As such, it typically makes sense to place functions that modify the voice media data prior to placing the TALK\_DETECT function, as this will yield better results.
///

``` title="Example: Denoise and then perform talk detection"

same => n,Set(DENOISE(rx)=on)    ; Denoise received audio
same => n,Set(TALK_DETECT(set)=) ; Perform talk detection on the denoised received audio


```

### Syntax


```

TALK_DETECT(action)
```
##### Arguments


* `action`

    * `remove` - W/O. Remove talk detection from the channel.<br>


    * `set(dsp_silence_threshold,dsp_talking_threshold)` - W/O. Enable TALK\_DETECT and/or configure talk detection parameters. Can be called multiple times to change parameters on a channel with talk detection already enabled.<br>

        * `dsp_silence_threshold` - The time in milliseconds of sound falling below the _dsp\_talking\_threshold_ option when a user is considered to stop talking. The default value is 2500.<br>

        * `dsp_talking_threshold` - The minimum average magnitude per sample in a frame for the DSP to consider talking/noise present. A value below this level is considered silence. If not specified, the value comes from the *dsp.conf* _silencethreshold_ option or 256 if *dsp.conf* doesn't exist or the _silencethreshold_ option is not set.<br>



### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 