---
search:
  boost: 0.5
title: DeadAGI
---

# DeadAGI()

### Synopsis

Executes AGI on a hungup channel.

### Description


/// warning
This application is deprecated and may be removed in a future version of Asterisk. Use the replacement application 'AGI' instead of 'DeadAGI'.
///

Execute AGI on a 'dead' or hungup channel. See the documentation for the 'AGI' dialplan application for more information on invoking AGI on a channel.<br>

This application sets the following channel variable upon completion:<br>


* `AGISTATUS` - The status of the attempt to the run the AGI script text string, one of:<br>

    * `SUCCESS`

    * `FAILURE`

    * `NOTFOUND`

    * `HANGUP`

### Syntax


```

DeadAGI(command,arg1,[arg2[,...]])
```
##### Arguments


* `command` - How AGI should be invoked on the channel.<br>

* `args` - Arguments to pass to the AGI script or server.<br>

    * `arg1` **required**

    * `arg2[,arg2...]`

### See Also

* [Dialplan Applications AGI](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/AGI)
* [Dialplan Applications EAGI](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/EAGI)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 