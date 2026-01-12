---
search:
  boost: 0.5
title: QUEUE_MEMBER
---

# QUEUE_MEMBER()

### Synopsis

Provides a count of queue members based on the provided criteria, or updates a queue member's settings.

### Description

Allows access to queue counts \[R\] and member information \[R/W\].<br>

queuename is required for all read operations.<br>

interface is required for all member operations.<br>


### Syntax


```

QUEUE_MEMBER([queuename,option[,interface]])
```
##### Arguments


* `queuename`

* `option`

    * `logged` - Returns the number of logged-in members for the specified queue.<br>

    * `free` - Returns the number of logged-in members for the specified queue that either can take calls or are currently wrapping up after a previous call.<br>

    * `ready` - Returns the number of logged-in members for the specified queue that are immediately available to answer a call.<br>

    * `count` - Returns the total number of members for the specified queue.<br>

    * `penalty` - Gets or sets queue member penalty. If _queuename_ is not specified when setting the penalty then the penalty is set in all queues the interface is a member.<br>

    * `paused` - Gets or sets queue member paused status. If _queuename_ is not specified when setting the paused status then the paused status is set in all queues the interface is a member.<br>

    * `ringinuse` - Gets or sets queue member ringinuse. If _queuename_ is not specified when setting ringinuse then ringinuse is set in all queues the interface is a member.<br>

* `interface`

### See Also

* [Dialplan Applications Queue](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/Queue)
* [Dialplan Applications QueueLog](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/QueueLog)
* [Dialplan Applications AddQueueMember](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/AddQueueMember)
* [Dialplan Applications RemoveQueueMember](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/RemoveQueueMember)
* [Dialplan Applications PauseQueueMember](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/PauseQueueMember)
* [Dialplan Applications UnpauseQueueMember](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/UnpauseQueueMember)
* [Dialplan Functions QUEUE_VARIABLES](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/QUEUE_VARIABLES)
* [Dialplan Functions QUEUE_MEMBER](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/QUEUE_MEMBER)
* [Dialplan Functions QUEUE_MEMBER_COUNT](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/QUEUE_MEMBER_COUNT)
* [Dialplan Functions QUEUE_EXISTS](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/QUEUE_EXISTS)
* [Dialplan Functions QUEUE_GET_CHANNEL](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/QUEUE_GET_CHANNEL)
* [Dialplan Functions QUEUE_WAITING_COUNT](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/QUEUE_WAITING_COUNT)
* [Dialplan Functions QUEUE_MEMBER_LIST](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/QUEUE_MEMBER_LIST)
* [Dialplan Functions QUEUE_MEMBER_PENALTY](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/QUEUE_MEMBER_PENALTY)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 