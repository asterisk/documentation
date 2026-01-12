---
search:
  boost: 0.5
title: STREAM FILE
---

# STREAM FILE

### Synopsis

Sends audio file on channel.

### Description

Send the given file, allowing playback to be interrupted by the given digits, if any. Returns '0' if playback completes without a digit being pressed, or the ASCII numerical value of the digit if one was pressed, or '-1' on error or if the channel was disconnected. If musiconhold is playing before calling stream file it will be automatically stopped and will not be restarted after completion.<br>

It sets the following channel variables upon completion:<br>


* `PLAYBACKSTATUS` - The status of the playback attempt as a text string.<br>

    * `SUCCESS`

    * `FAILED`

### Syntax


```

STREAM FILE FILENAME ESCAPE_DIGITS SAMPLE OFFSET 
```
##### Arguments


* `filename` - File name to play. The file extension must not be included in the _filename_.<br>

* `escape_digits` - Use double quotes for the digits if you wish none to be permitted.<br>

* `sample offset` - If sample offset is provided then the audio will seek to sample offset before play starts.<br>

### See Also

* [AGI Commands control_stream_file](/Certified-Asterisk_18.9_Documentation/API_Documentation/AGI_Commands/control_stream_file)
* [AGI Commands get_option](/Certified-Asterisk_18.9_Documentation/API_Documentation/AGI_Commands/get_option)
* [Dialplan Applications AGI](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/AGI)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 