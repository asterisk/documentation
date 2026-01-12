---
search:
  boost: 0.5
title: ChangeMonitor
---

# ChangeMonitor

### Synopsis

Change monitoring filename of a channel.

### Description

This action may be used to change the file started by a previous 'Monitor' action.<br>


### Syntax


```


Action: ChangeMonitor
ActionID: <value>
Channel: <value>
File: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Channel` - Used to specify the channel to record.<br>

* `File` - Is the new name of the file created in the monitor spool directory.<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 