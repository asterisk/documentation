---
search:
  boost: 0.5
title: QueueParams
---

# QueueParams

### Synopsis

Raised in response to the QueueStatus action.

### Syntax


```


    Event: QueueParams
    Max: <value>
    Strategy: <value>
    Calls: <value>
    Holdtime: <value>
    TalkTime: <value>
    Completed: <value>
    Abandoned: <value>
    ServiceLevelPerf: <value>
    ServiceLevelPerf2: <value>

```
##### Arguments


* `Max` - The name of the queue.<br>

* `Strategy` - The strategy of the queue.<br>

* `Calls` - The queue member's channel technology or location.<br>

* `Holdtime` - The queue's hold time.<br>

* `TalkTime` - The queue's talk time.<br>

* `Completed` - The queue's completion time.<br>

* `Abandoned` - The queue's call abandonment metric.<br>

* `ServiceLevelPerf` - Primary service level performance metric.<br>

* `ServiceLevelPerf2` - Secondary service level performance metric.<br>

### Class

AGENT
### See Also

* [AMI Events QueueMember](/Asterisk_16_Documentation/API_Documentation/AMI_Events/QueueMember)
* [AMI Events QueueEntry](/Asterisk_16_Documentation/API_Documentation/AMI_Events/QueueEntry)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 