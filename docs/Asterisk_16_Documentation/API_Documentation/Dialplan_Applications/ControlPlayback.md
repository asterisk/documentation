---
search:
  boost: 0.5
title: ControlPlayback
---

# ControlPlayback()

### Synopsis

Play a file with fast forward and rewind.

### Description

This application will play back the given _filename_.<br>

It sets the following channel variables upon completion:<br>


* `CPLAYBACKSTATUS` - Contains the status of the attempt as a text string<br>

    * `SUCCESS`

    * `USERSTOPPED`

    * `REMOTESTOPPED`

    * `ERROR`

* `CPLAYBACKOFFSET` - Contains the offset in ms into the file where playback was at when it stopped. '-1' is end of file.<br>

* `CPLAYBACKSTOPKEY` - If the playback is stopped by the user this variable contains the key that was pressed.<br>

### Syntax


```

ControlPlayback(filename,[skipms,[ff,[rew,[stop,[pause,[restart,[options]]]]]]])
```
##### Arguments


* `filename`

* `skipms` - This is number of milliseconds to skip when rewinding or fast-forwarding.<br>

* `ff` - Fast-forward when this DTMF digit is received. (defaults to '#')<br>

* `rew` - Rewind when this DTMF digit is received. (defaults to '*')<br>

* `stop` - Stop playback when this DTMF digit is received.<br>

* `pause` - Pause playback when this DTMF digit is received.<br>

* `restart` - Restart playback when this DTMF digit is received.<br>

* `options`

    * `o(time)`

        * `time` **required** - Start at _time_ ms from the beginning of the file.<br>



### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 