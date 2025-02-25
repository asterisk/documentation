---
search:
  boost: 0.5
title: QueueReload
---

# QueueReload

### Synopsis

Reload a queue, queues, or any sub-section of a queue or queues.

### Description


### Syntax


```


    Action: QueueReload
    ActionID: <value>
    Queue: <value>
    Members: <value>
    Rules: <value>
    Parameters: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Queue` - The name of the queue to take action on. If no queue name is specified, then all queues are affected.<br>

* `Members` - Whether to reload the queue's members.<br>

    * `yes`

    * `no`

* `Rules` - Whether to reload queuerules.conf<br>

    * `yes`

    * `no`

* `Parameters` - Whether to reload the other queue options.<br>

    * `yes`

    * `no`


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 