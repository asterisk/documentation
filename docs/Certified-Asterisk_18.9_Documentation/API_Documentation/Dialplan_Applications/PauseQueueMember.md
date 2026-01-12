---
search:
  boost: 0.5
title: PauseQueueMember
---

# PauseQueueMember()

### Synopsis

Pauses a queue member.

### Description

Pauses (blocks calls for) a queue member. The given interface will be paused in the given queue. This prevents any calls from being sent from the queue to the interface until it is unpaused with UnpauseQueueMember or the manager interface. If no queuename is given, the interface is paused in every queue it is a member of. The application will fail if the interface is not found.<br>

This application sets the following channel variable upon completion:<br>


* `PQMSTATUS` - The status of the attempt to pause a queue member as a text string.<br>

    * `PAUSED`

    * `NOTFOUND`
``` title="Example: Pause queue member"

same => n,PauseQueueMember(,SIP/3000)


```

### Syntax


```

PauseQueueMember([queuename,interface,[options,[reason]]])
```
##### Arguments


* `queuename`

* `interface`

* `options`

* `reason` - Is used to add extra information to the appropriate queue\_log entries and manager events.<br>

### See Also

* [Dialplan Applications Queue](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/Queue)
* [Dialplan Applications QueueLog](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/QueueLog)
* [Dialplan Applications AddQueueMember](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/AddQueueMember)
* [Dialplan Applications RemoveQueueMember](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/RemoveQueueMember)
* [Dialplan Applications PauseQueueMember](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/PauseQueueMember)
* [Dialplan Applications UnpauseQueueMember](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/UnpauseQueueMember)
* [Dialplan Functions QUEUE_VARIABLES](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/QUEUE_VARIABLES)
* [Dialplan Functions QUEUE_MEMBER](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/QUEUE_MEMBER)
* [Dialplan Functions QUEUE_MEMBER_COUNT](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/QUEUE_MEMBER_COUNT)
* [Dialplan Functions QUEUE_EXISTS](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/QUEUE_EXISTS)
* [Dialplan Functions QUEUE_GET_CHANNEL](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/QUEUE_GET_CHANNEL)
* [Dialplan Functions QUEUE_WAITING_COUNT](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/QUEUE_WAITING_COUNT)
* [Dialplan Functions QUEUE_MEMBER_LIST](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/QUEUE_MEMBER_LIST)
* [Dialplan Functions QUEUE_MEMBER_PENALTY](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/QUEUE_MEMBER_PENALTY)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 