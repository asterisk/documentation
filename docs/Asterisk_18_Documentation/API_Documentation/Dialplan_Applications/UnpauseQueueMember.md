---
search:
  boost: 0.5
title: UnpauseQueueMember
---

# UnpauseQueueMember()

### Synopsis

Unpauses a queue member.

### Description

Unpauses (resumes calls to) a queue member. This is the counterpart to 'PauseQueueMember()' and operates exactly the same way, except it unpauses instead of pausing the given interface.<br>

This application sets the following channel variable upon completion:<br>


* `UPQMSTATUS` - The status of the attempt to unpause a queue member as a text string.<br>

    * `UNPAUSED`

    * `NOTFOUND`
``` title="Example: Unpause queue member"

same => n,UnpauseQueueMember(,SIP/3000)


```

### Syntax


```

UnpauseQueueMember([queuename,interface,[options,[reason]]])
```
##### Arguments


* `queuename`

* `interface`

* `options`

* `reason` - Is used to add extra information to the appropriate queue\_log entries and manager events.<br>

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