---
search:
  boost: 0.5
title: EAGI
---

# EAGI()

### Synopsis

Executes an EAGI compliant application.

### Description

Using 'EAGI' provides enhanced AGI, with incoming audio available out of band on file descriptor 3. In all other respects, it behaves in the same fashion as AGI. See the documentation for the 'AGI' dialplan application for more information on invoking AGI on a channel.<br>

This application sets the following channel variable upon completion:<br>


* `AGISTATUS` - The status of the attempt to the run the AGI script text string, one of:<br>

    * `SUCCESS`

    * `FAILURE`

    * `NOTFOUND`

    * `HANGUP`

### Syntax


```

EAGI(command,arg1,[arg2[,...]])
```
##### Arguments


* `command` - How AGI should be invoked on the channel.<br>

* `args` - Arguments to pass to the AGI script or server.<br>

    * `arg1` **required**

    * `arg2[,arg2...]`

### See Also

* [Dialplan Applications AGI](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/AGI)
* [Dialplan Applications DeadAGI](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/DeadAGI)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 