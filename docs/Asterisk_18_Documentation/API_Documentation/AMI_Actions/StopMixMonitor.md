---
search:
  boost: 0.5
title: StopMixMonitor
---

# StopMixMonitor

### Synopsis

Stop recording a call through MixMonitor, and free the recording's file handle.

### Description

This action stops the audio recording that was started with the 'MixMonitor' action on the current channel.<br>


### Syntax


```


Action: StopMixMonitor
ActionID: <value>
Channel: <value>
[MixMonitorID: <value>]

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Channel` - The name of the channel monitored.<br>

* `MixMonitorID` - If a valid ID is provided, then this command will stop only that specific MixMonitor.<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 