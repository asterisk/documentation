---
search:
  boost: 0.5
title: RECORD FILE
---

# RECORD FILE

### Synopsis

Records to a given file.

### Description

Record to a file until a given dtmf digit in the sequence is received. Returns '-1' on hangup or error. The format will specify what kind of file will be recorded. The _timeout_ is the maximum record time in milliseconds, or '-1' for no _timeout_. _offset samples_ is optional, and, if provided, will seek to the offset without exceeding the end of the file. _beep_ can take any value, and causes Asterisk to play a beep to the channel that is about to be recorded. _silence_ is the number of seconds of silence allowed before the function returns despite the lack of dtmf digits or reaching _timeout_. _silence_ value must be preceded by 's=' and is also optional.<br>


### Syntax


```

RECORD FILE FILENAME FORMAT ESCAPE_DIGITS TIMEOUT OFFSET_SAMPLES BEEP S=SILENCE 
```
##### Arguments


* `filename` - The destination filename of the recorded audio.<br>

* `format` - The audio format in which to save the resulting file.<br>

* `escape_digits` - The DTMF digits that will terminate the recording process.<br>

* `timeout` - The maximum recording time in milliseconds. Set to -1 for no limit.<br>

* `offset_samples` - Causes the recording to first seek to the specified offset before recording begins.<br>

* `beep` - Causes Asterisk to play a beep as recording begins. This argument can take any value.<br>

* `s=silence` - The number of seconds of silence that are permitted before the recording is terminated, regardless of the _escape\_digits_ or _timeout_ arguments. If specified, this parameter must be preceded by 's='.<br>

### See Also

* [Dialplan Applications AGI](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/AGI)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 