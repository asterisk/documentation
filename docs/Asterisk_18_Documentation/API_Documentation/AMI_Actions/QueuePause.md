---
search:
  boost: 0.5
title: QueuePause
---

# QueuePause

### Synopsis

Makes a queue member temporarily unavailable.

### Description

Pause or unpause a member in a queue.<br>


### Syntax


```


Action: QueuePause
ActionID: <value>
Interface: <value>
Paused: <value>
Queue: <value>
Reason: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Interface` - The name of the interface (tech/name) to pause or unpause.<br>

* `Paused` - Pause or unpause the interface. Set to 'true' to pause the member or 'false' to unpause.<br>

* `Queue` - The name of the queue in which to pause or unpause this member. If not specified, the member will be paused or unpaused in all the queues it is a member of.<br>

* `Reason` - Text description, returned in the event QueueMemberPaused.<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 