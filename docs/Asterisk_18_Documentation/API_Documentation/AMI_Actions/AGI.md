---
search:
  boost: 0.5
title: AGI
---

# AGI

### Synopsis

Add an AGI command to execute by Async AGI.

### Description

Add an AGI command to the execute queue of the channel in Async AGI.<br>


### Syntax


```


Action: AGI
ActionID: <value>
Channel: <value>
Command: <value>
CommandID: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Channel` - Channel that is currently in Async AGI.<br>

* `Command` - Application to execute.<br>

* `CommandID` - This will be sent back in CommandID header of AsyncAGI exec event notification.<br>

### See Also

* [AMI Events AsyncAGIStart](/Asterisk_18_Documentation/API_Documentation/AMI_Events/AsyncAGIStart)
* [AMI Events AsyncAGIExec](/Asterisk_18_Documentation/API_Documentation/AMI_Events/AsyncAGIExec)
* [AMI Events AsyncAGIEnd](/Asterisk_18_Documentation/API_Documentation/AMI_Events/AsyncAGIEnd)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 