---
search:
  boost: 0.5
title: QueueEntry
---

# QueueEntry

### Synopsis

Raised in response to the QueueStatus action.

### Syntax


```


Event: QueueEntry
Queue: <value>
Position: <value>
Channel: <value>
Uniqueid: <value>
CallerIDNum: <value>
CallerIDName: <value>
ConnectedLineNum: <value>
ConnectedLineName: <value>
Wait: <value>
Priority: <value>

```
##### Arguments


* `Queue` - The name of the queue.<br>

* `Position` - The caller's position within the queue.<br>

* `Channel` - The name of the caller's channel.<br>

* `Uniqueid` - The unique ID of the channel.<br>

* `CallerIDNum` - The Caller ID number.<br>

* `CallerIDName` - The Caller ID name.<br>

* `ConnectedLineNum` - The bridged party's number.<br>

* `ConnectedLineName` - The bridged party's name.<br>

* `Wait` - The caller's wait time.<br>

* `Priority` - The caller's priority within the queue.<br>

### Class

AGENT
### See Also

* [AMI Events QueueParams](/Asterisk_18_Documentation/API_Documentation/AMI_Events/QueueParams)
* [AMI Events QueueMember](/Asterisk_18_Documentation/API_Documentation/AMI_Events/QueueMember)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 