---
title: Building Queues
pageid: 4259968
---

Building Queues
===============

Written by: Leif Madsen  
 Initial version: 2010-01-14




!!! note 
    Note that this documentation is based on Asterisk 1.6.2, and this is just one approach to creating queues and the dialplan logic. You may create a better way, and in that case, I would encourage you to submit it to the Asterisk issue tracker at <https://github.com/asterisk/asterisk/issues> for inclusion in Asterisk.

      
[//]: # (end-note)



In this article, we'll look at setting up a pair of queues in Asterisk called 'sales' and 'support'. These queues can be logged into by queue members, and those members will also have the ability to pause and unpause themselves.

All configuration will be done in flat files on the system in order to maintain simplicity in configuration.

##### Adding SIP Devices to Your Server

The first thing we want to do is register a couple of SIP devices to our server. These devices will be our agents that can login and out of the queues we'll create later. Our naming convention will be to use MAC addresses as we want to abstract the concepts of user (agent), device, and extension from each other.

In sip.conf, we add the following to the bottom of our file:

On This Page

```
sip.conf
--------

[std-device](!)
type=peer
context=devices
host=dynamic
secret=s3CuR#p@s5
dtmfmode=rfc2833
disallow=all
allow=ulaw

[0004f2040001](std-device)

[0004f2040002](std-device)

```

What we're doing here is creating a [std-device] template and applying it to a pair of peers that we'll register as 0004f2040001 and 0004f2040002; our devices.

Then our devices can register to Asterisk. In my case I have a hard phone and a soft phone registered. I can verify their connectivity by running 'sip show peers'.

```
\*CLI> sip show peers
Name/username Host Dyn Nat ACL Port Status 
0004f2040001/0004f2040001 192.168.128.145 D 5060 Unmonitored 
0004f2040002/0004f2040002 192.168.128.126 D 5060 Unmonitored 
2 sip peers [Monitored: 0 online, 0 offline Unmonitored: 2 online, 0 offline]

```

##### Configuring Device State

Next, we need to configure our system to track the state of the devices. We do this by defining a 'hint' in the dialplan which creates the ability for a device subscription to be retained in memory. By default we can see there are no hints registered in our system by running the 'core show hints' command.

```
\*CLI> core show hints
There are no registered dialplan hint

```

We need to add the devices we're going to track to the extensions.conf file under the [default] context which is the default configuration in sip.conf, however we can change this to any context we want with the 'subscribecontext'  


Add the following lines to extensions.conf:

```
[default]
exten => 0004f2040001,hint,SIP/0004f2040001
exten => 0004f2040002,hint,SIP/0004f2040002

```

Then perform a 'dialplan reload' in order to reload the dialplan.

After reloading our dialplan, you can see the status of the devices with 'core show hints' again.

```
\*CLI> core show hints

 -= Registered Asterisk Dial Plan Hints =-
 0004f2040002@default : SIP/0004f2040002 State:Idle Watchers 0
 0004f2040001@default : SIP/0004f2040001 State:Idle Watchers 0
----------------
- 2 hints registered

```

At this point, create an extension that you can dial that will play a prompt that is long enough for you to go back to the Asterisk console to check the state of your device while it is in use.

To do this, add the 555 extension to the [devices] context and make it playback the tt-monkeys file.

```
extensions.conf
---------------

[devices]
exten => 555,1,Playback(tt-monkeys)

```

Dial that extension and then check the state of your device on the console.

```
\*CLI> == Using SIP RTP CoS mark 5
 -- Executing [555@devices:1] Playback("SIP/0004f2040001-00000001", "tt-monkeys") in new stack
 -- <SIP/0004f2040001-00000001> Playing 'tt-monkeys.slin' (language 'en')

\*CLI> core show hints

 -= Registered Asterisk Dial Plan Hints =-
 0004f2040002@default : SIP/0004f2040002 State:Idle Watchers 0
 0004f2040001@default : SIP/0004f2040001 State:Idle Watchers 0
----------------
- 2 hints registered

```

Aha, we're not getting the device state correctly. There must be something else we need to configure.

In sip.conf, we need to enable 'callcounter' in order to activate the ability for Asterisk to monitor whether the device is in use or not. In versions prior to 1.6.0 we needed to use 'call-limit' for this functionality, but call-limit is now deprecated and is no longer necessary.

So, in sip.conf, in our [std-device] template, we need to add the callcounter option.

```
sip.conf
--------

[std-device](!)
type=peer
context=devices
host=dynamic
secret=s3CuR#p@s5
dtmfmode=rfc2833
disallow=all
allow=ulaw
callcounter=yes ; <-- add this

```

Then reload chan_sip with 'sip reload' and perform our 555 test again. Dial 555 and then check the device state with 'core show hints'.

```
\*CLI> == Using SIP RTP CoS mark 5
 -- Executing [555@devices:1] Playback("SIP/0004f2040001-00000002", "tt-monkeys") in new stack
 -- <SIP/0004f2040001-00000002> Playing 'tt-monkeys.slin' (language 'en')

\*CLI> core show hints

 -= Registered Asterisk Dial Plan Hints =-
 0004f2040002@default : SIP/0004f2040002 State:Idle Watchers 0
 0004f2040001@default : SIP/0004f2040001 State:InUse Watchers 0
----------------
- 2 hints registered

```

Note that now we have the correct device state when extension 555 is dialed, showing that our device is InUse after dialing extension 555. This is important when creating queues, otherwise our queue members would get multiple calls from the queues.

##### Adding Queues to Asterisk

The next step is to add a couple of queues to Asterisk that we can assign queue members into. For now we'll work with two queues; sales and support. Lets create those queues now in queues.conf.

We'll leave the default settings that are shipped with queues.conf.sample in the [general] section of queues.conf. See the queues.conf.sample file for more information about each of the available options.

```
queues.conf
--------

[general]
persistentmembers=yes
autofill=yes
monitor-type=MixMonitor
shared_lastcall=no

```

We can then define a [queue_template] that we'll assign to each of the queues we create. These definitions can be overridden by each queue individually if you reassign them under the [sales] or [support] headers. So under the [general]  

```
queues.conf
----------

[queue_template](!)
musicclass=default ; play [default] music
strategy=rrmemory ; use the Round Robin Memory strategy
joinempty=yes ; join the queue when no members available
leavewhenempty=no ; don't leave the queue no members available
ringinuse=no ; don't ring members when already InUse

[sales](queue_template)
; Sales queue

[support](queue_template)
; Support queue

```

After defining our queues, lets reload our app_queue.so module.

```
\*CLI> module reload app_queue.so
 -- Reloading module 'app_queue.so' (True Call Queueing)

 == Parsing '/etc/asterisk/queues.conf': == Found

```

Then verify our queues loaded with 'queue show'.

```
\*CLI> queue show
support has 0 calls (max unlimited) in 'rrmemory' strategy (0s holdtime, 0s talktime), W:0, C:0, A:0, SL:0.0% within 0s
 No Members
 No Callers

sales has 0 calls (max unlimited) in 'rrmemory' strategy (0s holdtime, 0s talktime), W:0, C:0, A:0, SL:0.0% within 0s
 No Members
 No Callers

```

##### Adding Queue Members

You'll notice that we have no queue members available to take calls from the queues. We can add queue members from the Asterisk CLI with the 'queue add member' command.

This is the format of the 'queue add member' command:

```
Usage: queue add member <channel> to <queue> [[[penalty <penalty>] as <membername>] state_interface <interface>]
 Add a channel to a queue with optionally: a penalty, membername and a state_interface

```

The penalty, membername, and state_interface are all optional values. Special attention should be brought to the 'state_interface' option for a member though. The reason for state_interface is that if you're using a channel that does not have device state itself (for example, if you were using the Local channel to deliver a call to an end point) then you could assign the device state of a SIP device to the pseudo channel. This allows the state of a SIP device to be applied to the Local channel for correct device state information.

Lets add our device located at SIP/0004f2040001

```
\*CLI> queue add member SIP/0004f2040001 to sales
Added interface 'SIP/0004f2040001' to queue 'sales'

```

Then lets verify our member was indeed added.

```
\*CLI> queue show sales
sales has 0 calls (max unlimited) in 'rrmemory' strategy (0s holdtime, 0s talktime), W:0, C:0, A:0, SL:0.0% within 0s
 Members: 
 SIP/0004f2040001 (dynamic) (Not in use) has taken no calls yet
 No Callers

```

Now, if we dial our 555 extension, we should see that our member becomes InUse within the queue.

```
\*CLI> == Using SIP RTP CoS mark 5
 -- Executing [555@devices:1] Playback("SIP/0004f2040001-00000001", "tt-monkeys") in new stack
 -- <SIP/0004f2040001-00000001> Playing 'tt-monkeys.slin' (language 'en')


\*CLI> queue show sales
sales has 0 calls (max unlimited) in 'rrmemory' strategy (0s holdtime, 0s talktime), W:0, C:0, A:0, SL:0.0% within 0s
 Members: 
 SIP/0004f2040001 (dynamic) (In use) has taken no calls yet
 No Callers

```

We can also remove our members from the queue using the 'queue remove' CLI command.

```
\*CLI> queue remove member SIP/0004f2040001 from sales 
Removed interface 'SIP/0004f2040001' from queue 'sales'

```

Because we don't want to have to add queue members manually from the CLI, we should create a method that allows queue members to login and out from their devices. We'll do that in the next section.

But first, lets add an extension to our dialplan in order to permit people to dial into our queues so calls can be delivered to our queue members.

```
extensions.conf
---------------

[devices]
exten => 555,1,Playback(tt-monkeys)

exten => 100,1,Queue(sales)

exten => 101,1,Queue(support)

```

Then reload the dialplan, and try calling extension 100 from SIP/0004f2040002, which is the device we have not logged into the queue.

```
\*CLI> dialplan reload

```

And now we call the queue at extension 100 which will ring our device at SIP/0004f2040001.

```
\*CLI> == Using SIP RTP CoS mark 5
 -- Executing [100@devices:1] Queue("SIP/0004f2040002-00000005", "sales") in new stack
 -- Started music on hold, class 'default', on SIP/0004f2040002-00000005
 == Using SIP RTP CoS mark 5
 -- SIP/0004f2040001-00000006 is ringing

```

We can see the device state has changed to Ringing while the device is ringing.

```
\*CLI> queue show sales
sales has 1 calls (max unlimited) in 'rrmemory' strategy (2s holdtime, 3s talktime), W:0, C:1, A:1, SL:0.0% within 0s
 Members: 
 SIP/0004f2040001 (dynamic) (Ringing) has taken 1 calls (last was 14 secs ago)
 Callers: 
 1. SIP/0004f2040002-00000005 (wait: 0:03, prio: 0)

```

Our queue member then answers the phone.

```
\*CLI> -- SIP/0004f2040001-00000006 answered SIP/0004f2040002-00000005
 -- Stopped music on hold on SIP/0004f2040002-00000005
 -- Native bridging SIP/0004f2040002-00000005 and SIP/0004f2040001-00000006

```

And we can see the queue member is now in use.

```
\*CLI> queue show sales
sales has 0 calls (max unlimited) in 'rrmemory' strategy (3s holdtime, 3s talktime), W:0, C:1, A:1, SL:0.0% within 0s
 Members: 
 SIP/0004f2040001 (dynamic) (In use) has taken 1 calls (last was 22 secs ago)
 No Callers

```

Then the call is hung up.

```
\*CLI> == Spawn extension (devices, 100, 1) exited non-zero on 'SIP/0004f2040002-00000005'

```

And we see that our queue member is available to take another call.

```
\*CLI> queue show sales
sales has 0 calls (max unlimited) in 'rrmemory' strategy (3s holdtime, 4s talktime), W:0, C:2, A:1, SL:0.0% within 0s
 Members: 
 SIP/0004f2040001 (dynamic) (Not in use) has taken 2 calls (last was 6 secs ago)
 No Callers

```

##### Logging In and Out of Queues

In this section we'll show how to use the AddQueueMember() and RemoveQueueMember() dialplan applications to login and out of queues. For more information about the available options to AddQueueMember() and RemoveQueueMember() use the 'core show application <app>' command from the CLI.

The following bit of dialplan is a bit long, but stick with it, and you'll see that it isn't really all that bad. The gist of the dialplan is that it will check to see if the active user (the device that is dialing the extension) is currently logged into the queue extension that has been requested, and if logged in, then will log them out; if not logged in, then they will be logged into the queue.

We've updated the two lines we added in the previous section that allowed us to dial the sales and support queues. We've abstracted this out a bit in order to make it easier to add new queues in the future. This is done by adding the queue  


So we replace extension 100 and 101 with the following dialplan.

```
; Call any of the queues we've defined in the [globals] section.
exten => _1XX,1,Verbose(2,Call queue as configured in the QUEUE_${EXTEN} global variable)
exten => _1XX,n,Set(thisQueue=${GLOBAL(QUEUE_${EXTEN})})
exten => _1XX,n,GotoIf($["${thisQueue}" = ""]?invalid_queue,1)
exten => _1XX,n,Verbose(2, --> Entering the ${thisQueue} queue)
exten => _1XX,n,Queue(${thisQueue})
exten => _1XX,n,Hangup()

exten => invalid_queue,1,Verbose(2,Attempted to enter invalid queue)
exten => invalid_queue,n,Playback(silence/1&invalid)
exten => invalid_queue,n,Hangup()

```

The [globals](/globals) section contains the following two global variables.

```
[globals]
QUEUE_100=sales
QUEUE_101=support

```

So when we dial extension 100, it matches our pattern _1XX. The number we dialed (100) is then retrievable via ${EXTEN} and we can get the name of queue 100 (sales) from the global variable QUEUE_100. We then assign it to the channel variable thisQueue so it is easier to work with in our dialplan.

```
exten => _1XX,n,Set(thisQueue=${GLOBAL(QUEUE_${EXTEN})})

```

We then check to see if we've gotten a value back from the global variable which would indicate whether the queue was valid or not.

```
exten => _1XX,n,GotoIf($["${thisQueue}" = ""]?invalid_queue,1)

```

If ${thisQueue} returns nothing, then we Goto the invalid_queue extension and playback the 'invalid' file.

We could alternatively limit our pattern match to only extension 100 and 101 with the _10[0-1] pattern instead.

Lets move into the nitty-gritty section and show how we can login and logout our devices to the pair of queues we've created.

First, we create a pattern match that takes star  plus the queue number that we want to login or logout of. So to login/out of the sales queue (100) we would dial \*100. We use the same extension for logging in and out.

```
; Extension \*100 or \*101 will login/logout a queue member from sales or support queues respectively.
exten => _\*10[0-1],1,Set(xtn=${EXTEN:1}) ; save ${EXTEN} with \* chopped off to ${xtn}
exten => _\*10[0-1],n,Goto(queueLoginLogout,member_check,1) ; check if already logged into a queue

```

We save the value of ${EXTEN:1} to the 'xtn' channel variable so we don't need to keep typing the complicated pattern match.

Now we move into the meat of our login/out dialplan inside the [queueLoginLogout] context.

The first section is initializing some variables that we need throughout the member_check extension such as the name of the queue, the members currently logged into the queue, and the current device peer name (i.e. SIP/0004f2040001).

```
; ### Login or Logout a Queue Member
[queueLoginLogout]
exten => member_check,1,Verbose(2,Logging queue member in or out of the request queue)
exten => member_check,n,Set(thisQueue=${GLOBAL(QUEUE_${xtn})}) ; assign queue name to a variable
exten => member_check,n,Set(queueMembers=${QUEUE_MEMBER_LIST(${thisQueue})}) ; assign list of logged in members of thisQueue to
 ; a variable (comma separated)
exten => member_check,n,Set(thisActiveMember=SIP/${CHANNEL(peername)}) ; initialize 'thisActiveMember' as current device

exten => member_check,n,GotoIf($["${queueMembers}" = ""]?q_login,1) ; short circuit to logging in if we don't have
 ; any members logged into this queue

```

At this point if there are no members currently logged into our sales queue, we then short-circuit our dialplan to go to the 'q_login' extension since there is no point in wasting cycles searching to see if we're already logged in.

The next step is to finish initializing some values we need within the While() loop that we'll use to check if we're already logged into the queue. We set our ${field} variable to 1, which will be used as the field number offset in the CUT() function.

```
; Initialize some values we'll use in the While() loop
exten => member_check,n,Set(field=1) ; start our field counter at one
exten => member_check,n,Set(logged_in=0) ; initialize 'logged_in' to "not logged in"
exten => member_check,n,Set(thisQueueMember=${CUT(queueMembers,\,,${field})}) ; initialize 'thisQueueMember' with the value in the
 ; first field of the comma-separated list

```

Now we get to enter our While() loop to determine if we're already logged in.

```
; Enter our loop to check if our member is already logged into this queue
exten => member_check,n,While($[${EXISTS(${thisQueueMember})}]) ; while we have a queue member...

```

This is where we check to see if the member at this position of the list is the same as the device we're calling from. If it doesn't match, then we go to the 'check_next' priority label (where we increase our ${field} counter variable). If it does match, then we continue on in the dialplan.

```
exten => member_check,n,GotoIf($["${thisQueueMember}" != "${thisActiveMember}"]?check_next) ; if 'thisQueueMember' is not the
 ; same as our active peer, then
 ; check the next in the list of
 ; logged in queue members

```

If we continued on in the dialplan, then we set the ${logged_in} channel variable to '1' which represents we're already logged into this queue. We then exit the While() loop with the ExitWhile() dialplan application.

```
exten => member_check,n,Set(logged_in=1) ; if we got here, set as logged in
exten => member_check,n,ExitWhile() ; then exit our loop

```

If we didn't match this peer name in the list, then we increase our ${field} counter variable by one, update the ${thisQueueMember} channel variable and then move back to the top of the loop for another round of checks.

```
exten => member_check,n(check_next),Set(field=$[${field} + 1]) ; if we got here, increase counter
exten => member_check,n,Set(thisQueueMember=${CUT(queueMembers,\,,${field})}) ; get next member in the list
exten => member_check,n,EndWhile() ; ...end of our loop

```

And once we exit our loop, we determine whether we need to log our device in or out of the queue.

```
; if not logged in, then login to this queue, otherwise, logout
exten => member_check,n,GotoIf($[${logged_in} = 0]?q_login,1:q_logout,1) ; if not logged in, then login, otherwise, logout

```

The following two extensions are used to either log the device in or out of the queue. We use the AddQueueMember() and RemovQueueMember() applications to login or logout the device from the queue.

The first two arguments for AddQueueMember() and RemoveQueueMember() are 'queue' and 'device'. There are additional arguments we can pass, and you can check those out with 'core show application AddQueueMember' and 'core show application RemoveQueueMember()'.

```
; ### Login queue member ###
exten => q_login,1,Verbose(2,Logging ${thisActiveMember} into the ${thisQueue} queue)
exten => q_login,n,AddQueueMember(${thisQueue},${thisActiveMember}) ; login our active device to the queue 
 ; requested
exten => q_login,n,Playback(silence/1) ; answer the channel by playing one second of silence

; If the member was added to the queue successfully, then playback "Agent logged in", otherwise, state an error occurred
exten => q_login,n,ExecIf($["${AQMSTATUS}" = "ADDED"]?Playback(agent-loginok):Playback(an-error-has-occurred))
exten => q_login,n,Hangup()


; ### Logout queue member ###
exten => q_logout,1,Verbose(2,Logging ${thisActiveMember} out of ${thisQueue} queue)
exten => q_logout,n,RemoveQueueMember(${thisQueue},${thisActiveMember})
exten => q_logout,n,Playback(silence/1)
exten => q_logout,n,ExecIf($["${RQMSTATUS}" = "REMOVED"]?Playback(agent-loggedoff):Playback(an-error-has-occurred))
exten => q_logout,n,Hangup()

```

And that's it! Give it a shot and you should see console output similar to the following which will login and logout your queue members to the queues you've configured.

You can see there are already a couple of queue members logged into the sales queue.

```
\*CLI> queue show sales
sales has 0 calls (max unlimited) in 'rrmemory' strategy (3s holdtime, 4s talktime), W:0, C:2, A:1, SL:0.0% within 0s
 Members: 
 SIP/0004f2040001 (dynamic) (Not in use) has taken no calls yet
 SIP/0004f2040002 (dynamic) (Not in use) has taken no calls yet
 No Callers

```

Then we dial \*100 to logout the active device from the sales queue.

```
\*CLI> == Using SIP RTP CoS mark 5
 -- Executing [\*100@devices:1] Set("SIP/0004f2040001-00000012", "xtn=100") in new stack
 -- Executing [\*100@devices:2] Goto("SIP/0004f2040001-00000012", "queueLoginLogout,member_check,1") in new stack
 -- Goto (queueLoginLogout,member_check,1)
 -- Executing [member_check@queueLoginLogout:1] Verbose("SIP/0004f2040001-00000012", "2,Logging queue member in or out of the request queue") in new stack
 == Logging queue member in or out of the request queue
 -- Executing [member_check@queueLoginLogout:2] Set("SIP/0004f2040001-00000012", "thisQueue=sales") in new stack
 -- Executing [member_check@queueLoginLogout:3] Set("SIP/0004f2040001-00000012", "queueMembers=SIP/0004f2040001,SIP/0004f2040002") in new stack
 -- Executing [member_check@queueLoginLogout:4] Set("SIP/0004f2040001-00000012", "thisActiveMember=SIP/0004f2040001") in new stack
 -- Executing [member_check@queueLoginLogout:5] GotoIf("SIP/0004f2040001-00000012", "0?q_login,1") in new stack
 -- Executing [member_check@queueLoginLogout:6] Set("SIP/0004f2040001-00000012", "field=1") in new stack
 -- Executing [member_check@queueLoginLogout:7] Set("SIP/0004f2040001-00000012", "logged_in=0") in new stack
 -- Executing [member_check@queueLoginLogout:8] Set("SIP/0004f2040001-00000012", "thisQueueMember=SIP/0004f2040001") in new stack
 -- Executing [member_check@queueLoginLogout:9] While("SIP/0004f2040001-00000012", "1") in new stack
 -- Executing [member_check@queueLoginLogout:10] GotoIf("SIP/0004f2040001-00000012", "0?check_next") in new stack
 -- Executing [member_check@queueLoginLogout:11] Set("SIP/0004f2040001-00000012", "logged_in=1") in new stack
 -- Executing [member_check@queueLoginLogout:12] ExitWhile("SIP/0004f2040001-00000012", "") in new stack
 -- Jumping to priority 15
 -- Executing [member_check@queueLoginLogout:16] GotoIf("SIP/0004f2040001-00000012", "0?q_login,1:q_logout,1") in new stack
 -- Goto (queueLoginLogout,q_logout,1)
 -- Executing [q_logout@queueLoginLogout:1] Verbose("SIP/0004f2040001-00000012", "2,Logging SIP/0004f2040001 out of sales queue") in new stack
 == Logging SIP/0004f2040001 out of sales queue
 -- Executing [q_logout@queueLoginLogout:2] RemoveQueueMember("SIP/0004f2040001-00000012", "sales,SIP/0004f2040001") in new stack
[Nov 12 12:08:51] NOTICE[11582]: app_queue.c:4842 rqm_exec: Removed interface 'SIP/0004f2040001' from queue 'sales'
 -- Executing [q_logout@queueLoginLogout:3] Playback("SIP/0004f2040001-00000012", "silence/1") in new stack
 -- <SIP/0004f2040001-00000012> Playing 'silence/1.slin' (language 'en')
 -- Executing [q_logout@queueLoginLogout:4] ExecIf("SIP/0004f2040001-00000012", "1?Playback(agent-loggedoff):Playback(an-error-has-occurred)") in new stack
 -- <SIP/0004f2040001-00000012> Playing 'agent-loggedoff.slin' (language 'en')
 -- Executing [q_logout@queueLoginLogout:5] Hangup("SIP/0004f2040001-00000012", "") in new stack
 == Spawn extension (queueLoginLogout, q_logout, 5) exited non-zero on 'SIP/0004f2040001-00000012'

```

And we can see that the device we loggd out by running 'queue show sales'.

```
\*CLI> queue show sales
sales has 0 calls (max unlimited) in 'rrmemory' strategy (3s holdtime, 4s talktime), W:0, C:2, A:1, SL:0.0% within 0s
 Members: 
 SIP/0004f2040002 (dynamic) (Not in use) has taken no calls yet
 No Callers

```

##### Pausing and Unpausing Members of Queues

Once we have our queue members logged in, it is inevitable that they will want to pause themselves during breaks, and other short periods of inactivity. To do this we can utilize the 'queue pause' and 'queue unpause' CLI commands.

We have two devices logged into the sales queue as we can see with the 'queue show sales' CLI command.

```
\*CLI> queue show sales
sales has 0 calls (max unlimited) in 'rrmemory' strategy (0s holdtime, 0s talktime), W:0, C:0, A:0, SL:0.0% within 0s
 Members: 
 SIP/0004f2040002 (dynamic) (Not in use) has taken no calls yet
 SIP/0004f2040001 (dynamic) (Not in use) has taken no calls yet
 No Callers

```

We can then pause our devices with 'queue pause' which has the following format.

```
Usage: queue {pause|unpause} member <member> [queue <queue> [reason <reason>]]
 Pause or unpause a queue member. Not specifying a particular queue
 will pause or unpause a member across all queues to which the member
 belongs.

```

Lets pause device 0004f2040001 in the sales queue by executing the following.

```
\*CLI> queue pause member SIP/0004f2040001 queue sales
paused interface 'SIP/0004f2040001' in queue 'sales' for reason 'lunch'

```

And we can see they are paused with 'queue show sales'.

```
\*CLI> queue show sales
sales has 0 calls (max unlimited) in 'rrmemory' strategy (0s holdtime, 0s talktime), W:0, C:0, A:0, SL:0.0% within 0s
 Members: 
 SIP/0004f2040002 (dynamic) (Not in use) has taken no calls yet
 SIP/0004f2040001 (dynamic) (paused) (Not in use) has taken no calls yet
 No Callers

```

At this point the queue member will no longer receive calls from the system. We can unpause them with the CLI command 'queue unpause member'.

```
\*CLI> queue unpause member SIP/0004f2040001 queue sales 
unpaused interface 'SIP/0004f2040001' in queue 'sales'

```

And if you don't specify a queue, it will pause or unpause from all queues.

```
\*CLI> queue pause member SIP/0004f2040001
paused interface 'SIP/0004f2040001'

```

Of course we want to allow the agents to pause and unpause themselves from their devices, so we need to create an extension and some dialplan logic for that to happen.

Below we've created the pattern patch _**0[01]! which will match on \*00 and \*01, and will \*also** match with zero or more digits following it, such as the queue extension number.

So if we want to pause ourselves in all queues, we can dial \*00; unpausing can be done with \*01. But if our agents just need to pause or unpause themselves from a single queue, then we will also accept \*00100 to pause in queue 100 (sales), or we can unpause ourselves from sales with \*01100.

```
extensions.conf
---------------

; Allow queue members to pause and unpause themselves from all queues, or an individual queue.
;
; _\*0[01]! pattern match will match on \*00 and \*01 plus 0 or more digits.
exten => _\*0[01]!,1,Verbose(2,Pausing or unpausing queue member from one or more queues)
exten => _\*0[01]!,n,Set(xtn=${EXTEN:3}) ; save the queue extension to 'xtn'
exten => _\*0[01]!,n,Set(thisQueue=${GLOBAL(QUEUE_${xtn})}) ; get the queue name if available
exten => _\*0[01]!,n,GotoIf($[${ISNULL(${thisQueue})} & ${EXISTS(${xtn})}]?invalid_queue,1) ; if 'thisQueue' is blank and the
 ; the agent dialed a queue exten,
 ; we will tell them it's invalid

```

The following line will determine if we're trying to pause or unpause. This is done by taking the value dialed (e.g. \*00100) and chopping off the first 2 digits which leaves us with 0100, and then the :1 will return the next digit, which in this case is '0' that we're using to signify that the queue member wants to be paused (in queue 100).

So we're doing the following with our EXTEN variable.

```
 ${EXTEN:2:1}
offset ^ ^ length

```

Which causes the following.

```
 \*00100
 ^^ offset these characters

 \*00100
 ^ then return a digit length of one, which is digit 0

```
```
exten => _\*0[01]!,n,GotoIf($[${EXTEN:2:1} = 0]?pause,1:unpause,1) ; determine if they wanted to pause
 ; or to unpause.

```

The following two extensions, pause & unpause, are used for pausing and unpausing our extension from the queue(s). We use the PauseQueueMember() and UnpauseQueueMember() dialplan applications which accept the queue name (optional) and the queue member name. If the queue name is not provided, then it is assumed we want to pause or unpause from all logged in queues.

```
; Unpause ourselves from one or more queues
exten => unpause,1,NoOp()
exten => unpause,n,UnpauseQueueMember(${thisQueue},SIP/${CHANNEL(peername)}) ; if 'thisQueue' is populated we'll pause in
 ; that queue, otherwise, we'll unpause in
 ; in all queues

```

Once we've unpaused ourselves, we use GoSub() to perform some common dialplan logic that is used for pausing and unpausing. We pass three arguments to the subroutine:

* variable name that contains the result of our operation
* the value we're expecting to get back if successful
* the filename to play

```
exten => unpause,n,GoSub(changePauseStatus,start,1(UPQMSTATUS,UNPAUSED,available)) ; use the changePauseStatus subroutine and
 ; pass the values for: variable to check,
 ; value to check for, and file to play
exten => unpause,n,Hangup()

```

And the same method is done for pausing.

```
; Pause ourselves in one or more queues
exten => pause,1,NoOp()
exten => pause,n,PauseQueueMember(${thisQueue},SIP/${CHANNEL(peername)})
exten => pause,n,GoSub(changePauseStatus,start,1(PQMSTATUS,PAUSED,unavailable))
exten => pause,n,Hangup()

```

Lets explore what happens in the subroutine we're using for pausing and unpausing.

```
; ### Subroutine we use to check pausing and unpausing status ###
[changePauseStatus]
; ARG1: variable name to check, such as PQMSTATUS and UPQMSTATUS (PauseQueueMemberStatus / UnpauseQueueMemberStatus)
; ARG2: value to check for, such as PAUSED or UNPAUSED
; ARG3: file to play back if our variable value matched the value to check for
;
exten => start,1,NoOp()
exten => start,n,Playback(silence/1) ; answer line with silence

```

The following line is probably the most complex. We're using the IF() function inside the Playback() application which determines which file to playback to the user.

Those three values we passed in from the pause and unpause extensions could have been something like:

* ARG1 – PQMSTATUS
* ARG2 – PAUSED
* ARG3 – unavailable

So when expanded, we'd end up with the following inside the IF() function.

```bash title=" " linenums="1"
$["${PQMSTATUS}" = "PAUSED"]?unavailable:not-yet-connected

```

${PQMSTATUS} would then be expanded further to contain the status of our PauseQueueMember() dialplan application, which could either be PAUSED or NOTFOUND. So if ${PQMSTATUS} returned PAUSED, then it would match what we're looking to match on, and we'd then return 'unavailable' to Playback() that would tell the user they are now unavailable.

Otherwise, we'd get back a message saying "not yet connected" to indicate they are likely not logged into the queue they are attempting to change status in.

```
; Please note that ${ARG1} is wrapped in ${ } in order to expand the value of ${ARG1} into
; the variable we want to retrieve the value from, i.e. ${${ARG1}} turns into ${PQMSTATUS}
exten => start,n,Playback(${IF($["${${ARG1}}" = "${ARG2}"]?${ARG3}:not-yet-connected)}) ; check if value of variable
 ; matches the value we're looking
 ; for and playback the file we want
 ; to play if it does

```

If ${xtn} is null, then we just go to the end of the subroutine, but if it isn't then we will play back "in the queue" followed by the queue extension number indicating which queue they were (un)paused from.

```
exten => start,n,GotoIf($[${ISNULL(${xtn})}]?end) ; if ${xtn} is null, then just Return()
exten => start,n,Playback(in-the-queue) ; if not null, then playback "in the queue"
exten => start,n,SayNumber(${xtn}) ; and the queue number that we (un)paused from
exten => start,n(end),Return() ; return from were we came

```

##### Queue Variables

Sometimes you may want to retrieve information about a particular queue's state. You can do this by using [Queue Variables](/latest_api/API_Documentation/Dialplan_Functions/QUEUE_VARIABLES), and its associated functions. For instance here is a contrived example of how to print a couple variables for the "thisQueue":

```
exten => show_variables,1,NoOp()
 same => n,Noop(${QUEUE_VARIABLES(thisQueue)})
 same => n,Verbose(0,strategy = ${QUEUESTRATEGY})
 same => n,Verbose(0,calls = ${QUEUECALLS})
 same => n,Hangup()

```

Note, QUEUE_VARIABLES needs to be called with a valid queue name, and prior to calling the other queue variable functions in order to ensure retrieval of the correctly associated values for a given queue.

##### Conclusion

You should now have a simple system that permits you to login and out of queues you create in queues.conf, and to allow queue members to pause themselves within one or more queues. There are a lot of dialplan concepts utilized in this  


A good start is the doc/ subdirectory of the Asterisk sources, or the various configuration samples files located in the configs/ subdirectory of your Asterisk source code.

