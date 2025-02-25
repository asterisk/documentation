---
search:
  boost: 0.5
title: Read
---

# Read()

### Synopsis

Read a variable.

### Description

Reads a #-terminated string of digits a certain number of times from the user in to the given _variable_.<br>

This application sets the following channel variable upon completion:<br>


* `READSTATUS` - This is the status of the read operation.<br>

    * `OK`

    * `ERROR`

    * `HANGUP`

    * `INTERRUPTED`

    * `SKIPPED`

    * `TIMEOUT`

### Syntax


```

Read(variable,filename&[filename2[&...]],[maxdigits,[options,[attempts,[timeout]]]]])
```
##### Arguments


* `variable` - The input digits will be stored in the given _variable_ name.<br>

* `filenames`

    * `filename` **required** - file(s) to play before reading digits or tone with option i<br>

    * `filename2[,filename2...]`

* `maxdigits` - Maximum acceptable number of digits. Stops reading after _maxdigits_ have been entered (without requiring the user to press the '#' key).<br>
Defaults to '0' - no limit - wait for the user press the '#' key. Any value below '0' means the same. Max accepted value is '255'.<br>

* `options`

    * `s` - to return immediately if the line is not up.<br>


    * `i` - to play filename as an indication tone from your *indications.conf*.<br>


    * `n` - to read digits even if the line is not up.<br>


    * `t` - Terminator digit(s) to use for ending input. Default is '#'. If you need to read the digit '#' literally, you should remove or change the terminator character. Multiple terminator characters may be specified. If no terminator digit is present, input cannot be ended using digits and you will need to rely on duration and max digits for ending input.<br>


* `attempts` - If greater than '1', that many _attempts_ will be made in the event no data is entered.<br>

* `timeout` - The number of seconds to wait for a digit response. If greater than '0', that value will override the default timeout. Can be floating point.<br>

### See Also

* [Dialplan Applications SendDTMF](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/SendDTMF)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 