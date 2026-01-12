---
search:
  boost: 0.5
title: MixMonitorMute
---

# MixMonitorMute

### Synopsis

Mute / unMute a Mixmonitor recording.

### Description

This action may be used to mute a MixMonitor recording.<br>


### Syntax


```


Action: MixMonitorMute
ActionID: <value>
Channel: <value>
Direction: <value>
State: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Channel` - Used to specify the channel to mute.<br>

* `Direction` - Which part of the recording to mute: read, write or both (from channel, to channel or both channels).<br>

* `State` - Turn mute on or off : 1 to turn on, 0 to turn off.<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 