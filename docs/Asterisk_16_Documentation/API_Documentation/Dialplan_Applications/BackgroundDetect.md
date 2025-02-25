---
search:
  boost: 0.5
title: BackgroundDetect
---

# BackgroundDetect()

### Synopsis

Background a file with talk detect.

### Description

Plays back _filename_, waiting for interruption from a given digit (the digit must start the beginning of a valid extension, or it will be ignored). During the playback of the file, audio is monitored in the receive direction, and if a period of non-silence which is greater than _min_ ms yet less than _max_ ms is followed by silence for at least _sil_ ms, which occurs during the first _analysistime_ ms, then the audio playback is aborted and processing jumps to the _talk_ extension, if available.<br>


### Syntax


```

BackgroundDetect(filename,[sil,[min,[max,[analysistime]]]])
```
##### Arguments


* `filename`

* `sil` - If not specified, defaults to '1000'.<br>

* `min` - If not specified, defaults to '100'.<br>

* `max` - If not specified, defaults to 'infinity'.<br>

* `analysistime` - If not specified, defaults to 'infinity'.<br>


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 