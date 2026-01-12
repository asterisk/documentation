---
search:
  boost: 0.5
title: Monitor
---

# Monitor()

### Synopsis

Monitor a channel.

### Description

Used to start monitoring a channel. The channel's input and output voice packets are logged to files until the channel hangs up or monitoring is stopped by the StopMonitor application.<br>

By default, files are stored to */var/spool/asterisk/monitor/*. Returns '-1' if monitor files can't be opened or if the channel is already monitored, otherwise '0'.<br>


### Syntax


```

Monitor(file_format:[urlbase],[fname_base,[options]]])
```
##### Arguments


* `file_format`

    * `file_format` **required** - Optional. If not set, defaults to 'wav'<br>

    * `urlbase`

* `fname_base` - If set, changes the filename used to the one specified.<br>

* `options`

    * `m` - When the recording ends mix the two leg files into one and delete the two leg files. If the variable **MONITOR\_EXEC** is set, the application referenced in it will be executed instead of soxmix/sox and the raw leg files will NOT be deleted automatically. soxmix/sox or **MONITOR\_EXEC** is handed 3 arguments, the two leg files and a target mixed file name which is the same as the leg file names only without the in/out designator.<br>
If **MONITOR\_EXEC\_ARGS** is set, the contents will be passed on as additional arguments to **MONITOR\_EXEC**. Both **MONITOR\_EXEC** and the Mix flag can be set from the administrator interface.<br>


    * `b` - Don't begin recording unless a call is bridged to another channel.<br>


    * `B(interval)` - Play a periodic beep while this call is being recorded.<br>

        * `interval` - Interval, in seconds. Default is 15.<br>


    * `i` - Skip recording of input stream (disables 'm' option).<br>


    * `o` - Skip recording of output stream (disables 'm' option).<br>


### See Also

* [Dialplan Applications StopMonitor](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/StopMonitor)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 