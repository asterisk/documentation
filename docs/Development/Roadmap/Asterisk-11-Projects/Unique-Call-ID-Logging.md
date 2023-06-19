---
title: Unique Call-ID Logging
pageid: 19008294
---


Overview
========


Unique Call-ID Logging is meant to make log messages easily understood to relate with a particular call in Asterisk. This concept was branched off from Clod Patry's CLI filtering patch. The CLI filtering patch used thread storage to link threads to channels. If filters were set in CLI, channels bound to the thread would be examined to see if they are part of a call involved with some field specified on the channel (channel name, accountcode, or callerid num). That patch has been determined to have significant problems related to locking, which if resolved could potentially result in a heavy performance hit with logging, so some concepts from it were split off in order to design this feature, which basically just adds a uniquely identifying value for the call-id to all log messages which can be identified as relating to a certain call.


Table of Contents
=================


Specification
=============


A <call-id> is a unique identifier that is associated with a complete call and the elements that compose it. Logs that could benefit from this <call-id> can occur both before any channels for that call are created, and after all channels in a call are destroyed. The <call-id> is bound to any channels that are created by something associated with the <call-id>. Only log statements that can be associated with a call are tagged with a <call\_id>; some log statements related to a call can occur before a <call-id> can be created (it isn't always immediately known when one will be needed). In a typical Asterisk log file, a call's log messages can look something like the following:




---

  
log  


```

css[Mar 7 00:00:00] VERBOSE[6165] netsock2.c: == Using SIP RTP CoS mark 5
﻿[Mar 7 00:00:00] DEBUG[6165] call\_identifier.c: <function stuff>: CALL\_ID [C000001] created by thread.
[Mar 7 00:00:00] DEBUG[6167][C00000001] call\_identifier.c: <function stuff>: CALL\_ID [C000001] bound to thread.
[Mar 7 00:00:00] VERBOSE[6167][C00000001] pbx.c: -- Executing [023@sipphones:1] Dial("SIP/123-00000000", "SIP/GoldFishGang") in new stack
[Mar 7 00:00:00] VERBOSE[6167][C00000001] netsock2.c: == Using SIP RTP CoS mark 5
...
[Mar 7 00:00:00] VERBOSE[6167][C00000001] app\_dial.c: == Everyone is busy/congested at this time (1:0/0/1)
[Mar 7 00:00:00] VERBOSE[6167][C00000001] pbx.c: -- Executing [023@sipphones:2] NoOp("SIP/123-00000000", "Oh wait, that isn't a thing.") in new stack
[Mar 7 00:00:00] VERBOSE[6167][C00000001] pbx.c: -- Auto fallthrough, channel 'SIP/123-00000000' status is 'CHANUNAVAIL'
[Mar 7 00:00:00] DEBUG[6167][C00000001] call\_identifier.c: <function stuff>: Call ID [000001] dereffed and destroyed by thread [6167]

```



---


This case represents a simple scenario where a a SIP packet is received which starts a new call. Before a channel can be created, The SIP channel driver anticipates a new call will be started and creates a <call-id> related to that call. The call id is referenced by the pbx thread created for that channel. [000001].


Many users use Asterisk from the perspective of the CLI. By default, verbose messages in CLI don't display the call-id file. In order to accommodate these users without forcing them to look at log files, a cli command to enable the <call-id> to be displayed with the verbose message will need to be added (which could be placed in startup\_commands).




---

  
  


```

nonecore set verbose\_callids on = yes

```



---


This would effectively change the display of a verbose message on CLI from:




---

  
  


```

css-- Executing [023@sipphones:2] NoOp("SIP/123-00000000", "Oh wait, that isn't a thing.") in new stack

```



---


to:




---

  
  


```

css-- [C00000001] Executing [023@sipphones:2] NoOp("SIP/123-00000000", "Oh wait, that isn't a thing.") in new stack

```



---


Having call identifiers in log messages like this could greatly help users to visually parse what is happening with their calls and could also be helpful in identifying problems from the perspective of support or development.


A callid string should always appear as an 8-digit hexadecimal number in the following format: [C########]


Design
======


The <call-id> is a refcounted object that stores a uniquely identifying value


Call-ID struct
--------------


The <call-id> struct should be stored in an ao2 container for reference counting. All channel threads should reference one and only one call-id in thread storage and for the lifetime of the thread, they will hold one reference. Since the call-id is stored in thread storage for the channel thread, it should persist through masquerades. The channel tech itself might need to reference the <call-id> so that it can be linked to the call if it becomes a zombie.  Any applications that produce monitor threads (like audio hooks) that attach to a call will also need to add a reference to the call-id in thread storage belonging to the newly created thread. Theads that hold call-id's will need to give up those references when they die.




---

  
logger.h  


```

Eclipsecpp
struct ast\_callid {
 int call\_identifier; /\* Numerical value of the call displayed in the logs \*/
};

```



---


Call-ID API
-----------




---

  
  


```

cpp
/\*!
 \* \brief factory function to create a new uniquely identifying callid.
 \*
 \* \retval ast\_callid struct pointer containing the call id (and other information if that route is taken)
 \*
 \* \note The newly created callid will be referenced upon creation and this function should be
 \* paired with a call to ast\_callid\_deref()
 \*/
struct ast\_callid \*ast\_create\_callid();

/\*!
 \* \brief Increase callid reference count
 \*
 \* \param c the ast\_callid
 \*
 \* \retval c always
 \*/
#define ast\_callid\_ref(c) ({ ao2\_ref(c, +1); (c); )}

/\*!
 \* \brief Decrease callid reference count
 \*
 \* \param c the ast\_callid
 \*
 \* \retval NULL always
 \*/
#define ast\_callid\_unref(c) ({ ao2\_ref(c, -1); (struct ast\_channel \*) (NULL); )}

/\*!
 \* \brief Adds a known callid to thread storage of the calling thread
 \*
 \* \retval -1 - failure to allocate thread storage
 \* \retval 0 - success
 \* \retval 1 - failure due to thread already being bound to a callid
 \*/
int ast\_callid\_threadassoc\_add(struct ast\_callid \*callid);


```



---


Logging - Thread storage and ast\_log\_callid
---------------------------------------------


In order to avoid having to modify every log call in Asterisk, Clod's patch used thread storage to store a channel pointer. Since it was stored in thread storage, it didn't need to be directly passed to the function and could just be checked at the time of log output for the existence of relevant data. In this way, CLI filtering could log messages between different calls without any new arguments to ast\_log. A similar method could be used to bind threads to <call-id>s.


This alone may not be enough to handle all logs related to specific calls though. Some threads that get involved with specific calls change which call they are working on frequently (notably channel drivers) and in these cases, the proper solution might be to introduce a secondary ast\_log function which includes either a reference to the <call-id> being worked with or else just the value of the <call-id>


**ast\_log\_callid(struct call\_id \*id,** ***args from ast\_log*****) -** Acts as ast\_log currently does, except if call\_id is not NULL, then [CALL\_ID] will be attached after the thread ID as shown above for written log statements.  For verbose logs in CLI, it will not be displayed  



    **ast\_log(*****args from ast\_log*****)** **-** Acts as ast\_log currently does, except it checks thread storage to see if the thread calling ast\_log is bound to a callid. If it is, then the callid is passed to ast\_log\_callid.  If not, a NULL value is passed for call\_id instead.


ast\_log will become a helper function to ast\_log\_callid.


Handling and Spreading Call IDs - Channel Drivers, Channel/PBX threads, and Application Threads
-----------------------------------------------------------------------------------------------


Each call starts with a channel driver responsible for creating channels. In the case of SIP for example, the channel driver has a thread which reads incoming SIP messages, and if one of these SIP messages happens to be requesting a call of some sort, then Asterisk will eventually create a channel thread for it. There may be some relevant log messages between the time a channel driver has discerned that a new call is taking place and when it has actually created the channel (and PBX thread) associated with it. Since the lifetime of logs related to a call starts before the birth of any PBX threads related to the call (and possibly also after the death of the call), each individual channel driver will be responsible for creating <call-ids> and linking them to the channels and pbx threads that need them.


In the case of threads that interact with multiple channels from multiple calls, thread storage can't be used to handle the log messages. For these types of situations, the <call-ids> will need an additional reference stored in channels that are part of the call and threads working with these channels will have to read the <call-ids> from each channel before processing logs with ast\_log\_callid.


Also, certain applications such as mixmonitor will create threads which act within the call, but are slightly disjoint from the call itself. The tentative approach for dealing with these threads is to copy the <call-id> in thread storage from the threads responsible for creating them to to the created threads by manipulating ast\_pthread\_create (and/or its variants).


Running through a simple example call with an audiohook
-------------------------------------------------------


1. An invite request comes in through the SIP channel driver.  The driver handles the request in the handle\_request\_invite function and determines that the dialog is going to create a new channel.
2. handle\_request\_invite determines the call to be a 'first invitation' and creates a new ast\_callid with ast\_create\_callid() which it will store in a local variable. Some log messages
3. handle\_reqeust\_invite creates a new SIP channel with a reference to the ast\_callid. As part of the channel thread creation process, the call-id is put into thread storage and the ao2 object support it gets a ref bump (2).
4. As handle\_request\_invite is finishing, the channel driver's network monitor thread derefs the ast\_callid. (1)
5. The new channel starts going through pbx on the following extension:



---

  
  


```

exten => s,1,NoOp(example no op message)
exten => s,2,MixMonitor(mixfile.wav)
exten => s,3,Dial(SIP/examplepeer)

```



---
6. The NoOp gets verbose logged to CLI. In the CLI, nothing special is visible, but since ast\_log is called with a thread containing an ast\_callid in thread storage, so ast\_log checks the thread
7. MixMonitor is reached. Verbose logging occurs as with NoOp It creates a monitor\_thread which will be part of the call. When the new thread is created, the pbx thread sends the call-id to it for
8. Dial is reached. Verbose logging occurs as with NoOp, The thread enters the channel .call function (sip\_call)
9. Since sip\_call is occuring on the same thread, all ast\_log messages should automatically get their <call-id> logged properly.
10. Nothing too fancy happens during the call, and 20 seconds later, someone hangs up.
11. During the hangup process, the channel thread dies. As part of this dying process, the ast\_callid it is associated with is dereffed (1).
12. The MixMonitor thread closes out since the channels it was interacting with are all dead, so its reference to the ast\_callid is also dereffed (0). Since the refcount hits zero, the ast\_callid is freed.


This is a simple example and some details may be incomplete (or even incorrect).


Running through a simple example call with transfers
----------------------------------------------------


1. Steps 1-4 from the above occur. For the sake of the example, the user that started the call will be called SIP/examplecaller.
2. The new channel starts going through pbx on the following extension:



---

  
  


```

exten => s,1,Dial(SIP/examplepeer)

```



---
3. Dial is reached and is verbose logged. The thread enters the channel .call function (sip\_call)
4. Nothing too special occurs until SIP/examplecaller transfers SIP/examplepeer to SIP/examplepeer2. This means the channel that started the call thread is going to become a zombie. The call will go on though, the thread will just receive a new channel. The <call-id> can probably just stay in as is. However, the zombie will no longer be a part of the thread, so it will need to reference
5. Zombie cleanup events take place using ast\_log\_callid to attach the <call-id> stamp to the logs.
6. The zombie finally dies. During that process, it ditches a reference to <call-id> (1).
7. After some time, examplepeer gets bored of talking to examplepeer2 and hangs up. The channel thread gives up the last reference (0) and dies. When the reference count hit zero, the call-id was disposed of.


Implmentation Phases
====================


Phase I - Create relevant data structures and API
-------------------------------------------------


Develop a simple prototype that handles the following:


1. Implement <call-id> structure and factory. Bind <call-id> pointers to newly created channel threads.
2. Modify logging to read thread storage so that channel thread log messages include the <call-id> stamp.


* Phase I is complete as of 14 Mar 2012 <http://svn.asterisk.org/svn/asterisk/team/jrose/call_identifiers> r359343


Phase II - Handle application threads and other small improvements (in-progress)
--------------------------------------------------------------------------------


Improve from phase I and add:


1. Spread references to ast\_callid structs to threads created by a pbx/channel thread already bound to a <call-id>.
2. Add CLI command to display <call-id> with verbose messages on CLI.


Phase III - Migrate <call-id> creation and binding to individual channel drivers
--------------------------------------------------------------------------------


1. Add logger API for ast\_log\_callid
2. Handle call-creation on a per channel-driver basis
3. Bind the callids to newly created channels.
4. Bind callids to pbx threads by using the channel callids if they are available.


Transfers
=========


Transfers are somewhat tricky when it comes to receiving callids. Since the channel drivers are deeply involved in how transfers work, differences in individual channel drivers may cause inconsistencies. As a general rule, transfers should not create new callids unless a new call occurs. For instance, in an attended transfer, a new conversation occurs between the transferrer and the person receiving the transferred call. This results in a new callid being created. Since the old call is on the old callid while the new recipient has a fresh callid, at least in the case of SIP a masquerade will occur and the transferee's original channel will be torn down and replaced with a new one containing the new callid.


As a general rule, if a call involves transfers, it may be necessary to track multiple callids based on the known transfers.

