---
search:
  boost: 0.5
title: QueueAdd
---

# QueueAdd

### Synopsis

Add interface to queue.

### Description


### Syntax


```


    Action: QueueAdd
    ActionID: <value>
    Queue: <value>
    Interface: <value>
    Penalty: <value>
    Paused: <value>
    MemberName: <value>
    StateInterface: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Queue` - Queue's name.<br>

* `Interface` - The name of the interface (tech/name) to add to the queue.<br>

* `Penalty` - A penalty (number) to apply to this member. Asterisk will distribute calls to members with higher penalties only after attempting to distribute calls to those with lower penalty.<br>

* `Paused` - To pause or not the member initially (true/false or 1/0).<br>

* `MemberName` - Text alias for the interface.<br>

* `StateInterface`


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 