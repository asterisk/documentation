---
search:
  boost: 0.5
title: QUEUE_GET_CHANNEL
---

# QUEUE_GET_CHANNEL()

### Synopsis

Return caller at the specified position in a queue.

### Description

Returns the caller channel at _position_ in the specified _queuename_.<br>

If _position_ is unspecified the first channel is returned.<br>


### Syntax


```

QUEUE_GET_CHANNEL(queuename,position)
```
##### Arguments


* `queuename`

* `position`

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
* [Dialplan Functions QUEUE_WAITING_COUNT](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/QUEUE_WAITING_COUNT)
* [Dialplan Functions QUEUE_MEMBER_LIST](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/QUEUE_MEMBER_LIST)
* [Dialplan Functions QUEUE_MEMBER_PENALTY](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/QUEUE_MEMBER_PENALTY)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 