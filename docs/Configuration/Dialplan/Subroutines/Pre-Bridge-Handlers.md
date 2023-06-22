---
title: Pre-Bridge Handlers
pageid: 31097214
---

Overview
========

Pre-bridge handlers allow you to execute dialplan subroutines on a channel after the call has been initiated and the channels have been created, but before connecting the caller to the callee. Handlers for the [Dial](/Asterisk-13-Application_Dial) and [queue](/Asterisk-13-Application_Queue) applications allow both the older [**macro**](/Configuration/Dialplan/Subroutines/Macros) and the newer [**gosub**](/Configuration/Dialplan/Subroutines/Gosub) routines to be executed. These handlers are executed on the **called party** channel, after it is **answered**, but **pre-bridge** before the calling and called party are connected.

If you want to execute routinesearlier in the call lifetime then check out the [Pre-Dial Handlers](/Configuration/Dialplan/Subroutines/Pre-Dial-Handlers) section.

Pre-bridge handlers are invoked using flags or arguments for a particular dialplan application. The dialplan application help documentation within Asterisk goes into detail on the various arguments, options and flags, however we will provide some examples below. You should always check the CLI or wiki application docs for any updates.

Dial application
----------------

There are two flags for the Dial application, **M** and **U**.

### M flag

The M flag allows a [macro](/Configuration/Dialplan/Subroutines/Macros) and arguments to be specified. You must specify the macro name, leaving off the 'macro-' prefix.




---

  
  


```

M(macro[^arg[^...]])

```


The variable MACRO\_RESULT can be set with certain options inside the specified macro to determine behavior when the macro finishes. The options are documented in the [Dial application documentation](/Asterisk-13-Application_Dial).




### U flag

The U flag allows a [gosub](/Configuration/Dialplan/Subroutines/Gosub) and arguments to be specified. You must remember to call Return inside the gosub.




---

  
  


```

U(x[^arg[^...]])

```


The variable GOSUB\_RESULT can be set within certain options inside the specified gosub to determine behavior when the gosub returns. The options are documented in the [Dial application documentation](/Asterisk-13-Application_Dial).

Queue application
-----------------

The Queue application, similar to Dial, has two options for handling pre-bridge subroutines. For Queue, both arguments have the same syntax.




---

  
  


```

Queue(queuename[,options[,URL[,announceoverride[,timeout[,AGI[,macro[,gosub[,rule[,position]]]]]]]]])

```


**macro** and **gosub** can both be populated with the name of a macro or gosub routine to execute on the called party channel as described in the overview.

Examples
--------

### Example 1 - Executing a pre-bridge macro handler from Dial

BOB(6002) dials ALICE(6001) and Playback is executed from within the subroutine on the called party's channel after they answer.

Dialplan




---

  
  


```

[from-internal]
exten = 6001,1,Dial(PJSIP/ALICE,30,M(announcement))

[macro-announcement]
exten = s,1,NoOp()
 same = n,Playback(tt-weasels)
 same = n,Hangup()

```


CLI output




---

  
  


```

 -- Executing [6001@from-internal:1] Dial("PJSIP/BOB-00000014", "PJSIP/ALICE,30,M(announcement)") in new stack
 -- Called PJSIP/ALICE
 -- PJSIP/ALICE-00000015 is ringing
 -- PJSIP/ALICE-00000015 answered PJSIP/BOB-00000014
 -- Executing [s@macro-announcement:1] NoOp("PJSIP/ALICE-00000015", "") in new stack
 -- Executing [s@macro-announcement:2] Playback("PJSIP/ALICE-00000015", "tt-weasels") in new stack
 -- <PJSIP/ALICE-00000015> Playing 'tt-weasels.gsm' (language 'en')
 -- Channel PJSIP/BOB-00000014 joined 'simple\_bridge' basic-bridge <612c2313-98bf-48ce-89b1-d530b06e44d7>
 -- Channel PJSIP/ALICE-00000015 joined 'simple\_bridge' basic-bridge <612c2313-98bf-48ce-89b1-d530b06e44d7>
 -- Channel PJSIP/BOB-00000014 left 'native\_rtp' basic-bridge <612c2313-98bf-48ce-89b1-d530b06e44d7>
 -- Channel PJSIP/ALICE-00000015 left 'native\_rtp' basic-bridge <612c2313-98bf-48ce-89b1-d530b06e44d7>
 == Spawn extension (from-internal, 6001, 1) exited non-zero on 'PJSIP/BOB-00000014'

```


 

### Example 2 - Executing a pre-bridge gosub handler from Dial

ALICE(6001) dials BOB(6002) and Playback is executed from within the subroutine on the called party's channel after they answer. Notice that since this subroutine is a gosub, we need to call Return.

Dialplan




---

  
  


```

[from-internal]
exten = 6002,1,Dial(PJSIP/BOB,30,U(sub-announcement))

[sub-announcement]
exten = s,1,NoOp()
 same = n,Playback(tt-weasels)
 same = n,Return()

```


CLI output




---

  
  


```

 -- Executing [6002@from-internal:1] Dial("PJSIP/ALICE-00000016", "PJSIP/BOB,30,U(sub-announcement)") in new stack
 -- Called PJSIP/BOB
 -- PJSIP/BOB-00000017 is ringing
 -- PJSIP/BOB-00000017 answered PJSIP/ALICE-00000016
 -- PJSIP/BOB-00000017 Internal Gosub(sub-announcement,s,1) start
 -- Executing [s@sub-announcement:1] NoOp("PJSIP/BOB-00000017", "") in new stack
 -- Executing [s@sub-announcement:2] Playback("PJSIP/BOB-00000017", "tt-weasels") in new stack
 -- <PJSIP/BOB-00000017> Playing 'tt-weasels.gsm' (language 'en')
 -- Executing [s@sub-announcement:3] Return("PJSIP/BOB-00000017", "") in new stack
 == Spawn extension (from-internal, , 1) exited non-zero on 'PJSIP/BOB-00000017'
 -- PJSIP/BOB-00000017 Internal Gosub(sub-announcement,s,1) complete GOSUB\_RETVAL=
 -- Channel PJSIP/ALICE-00000016 joined 'simple\_bridge' basic-bridge <16e76a40-4a24-441d-a2b2-5c9ddfb21d7a>
 -- Channel PJSIP/BOB-00000017 joined 'simple\_bridge' basic-bridge <16e76a40-4a24-441d-a2b2-5c9ddfb21d7a>
 -- Channel PJSIP/BOB-00000017 left 'native\_rtp' basic-bridge <16e76a40-4a24-441d-a2b2-5c9ddfb21d7a>
 -- Channel PJSIP/ALICE-00000016 left 'native\_rtp' basic-bridge <16e76a40-4a24-441d-a2b2-5c9ddfb21d7a>
 == Spawn extension (from-internal, 6002, 1) exited non-zero on 'PJSIP/ALICE-00000016'

```


### Example 3 - Executing a pre-bridge gosub handler from Queue

ALICE(6001) dials Queue 'sales' where BOB(6002) is a member. Once BOB answers the queue call, the Playback is executed from within the gosub.

Dialplan




---

  
  


```

[sub-announcement]
exten = s,1,NoOp()
 same = n,Playback(tt-weasels)
 same = n,Return()

[queues]
exten => 7002,1,Verbose(2,${CALLERID(all)} entering the sales queue)
same => n,Queue(sales,,,,,,,sub-announcement)
same => n,Hangup()

```


CLI output




---

  
  


```

 -- Executing [7002@from-internal:1] Verbose("PJSIP/ALICE-00000009", "2,"Alice" <ALICE> entering the sales queue") in new stack
 == "Alice" <ALICE> entering the sales queue
 -- Executing [7002@from-internal:2] Queue("PJSIP/ALICE-00000009", "sales,,,,,,,sub-announcement") in new stack
 -- Started music on hold, class 'default', on channel 'PJSIP/ALICE-00000009'
 -- Called PJSIP/BOB
 -- PJSIP/BOB-0000000a is ringing
 > 0x7f74d4039840 -- Probation passed - setting RTP source address to 10.24.18.138:4042
 -- PJSIP/BOB-0000000a answered PJSIP/ALICE-00000009
 -- Stopped music on hold on PJSIP/ALICE-00000009
 -- PJSIP/BOB-0000000a Internal Gosub(sub-announcement,s,1) start
 -- Executing [s@sub-announcement:1] NoOp("PJSIP/BOB-0000000a", "") in new stack
 -- Executing [s@sub-announcement:2] Playback("PJSIP/BOB-0000000a", "tt-weasels") in new stack
 -- <PJSIP/BOB-0000000a> Playing 'tt-weasels.gsm' (language 'en')
 -- Executing [s@sub-announcement:3] Return("PJSIP/BOB-0000000a", "") in new stack
 == Spawn extension (from-internal, 7002, 1) exited non-zero on 'PJSIP/BOB-0000000a'
 -- PJSIP/BOB-0000000a Internal Gosub(sub-announcement,s,1) complete GOSUB\_RETVAL=
 -- Channel PJSIP/ALICE-00000009 joined 'simple\_bridge' basic-bridge <cbc54ed6-1f51-4b10-be99-4994f52d851f>
 -- Channel PJSIP/BOB-0000000a joined 'simple\_bridge' basic-bridge <cbc54ed6-1f51-4b10-be99-4994f52d851f>
 > Bridge cbc54ed6-1f51-4b10-be99-4994f52d851f: switching from simple\_bridge technology to native\_rtp
 > Remotely bridged 'PJSIP/BOB-0000000a' and 'PJSIP/ALICE-00000009' - media will flow directly between them
 > Remotely bridged 'PJSIP/BOB-0000000a' and 'PJSIP/ALICE-00000009' - media will flow directly between them
 > 0x7f74d400c620 -- Probation passed - setting RTP source address to 10.24.18.16:4040
 -- Channel PJSIP/BOB-0000000a left 'native\_rtp' basic-bridge <cbc54ed6-1f51-4b10-be99-4994f52d851f>
 -- Channel PJSIP/ALICE-00000009 left 'native\_rtp' basic-bridge <cbc54ed6-1f51-4b10-be99-4994f52d851f>
 == Spawn extension (from-internal, 7002, 2) exited non-zero on 'PJSIP/ALICE-00000009'

```


### Example 4 - Executing a pre-bridge macro handler from Queue

BOB(6002) calls the queue 'support' where ALICE(6001) is a member. Once ALICE answers the queue call, the Playback is executed from within the macro.

Dialplan




---

  
  


```

[macro-announcement]
exten = s,1,NoOp()
 same = n,Playback(tt-weasels)

[queues]
exten => 7001,1,Verbose(2,${CALLERID(all)} entering the support queue)
same => n,Queue(support,,,,,,announcement)
same => n,Hangup()

```


CLI output




---

  
  


```

 -- Executing [7001@from-internal:1] Verbose("PJSIP/BOB-00000004", "2,"Bob" <BOB> entering the support queue") in new stack
 == "Bob" <BOB> entering the support queue
 -- Executing [7001@from-internal:2] Queue("PJSIP/BOB-00000004", "support,,,,,,announcement") in new stack
 -- Started music on hold, class 'default', on channel 'PJSIP/BOB-00000004'
 -- Called PJSIP/ALICE
 -- PJSIP/ALICE-00000005 is ringing
 > 0x7f8450039d40 -- Probation passed - setting RTP source address to 10.24.18.16:4048
 -- PJSIP/ALICE-00000005 answered PJSIP/BOB-00000004
 -- Stopped music on hold on PJSIP/BOB-00000004
 -- Executing [s@macro-announcement:1] NoOp("PJSIP/ALICE-00000005", "") in new stack
 -- Executing [s@macro-announcement:2] Playback("PJSIP/ALICE-00000005", "tt-weasels") in new stack
 -- <PJSIP/ALICE-00000005> Playing 'tt-weasels.gsm' (language 'en')
 -- Channel PJSIP/BOB-00000004 joined 'simple\_bridge' basic-bridge <8283212f-b12d-4571-9653-0c8484e88980>
 -- Channel PJSIP/ALICE-00000005 joined 'simple\_bridge' basic-bridge <8283212f-b12d-4571-9653-0c8484e88980>
 > Bridge 8283212f-b12d-4571-9653-0c8484e88980: switching from simple\_bridge technology to native\_rtp
 > Remotely bridged 'PJSIP/ALICE-00000005' and 'PJSIP/BOB-00000004' - media will flow directly between them
 > Remotely bridged 'PJSIP/ALICE-00000005' and 'PJSIP/BOB-00000004' - media will flow directly between them
 > 0x7f84500145d0 -- Probation passed - setting RTP source address to 10.24.18.138:4050
 -- Channel PJSIP/ALICE-00000005 left 'native\_rtp' basic-bridge <8283212f-b12d-4571-9653-0c8484e88980>
 -- Channel PJSIP/BOB-00000004 left 'native\_rtp' basic-bridge <8283212f-b12d-4571-9653-0c8484e88980>
 == Spawn extension (from-internal, 7001, 2) exited non-zero on 'PJSIP/BOB-00000004'

```


