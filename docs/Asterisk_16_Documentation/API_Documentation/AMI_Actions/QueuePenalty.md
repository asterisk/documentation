---
search:
  boost: 0.5
title: QueuePenalty
---

# QueuePenalty

### Synopsis

Set the penalty for a queue member.

### Description

Change the penalty of a queue member<br>


### Syntax


```


    Action: QueuePenalty
    ActionID: <value>
    Interface: <value>
    Penalty: <value>
    Queue: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Interface` - The interface (tech/name) of the member whose penalty to change.<br>

* `Penalty` - The new penalty (number) for the member. Must be nonnegative.<br>

* `Queue` - If specified, only set the penalty for the member of this queue. Otherwise, set the penalty for the member in all queues to which the member belongs.<br>


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 