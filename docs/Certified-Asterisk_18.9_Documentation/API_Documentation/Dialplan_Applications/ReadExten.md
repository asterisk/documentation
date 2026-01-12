---
search:
  boost: 0.5
title: ReadExten
---

# ReadExten()

### Synopsis

Read an extension into a variable.

### Description

Reads a '#' terminated string of digits from the user into the given variable.<br>

Will set READEXTENSTATUS on exit with one of the following statuses:<br>


* `READEXTENSTATUS`

    * `OK` - A valid extension exists in $\{variable\}.

    * `TIMEOUT` - No extension was entered in the specified time. Also sets $\{variable\} to "t".

    * `INVALID` - An invalid extension, $\{INVALID\_EXTEN\}, was entered. Also sets $\{variable\} to "i".

    * `SKIP` - Line was not up and the option 's' was specified.

    * `ERROR` - Invalid arguments were passed.

### Syntax


```

ReadExten(variable,[filename,[context,[option,[timeout]]]])
```
##### Arguments


* `variable`

* `filename` - File to play before reading digits or tone with option 'i'<br>

* `context` - Context in which to match extensions.<br>

* `option`

    * `s` - Return immediately if the channel is not answered.<br>


    * `i` - Play _filename_ as an indication tone from your *indications.conf* or a directly specified list of frequencies and durations.<br>


    * `n` - Read digits even if the channel is not answered.<br>


    * `p` - The extension entered will be considered complete when a '#' is entered.<br>


* `timeout` - An integer number of seconds to wait for a digit response. If greater than '0', that value will override the default timeout.<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 