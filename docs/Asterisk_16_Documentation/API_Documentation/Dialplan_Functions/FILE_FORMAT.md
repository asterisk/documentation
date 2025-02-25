---
search:
  boost: 0.5
title: FILE_FORMAT
---

# FILE_FORMAT()

### Synopsis

Return the newline format of a text file.

### Description

Return the line terminator type:<br>

'u' - Unix "\n" format<br>

'd' - DOS "\r\n" format<br>

'm' - Macintosh "\r" format<br>

'x' - Cannot be determined<br>


/// note
If 'live\_dangerously' in 'asterisk.conf' is set to 'no', this function can only be executed from the dialplan, and not directly from external protocols.
///


### Syntax


```

FILE_FORMAT(filename)
```
##### Arguments


* `filename`

### See Also

* [Dialplan Functions FILE](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/FILE)
* [Dialplan Functions FILE_COUNT_LINE](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/FILE_COUNT_LINE)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 