---
search:
  boost: 0.5
title: MuteAudio
---

# MuteAudio

### Synopsis

Mute an audio stream.

### Description

Mute an incoming or outgoing audio stream on a channel.<br>


### Syntax


```


Action: MuteAudio
ActionID: <value>
Channel: <value>
Direction: <value>
State: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Channel` - The channel you want to mute.<br>

* `Direction`

    * `in` - Set muting on inbound audio stream. (to the PBX)<br>

    * `out` - Set muting on outbound audio stream. (from the PBX)<br>

    * `all` - Set muting on inbound and outbound audio streams.<br>

* `State`

    * `on` - Turn muting on.<br>

    * `off` - Turn muting off.<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 