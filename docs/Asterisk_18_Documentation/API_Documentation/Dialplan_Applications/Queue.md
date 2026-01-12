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

    * `WITHDRAW`

* `ABANDONED` - If the call was not answered by an agent this variable will be TRUE.<br>

    * `TRUE`

* `DIALEDPEERNUMBER` - Resource of the agent that was dialed set on the outbound channel.<br>

* `QUEUE_WITHDRAW_INFO` - If the call was successfully withdrawn from the queue, and the withdraw request was provided with optional withdraw info, the withdraw info will be stored in this variable.<br>

### Syntax


```

Queue(queuename,[options,[URL,announceoverride&[announceoverride2[&...]],[timeout,[AGI,[macro,[gosub,[rule,[position]]]]]]]]])
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


    * `d` - Data-quality (modem) call (minimum delay).<br>
This option only applies to DAHDI channels. By default, DTMF is verified by muting audio TX/RX to verify the tone is still present. This option disables that behavior.<br>


    * `F(context^exten^priority)` - When the caller hangs up, transfer the *called member* to the specified destination and *start* execution at that location.<br>
NOTE: Any channel variables you want the called channel to inherit from the caller channel must be prefixed with one or two underbars ('\_').<br>
NOTE: Using this option from a Macro() or GoSub() might not make sense as there would be no return points.<br>

        * `context`

        * `exten`

        * `priority` **required**


    * `h` - Allow *callee* to hang up by pressing '*'.<br>


    * `H` - Allow *caller* to hang up by pressing '*'.<br>


    * `i` - Ignore call forward requests from queue members and do nothing when they are requested.<br>


    * `I` - Asterisk will ignore any connected line update requests or any redirecting party update requests it may receive on this dial attempt.<br>


    * `k` - Allow the *called* party to enable parking of the call by sending the DTMF sequence defined for call parking in *features.conf*.<br>


    * `K` - Allow the *calling* party to enable parking of the call by sending the DTMF sequence defined for call parking in *features.conf*.<br>


    * `m` - Custom music on hold class to use, which will override the music on hold class configured in *queues.conf*, if specified.<br>
Note that CHANNEL(musicclass), if set, will still override this option.<br>


    * `n` - No retries on the timeout; will exit this application and go to the next step.<br>


    * `r` - Ring instead of playing MOH. Periodic Announcements are still made, if applicable.<br>


    * `R` - Ring instead of playing MOH when a member channel is actually ringing.<br>


    * `t` - Allow the *called* user to transfer the calling user.<br>


    * `T` - Allow the *calling* user to transfer the call.<br>


    * `w` - Allow the *called* user to write the conversation to disk via Monitor.<br>


    * `W` - Allow the *calling* user to write the conversation to disk via Monitor.<br>


    * `x` - Allow the *called* user to write the conversation to disk via MixMonitor.<br>


    * `X` - Allow the *calling* user to write the conversation to disk via MixMonitor.<br>


* `URL` - URL will be sent to the called party if the channel supports it.<br>

* `announceoverride` - Announcement file(s) to play to agent before bridging call, overriding the announcement(s) configured in *queues.conf*, if any.<br>
Ampersand separated list of filenames. If the filename is a relative filename (it does not begin with a slash), it will be searched for in the Asterisk sounds directory. If the filename is able to be parsed as a URL, Asterisk will download the file and then begin playback on it. To include a literal '&' in the URL you can enclose the URL in single quotes.<br>

    * `announceoverride` **required**

    * `announceoverride2[,announceoverride2...]`

* `timeout` - Will cause the queue to fail out after a specified number of seconds, checked between each *queues.conf* _timeout_ and _retry_ cycle.<br>

* `AGI` - Will setup an AGI script to be executed on the calling party's channel once they are connected to a queue member.<br>

* `macro` - Will run a macro on the called party's channel (the queue member) once the parties are connected.<br>
NOTE: Macros are deprecated, GoSub should be used instead.<br>

* `gosub` - Will run a gosub on the called party's channel (the queue member) once the parties are connected. The subroutine execution starts in the named context at the s exten and priority 1.<br>

* `rule` - Will cause the queue's defaultrule to be overridden by the rule specified.<br>

* `position` - Attempt to enter the caller into the queue at the numerical position specified. '1' would attempt to enter the caller at the head of the queue, and '3' would attempt to place the caller third in the queue.<br>

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