---
search:
  boost: 0.5
title: FILE_COUNT_LINE
---

# FILE_COUNT_LINE()

### Synopsis

Obtains the number of lines of a text file.

### Description

Returns the number of lines, or '-1' on error.<br>


/// note
If 'live\_dangerously' in 'asterisk.conf' is set to 'no', this function can only be executed from the dialplan, and not directly from external protocols.
///


### Syntax


```

FILE_COUNT_LINE(filename,format)
```
##### Arguments


* `filename`

* `format` - Format may be one of the following:<br>

    * `u` - Unix newline format.<br>


    * `d` - DOS newline format.<br>


    * `m` - Macintosh newline format.<br>


    /// note
If not specified, an attempt will be made to determine the newline format type.
///


### See Also

* [Dialplan Functions FILE](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/FILE)
* [Dialplan Functions FILE_FORMAT](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/FILE_FORMAT)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 