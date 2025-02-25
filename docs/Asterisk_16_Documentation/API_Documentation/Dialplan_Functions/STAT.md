---
search:
  boost: 0.5
title: STAT
---

# STAT()

### Synopsis

Does a check on the specified file.

### Description


/// note
If 'live\_dangerously' in 'asterisk.conf' is set to 'no', this function can only be executed from the dialplan, and not directly from external protocols.
///


### Syntax


```

STAT(flag,filename)
```
##### Arguments


* `flag` - Flag may be one of the following:<br>
d - Checks if the file is a directory.<br>
e - Checks if the file exists.<br>
f - Checks if the file is a regular file.<br>
m - Returns the file mode (in octal)<br>
s - Returns the size (in bytes) of the file<br>
A - Returns the epoch at which the file was last accessed.<br>
C - Returns the epoch at which the inode was last changed.<br>
M - Returns the epoch at which the file was last modified.<br>

* `filename`


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 