---
search:
  boost: 0.5
title: StopMixMonitor
---

# StopMixMonitor()

### Synopsis

Stop recording a call through MixMonitor, and free the recording's file handle.

### Description

Stops the audio recording that was started with a call to 'MixMonitor()' on the current channel.<br>


### Syntax


```

StopMixMonitor([MixMonitorID])
```
##### Arguments


* `MixMonitorID` - If a valid ID is provided, then this command will stop only that specific MixMonitor.<br>

### See Also

* [Dialplan Applications MixMonitor](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/MixMonitor)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 