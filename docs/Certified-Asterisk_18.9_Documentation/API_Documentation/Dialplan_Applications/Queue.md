---
search:
  boost: 0.5
title: Queue
---

# Queue()

### Synopsis

Queue a call for a call queue.

### Description

In addition to transferring the call, a call may be parked and then picked up by another user.<br>

This application will return to the dialplan if the queue does not exist, or any of the join options cause the caller to not enter the queue.<br>

This application does not automatically answer and should be preceeded by an application such as Answer(), Progress(), or Ringing().<br>

This application sets the following channel variables upon completion:<br>


* `QUEUESTATUS` - The status of the call as a text string.<br>

    * `TIMEOUT`

    * `FULL`

    * `JOINEMPTY`

    * `LEAVEEMPTY`

    * `JOINUNAVAIL`

    * `LEAVEUNAVAIL`

    * `CONTINUE`

* `ABANDONED` - If the call was not answered by an agent this variable will be TRUE.<br>

    * `TRUE`

### Syntax


```

Queue(queuename,[options,[URL,filename&[filename2[&...]],[timeout,[AGI,[macro,[gosub,[rule,[position]]]]]]]]])
```
##### Arguments


* `queuename`

* `options`

    * `b(context^exten^priority)` - Before initiating an outgoing call, 'Gosub' to the specified location using the newly created channel. The 'Gosub' will be executed for each destination channel.<br>

        * `context`

        * `exten`

        * `priority (params )` **required**

            * `arg1[^arg1...]` **required**

            * `argN`


    * `B(context^exten^priority)` - Before initiating the outgoing call(s), 'Gosub' to the specified location using the current channel.<br>

        * `context`

        * `exten`

        * `priority (params )` **required**

            * `arg1[^arg1...]` **required**

            * `argN`


    * `C` - Mark all calls as "answered elsewhere" when cancelled.<br>


    * `c` - Continue in the dialplan if the callee hangs up.<br>


    * `d` - data-quality (modem) call (minimum delay).<br>


    * `F(context^exten^priority)` - When the caller hangs up, transfer the *called member* to the specified destination and *start* execution at that location.<br>
NOTE: Any channel variables you want the called channel to inherit from the caller channel must be prefixed with one or two underbars ('\_').<br>

        * `context`

        * `exten`

        * `priority` **required**


    * `F` - When the caller hangs up, transfer the *called member* to the next priority of the current extension and *start* execution at that location.<br>
NOTE: Any channel variables you want the called channel to inherit from the caller channel must be prefixed with one or two underbars ('\_').<br>
NOTE: Using this option from a Macro() or GoSub() might not make sense as there would be no return points.<br>


    * `h` - Allow *callee* to hang up by pressing '*'.<br>


    * `H` - Allow *caller* to hang up by pressing '*'.<br>


    * `n` - No retries on the timeout; will exit this application and go to the next step.<br>


    * `i` - Ignore call forward requests from queue members and do nothing when they are requested.<br>


    * `I` - Asterisk will ignore any connected line update requests or any redirecting party update requests it may receive on this dial attempt.<br>


    * `r` - Ring instead of playing MOH. Periodic Announcements are still made, if applicable.<br>


    * `R` - Ring instead of playing MOH when a member channel is actually ringing.<br>


    * `t` - Allow the *called* user to transfer the calling user.<br>


    * `T` - Allow the *calling* user to transfer the call.<br>


    * `w` - Allow the *called* user to write the conversation to disk via Monitor.<br>


    * `W` - Allow the *calling* user to write the conversation to disk via Monitor.<br>


    * `k` - Allow the *called* party to enable parking of the call by sending the DTMF sequence defined for call parking in *features.conf*.<br>


    * `K` - Allow the *calling* party to enable parking of the call by sending the DTMF sequence defined for call parking in *features.conf*.<br>


    * `x` - Allow the *called* user to write the conversation to disk via MixMonitor.<br>


    * `X` - Allow the *calling* user to write the conversation to disk via MixMonitor.<br>


* `URL` - URL will be sent to the called party if the channel supports it.<br>

* `announceoverride`

    * `filename` **required** - Announcement file(s) to play to agent before bridging call, overriding the announcement(s) configured in *queues.conf*, if any.<br>

    * `filename2[,filename2...]`

* `timeout` - Will cause the queue to fail out after a specified number of seconds, checked between each *queues.conf* _timeout_ and _retry_ cycle.<br>

* `AGI` - Will setup an AGI script to be executed on the calling party's channel once they are connected to a queue member.<br>

* `macro` - Will run a macro on the called party's channel (the queue member) once the parties are connected.<br>
NOTE: Macros are deprecated, GoSub should be used instead.<br>

* `gosub` - Will run a gosub on the called party's channel (the queue member) once the parties are connected. The subroutine execution starts in the named context at the s exten and priority 1.<br>

* `rule` - Will cause the queue's defaultrule to be overridden by the rule specified.<br>

* `position` - Attempt to enter the caller into the queue at the numerical position specified. '1' would attempt to enter the caller at the head of the queue, and '3' would attempt to place the caller third in the queue.<br>

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