---
search:
  boost: 0.5
title: MixMonitor
---

# MixMonitor

### Synopsis

Record a call and mix the audio during the recording. Use of StopMixMonitor is required to guarantee the audio file is available for processing during dialplan execution.

### Description

This action records the audio on the current channel to the specified file.<br>


* `MIXMONITOR_FILENAME` - Will contain the filename used to record the mixed stream.<br>

### Syntax


```


    Action: MixMonitor
    ActionID: <value>
    Channel: <value>
    File: <value>
    options: <value>
    Command: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Channel` - Used to specify the channel to record.<br>

* `File` - Is the name of the file created in the monitor spool directory. Defaults to the same name as the channel (with slashes replaced with dashes). This argument is optional if you specify to record unidirectional audio with either the r(filename) or t(filename) options in the options field. If neither MIXMONITOR\_FILENAME or this parameter is set, the mixed stream won't be recorded.<br>

* `options` - Options that apply to the MixMonitor in the same way as they would apply if invoked from the MixMonitor application. For a list of available options, see the documentation for the mixmonitor application.<br>

* `Command` - Will be executed when the recording is over. Any strings matching '\^\{X\}' will be unescaped to **X**. All variables will be evaluated at the time MixMonitor is called.<br>

    /// warning
Do not use untrusted strings such as **CALLERID(num)** or **CALLERID(name)** as part of the command parameters. You risk a command injection attack executing arbitrary commands if the untrusted strings aren't filtered to remove dangerous characters. See function **FILTER()**.
///



### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 