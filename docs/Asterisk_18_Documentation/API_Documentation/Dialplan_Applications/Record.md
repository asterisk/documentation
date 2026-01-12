---
search:
  boost: 0.5
title: Record
---

# Record()

### Synopsis

Record to a file.

### Description

If filename contains '%d', these characters will be replaced with a number incremented by one each time the file is recorded. Use `core show file formats` to see the available formats on your system User can press '#' to terminate the recording and continue to the next priority. If the user hangs up during a recording, all data will be lost and the application will terminate.<br>


* `RECORDED_FILE` - Will be set to the final filename of the recording, without an extension.<br>

* `RECORD_STATUS` - This is the final status of the command<br>

    * `DTMF` - A terminating DTMF was received ('#' or '*', depending upon option 't')

    * `SILENCE` - The maximum silence occurred in the recording.

    * `SKIP` - The line was not yet answered and the 's' option was specified.

    * `TIMEOUT` - The maximum length was reached.

    * `HANGUP` - The channel was hung up.

    * `ERROR` - An unrecoverable error occurred, which resulted in a WARNING to the logs.

### Syntax


```

Record(filename.format,[silence,[maxduration,[options]]])
```
##### Arguments


* `filename`

    * `filename` **required**

    * `format` **required** - Is the format of the file type to be recorded (wav, gsm, etc).<br>

* `silence` - Is the number of seconds of silence to allow before returning.<br>

* `maxduration` - Is the maximum recording duration in seconds. If missing or 0 there is no maximum.<br>

* `options`

    * `a` - Append to existing recording rather than replacing.<br>


    * `n` - Do not answer, but record anyway if line not yet answered.<br>


    * `o` - Exit when 0 is pressed, setting the variable **RECORD\_STATUS** to 'OPERATOR' instead of 'DTMF'<br>


    * `q` - quiet (do not play a beep tone).<br>


    * `s` - skip recording if the line is not yet answered.<br>


    * `t` - use alternate '*' terminator key (DTMF) instead of default '#'<br>


    * `u` - Don't truncate recorded silence.<br>


    * `x` - Ignore all terminator keys (DTMF) and keep recording until hangup.<br>


    * `k` - Keep recorded file upon hangup.<br>


    * `y` - Terminate recording if *any* DTMF digit is received.<br>



### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 