---
search:
  boost: 0.5
title: JITTERBUFFER
---

# JITTERBUFFER()

### Synopsis

Add a Jitterbuffer to the Read side of the channel. This dejitters the audio stream before it reaches the Asterisk core. This is a write only function.

### Description

Jitterbuffers are constructed in two different ways. The first always take four arguments: _max\_size_, _resync\_threshold_, _target\_extra_, and _sync\_video_. Alternatively, a single argument of 'default' can be provided, which will construct the default jitterbuffer for the given _jitterbuffer type_.<br>

The arguments are:<br>

max_size: Length in milliseconds of the buffer. Defaults to 200 ms.<br>

resync_threshold: The length in milliseconds over which a timestamp difference will result in resyncing the jitterbuffer. Defaults to 1000ms.<br>

target\_extra: This option only affects the adaptive jitterbuffer. It represents the amount time in milliseconds by which the new jitter buffer will pad its size. Defaults to 40ms.<br>

sync\_video: This option enables video synchronization with the audio stream. It can be turned on and off. Defaults to off.<br>

``` title="Example: Fixed with defaults"

exten => 1,1,Set(JITTERBUFFER(fixed)=default)


```
``` title="Example: Fixed with 200ms max size"

exten => 1,1,Set(JITTERBUFFER(fixed)=200)


```
``` title="Example: Fixed with 200ms max size and video sync support"

exten => 1,1,Set(JITTERBUFFER(fixed)=200,,,yes)


```
``` title="Example: Fixed with 200ms max size, resync threshold 1500"

exten => 1,1,Set(JITTERBUFFER(fixed)=200,1500)


```
``` title="Example: Adaptive with defaults"

exten => 1,1,Set(JITTERBUFFER(adaptive)=default)


```
``` title="Example: Adaptive with 200ms max size, 60ms target extra"

exten => 1,1,Set(JITTERBUFFER(adaptive)=200,,60)


```
``` title="Example: Adaptive with 200ms max size and video sync support"

exten => 1,1,Set(JITTERBUFFER(adaptive)=200,,,yes)


```
``` title="Example: Set a fixed jitterbuffer with defaults; then remove it"

exten => 1,1,Set(JITTERBUFFER(fixed)=default)
exten => 1,n,Set(JITTERBUFFER(disabled)=)


```

/// note
If a channel specifies a jitterbuffer due to channel driver configuration and the JITTERBUFFER function has set a jitterbuffer for that channel, the jitterbuffer set by the JITTERBUFFER function will take priority and the jitterbuffer set by the channel configuration will not be applied.
///


### Syntax


```

JITTERBUFFER(jitterbuffer type)
```
##### Arguments


* `jitterbuffer type`

    * `fixed` - Set a fixed jitterbuffer on the channel.<br>


    * `adaptive` - Set an adaptive jitterbuffer on the channel.<br>


    * `disabled` - Remove a previously set jitterbuffer from the channel.<br>



### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 