---
search:
  boost: 0.5
title: QueueChangePriorityCaller
---

# QueueChangePriorityCaller

### Synopsis

Change priority of a caller on queue.

### Description


### Syntax


```


Action: QueueChangePriorityCaller
ActionID: <value>
Queue: <value>
Caller: <value>
Priority: <value>
Immediate: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Queue` - The name of the queue to take action on.<br>

* `Caller` - The caller (channel) to change priority on queue.<br>

* `Priority` - Priority value for change for caller on queue.<br>

* `Immediate` - When set to yes will cause the priority change to be reflected immediately, causing the channel to change position within the queue.<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 