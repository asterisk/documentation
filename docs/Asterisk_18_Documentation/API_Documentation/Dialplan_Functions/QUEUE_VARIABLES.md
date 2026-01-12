---
search:
  boost: 0.5
title: QUEUE_VARIABLES
---

# QUEUE_VARIABLES()

### Synopsis

Return Queue information in variables.

### Description

Makes the following queue variables available.<br>

Returns '0' if queue is found and setqueuevar is defined, '-1' otherwise.<br>


### Syntax


```

QUEUE_VARIABLES(queuename)
```
##### Arguments


* `queuename`

    * `QUEUEMAX` - Maxmimum number of calls allowed.<br>

    * `QUEUESTRATEGY` - The strategy of the queue.<br>

    * `QUEUECALLS` - Number of calls currently in the queue.<br>

    * `QUEUEHOLDTIME` - Current average hold time.<br>

    * `QUEUECOMPLETED` - Number of completed calls for the queue.<br>

    * `QUEUEABANDONED` - Number of abandoned calls.<br>

    * `QUEUESRVLEVEL` - Queue service level.<br>

    * `QUEUESRVLEVELPERF` - Current service level performance.<br>

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