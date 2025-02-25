---
search:
  boost: 0.5
title: Monitor
---

# Monitor

### Synopsis

Monitor a channel.

### Description

This action may be used to record the audio on a specified channel.<br>


### Syntax


```


    Action: Monitor
    ActionID: <value>
    Channel: <value>
    File: <value>
    Format: <value>
    Mix: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Channel` - Used to specify the channel to record.<br>

* `File` - Is the name of the file created in the monitor spool directory. Defaults to the same name as the channel (with slashes replaced with dashes).<br>

* `Format` - Is the audio recording format. Defaults to 'wav'.<br>

* `Mix` - Boolean parameter as to whether to mix the input and output channels together after the recording is finished.<br>


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 