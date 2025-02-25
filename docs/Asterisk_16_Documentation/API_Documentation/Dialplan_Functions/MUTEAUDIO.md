---
search:
  boost: 0.5
title: MUTEAUDIO
---

# MUTEAUDIO()

### Synopsis

Muting audio streams in the channel

### Description

The MUTEAUDIO function can be used to mute inbound (to the PBX) or outbound audio in a call.<br>

``` title="Example: Mute incoming audio"

exten => s,1,Set(MUTEAUDIO(in)=on)


```
``` title="Example: Do not mute incoming audio"

exten => s,1,Set(MUTEAUDIO(in)=off)


```

### Syntax


```

MUTEAUDIO(direction)
```
##### Arguments


* `direction` - Must be one of<br>

    * `in` - Inbound stream (to the PBX)<br>

    * `out` - Outbound stream (from the PBX)<br>

    * `all` - Both streams<br>


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 