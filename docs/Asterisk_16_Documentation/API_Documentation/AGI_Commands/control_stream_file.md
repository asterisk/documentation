---
search:
  boost: 0.5
title: CONTROL STREAM FILE
---

# CONTROL STREAM FILE

### Synopsis

Sends audio file on channel and allows the listener to control the stream.

### Description

Send the given file, allowing playback to be controlled by the given digits, if any. Use double quotes for the digits if you wish none to be permitted. If offsetms is provided then the audio will seek to offsetms before play starts. Returns '0' if playback completes without a digit being pressed, or the ASCII numerical value of the digit if one was pressed, or '-1' on error or if the channel was disconnected. Returns the position where playback was terminated as endpos.<br>

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

CONTROL STREAM FILE FILENAME ESCAPE_DIGITS SKIPMS FFCHAR REWCHR PAUSECHR OFFSETMS 
```
##### Arguments


* `filename` - The file extension must not be included in the filename.<br>

* `escape_digits`

* `skipms`

* `ffchar` - Defaults to '#'<br>

* `rewchr` - Defaults to '*'<br>

* `pausechr`

* `offsetms` - Offset, in milliseconds, to start the audio playback<br>

### See Also

* [AGI Commands get_option](/Asterisk_16_Documentation/API_Documentation/AGI_Commands/get_option)
* [AGI Commands control_stream_file](/Asterisk_16_Documentation/API_Documentation/AGI_Commands/control_stream_file)
* [Dialplan Applications AGI](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/AGI)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 