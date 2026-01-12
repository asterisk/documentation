---
search:
  boost: 0.5
title: VERSION
---

# VERSION()

### Synopsis

Return the Version info for this Asterisk.

### Description

If there are no arguments, return the version of Asterisk in this format: SVN-branch-1.4-r44830M<br>

Example: Set(junky=$\{VERSION()\};<br>

Sets junky to the string 'SVN-branch-1.6-r74830M', or possibly, 'SVN-trunk-r45126M'.<br>


### Syntax


```

VERSION(info)
```
##### Arguments


* `info` - The possible values are:<br>

    * `ASTERISK_VERSION_NUM` - A string of digits is returned, e.g. 10602 for 1.6.2 or 100300 for 10.3.0, or 999999 when using an SVN build.<br>

    * `BUILD_USER` - The string representing the user's name whose account was used to configure Asterisk, is returned.<br>

    * `BUILD_HOSTNAME` - The string representing the name of the host on which Asterisk was configured, is returned.<br>

    * `BUILD_MACHINE` - The string representing the type of machine on which Asterisk was configured, is returned.<br>

    * `BUILD_OS` - The string representing the OS of the machine on which Asterisk was configured, is returned.<br>

    * `BUILD_DATE` - The string representing the date on which Asterisk was configured, is returned.<br>

    * `BUILD_KERNEL` - The string representing the kernel version of the machine on which Asterisk was configured, is returned.<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 