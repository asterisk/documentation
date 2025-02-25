---
search:
  boost: 0.5
title: QueueMemberAdded
---

# QueueMemberAdded

### Synopsis

Raised when a member is added to the queue.

### Syntax


```


    Event: QueueMemberAdded
    Queue: <value>
    MemberName: <value>
    Interface: <value>
    StateInterface: <value>
    Membership: <value>
    Penalty: <value>
    CallsTaken: <value>
    LastCall: <value>
    LastPause: <value>
    LoginTime: <value>
    InCall: <value>
    Status: <value>
    Paused: <value>
    PausedReason: <value>
    Ringinuse: <value>
    Wrapuptime: <value>

```
##### Arguments


* `Queue` - The name of the queue.<br>

* `MemberName` - The name of the queue member.<br>

* `Interface` - The queue member's channel technology or location.<br>

* `StateInterface` - Channel technology or location from which to read device state changes.<br>

* `Membership`

    * `dynamic`

    * `realtime`

    * `static`

* `Penalty` - The penalty associated with the queue member.<br>

* `CallsTaken` - The number of calls this queue member has serviced.<br>

* `LastCall` - The time this member last took a call, expressed in seconds since 00:00, Jan 1, 1970 UTC.<br>

* `LastPause` - The time when started last paused the queue member.<br>

* `LoginTime` - The time this member logged in to the queue, expressed in seconds since 00:00, Jan 1, 1970 UTC.<br>

* `InCall` - Set to 1 if member is in call. Set to 0 after LastCall time is updated.<br>

    * `0`

    * `1`

* `Status` - The numeric device state status of the queue member.<br>

    * `0` - AST\_DEVICE\_UNKNOWN<br>

    * `1` - AST\_DEVICE\_NOT\_INUSE<br>

    * `2` - AST\_DEVICE\_INUSE<br>

    * `3` - AST\_DEVICE\_BUSY<br>

    * `4` - AST\_DEVICE\_INVALID<br>

    * `5` - AST\_DEVICE\_UNAVAILABLE<br>

    * `6` - AST\_DEVICE\_RINGING<br>

    * `7` - AST\_DEVICE\_RINGINUSE<br>

    * `8` - AST\_DEVICE\_ONHOLD<br>

* `Paused`

    * `0`

    * `1`

* `PausedReason` - If set when paused, the reason the queue member was paused.<br>

* `Ringinuse`

    * `0`

    * `1`

* `Wrapuptime` - The Wrapup Time of the queue member. If this value is set will override the wrapup time of queue.<br>

### Class

AGENT
### See Also

* [AMI Events QueueMemberRemoved](/Asterisk_16_Documentation/API_Documentation/AMI_Events/QueueMemberRemoved)
* [Dialplan Applications AddQueueMember](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/AddQueueMember)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 