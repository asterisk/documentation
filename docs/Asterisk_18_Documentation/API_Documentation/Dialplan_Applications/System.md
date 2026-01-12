---
search:
  boost: 0.5
title: System
---

# System()

### Synopsis

Execute a system command.

### Description

Executes a command by using system(). If the command fails, the console should report a fallthrough.<br>

Result of execution is returned in the **SYSTEMSTATUS** channel variable:<br>


* `SYSTEMSTATUS`

    * `FAILURE` - Could not execute the specified command.

    * `SUCCESS` - Specified command successfully executed.

### Syntax


```

System(command)
```
##### Arguments


* `command` - Command to execute<br>

    /// warning
Do not use untrusted strings such as **CALLERID(num)** or **CALLERID(name)** as part of the command parameters. You risk a command injection attack executing arbitrary commands if the untrusted strings aren't filtered to remove dangerous characters. See function **FILTER()**.
///



### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 