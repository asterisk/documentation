---
title: Queue Logs
pageid: 5243044
---

In order to properly manage ACD queues, it is important to be able to keep track of details of call setups and teardowns in much greater detail than traditional call detail records provide. In order to support this, extensive and detailed tracing of every queued call is stored in the queue log, located (by default) in /var/log/asterisk/queue_log.

How do I interpret the lines in the Queue log?
----------------------------------------------

The actual queue_log file will contain lines looking like the following:

`1366720340|1366720340.303267|MYQUEUE|SIP/8007|RINGNOANSWER|1000`The pipe delimited fields from left to right are:

* UNIX timestamp
* Typically a Unique ID for the queue callers channel (based on the UNIX timestamp), also possible "REALTIME" or "NONE"
* Queue name
* Queue member channel
* Event type (see below reference)
* All fields to the right of the event type are event parameters

### Queue log event types

These are the events (and associated information) in the queue log:

* ABANDON(position|origposition|waittime) - The caller abandoned their position in the queue. The position is the caller's position in the queue when they hungup, the origposition is the original position the caller was when they first entered the queue, and the waittime is how long the call had been waiting in the queue at the time of disconnect.
* ADDMEMBER - A member was added to the queue. The bridged channel name will be populated with the name of the channel added to the queue.
* AGENTDUMP - The agent dumped the caller while listening to the queue announcement.
* AGENTLOGIN(channel) - The agent logged in. The channel is recorded.
* AGENTCALLBACKLOGIN(exten@context) - The callback agent logged in. The login extension and context is recorded.
* AGENTLOGOFF(channel|logintime) - The agent logged off. The channel is recorded, along with the total time the agent was logged in.
* AGENTCALLBACKLOGOFF(exten@context|logintime|reason) - The callback agent logged off. The last login extension and context is recorded, along with the total time the agent was logged in, and the reason for the logoff if it was not a normal logoff (e.g., Autologoff, Chanunavail)
* ATTENDEDTRANSFER(method|method-data|holdtime|calltime|origposition) - (Added in 12) This message will indicate the method by which the attended transfer was completed:`BRIDGE` for a bridge merge, `APP` for running an application on a bridge or channel, or `LINK` for linking two bridges together with local channels.
* BLINDTRANSFER(extension|context|holdtime|calltime|origposition) - (Added in 12) A blind transfer will result in a `BLINDTRANSFER` message with the destination context and extension.
* COMPLETEAGENT(holdtime|calltime|origposition) - The caller was connected to an agent, and the call was terminated normally by the agent. The caller's hold time and the length of the call are both recorded. The caller's original position in the queue is recorded in origposition.
* COMPLETECALLER(holdtime|calltime|origposition) - The caller was connected to an agent, and the call was terminated normally by the caller. The caller's hold time and the length of the call are both recorded. The caller's original position in the queue is recorded in origposition.
* CONFIGRELOAD - The configuration has been reloaded (e.g. with asterisk -rx reload)
* CONNECT(holdtime|bridgedchanneluniqueid|ringtime) - The caller was connected to an agent. Hold time represents the amount of time the caller was on hold. The bridged channel unique ID contains the unique ID of the queue member channel that is taking the call. This is useful when trying to link recording filenames to a particular call in the queue. Ringtime represents the time the queue members phone was ringing prior to being answered.
* ENTERQUEUE(url|callerid) - A call has entered the queue. URL (if specified) and Caller\*ID are placed in the log.
* EXITEMPTY(position|origposition|waittime) - The caller was exited from the queue forcefully because the queue had no reachable members and it's configured to do that to callers when there are no reachable members. The position is the caller's position in the queue when they hungup, the origposition is the original position the caller was when they first entered the queue, and the waittime is how long the call had been waiting in the queue at the time of disconnect.
* EXITWITHKEY(key|position|origposition|waittime) - The caller elected to use a menu key to exit the queue. The key and the caller's position in the queue are recorded. The caller's entry position and amoutn of time waited is also recorded.
* EXITWITHTIMEOUT(position|origposition|waittime) - The caller was on hold too long and the timeout expired. The position in the queue when the timeout occurred, the entry position, and the amount of time waited are logged.
* QUEUESTART - The queueing system has been started for the first time this session.
* REMOVEMEMBER - A queue member was removed from the queue. The bridge channel field will contain the name of the member removed from the queue.
* RINGNOANSWER(ringtime) - After trying for ringtime ms to connect to the available queue member, the attempt ended without the member picking up the call. Bad queue member!
* RINGCANCELED - A caller is ringing a queue member, but that caller hangs up before the member answers or times out.
* SYSCOMPAT - A call was answered by an agent, but the call was dropped because the channels were not compatible.
* TRANSFER(extension|context|holdtime|calltime|origposition) - Caller was transferred to a different extension. Context and extension are recorded. The caller's hold time and the length of the call are both recorded, as is the caller's entry position at the time of the transfer. PLEASE remember that transfers performed by SIP UA's by way of a reinvite may not always be caught by Asterisk and trigger off this event. The only way to be 100% sure that you will get this event when a transfer is performed by a queue member is to use the built-in transfer functionality of Asterisk.

Queue log options
-----------------

There are one or more options for queue logging in queues.conf, such as "log_membername_as_agent". See the queues.conf sample file for explanations of those options.



