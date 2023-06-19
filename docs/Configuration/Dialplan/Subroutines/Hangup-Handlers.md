---
title: Hangup Handlers
pageid: 20189328
---




---


**Information:**  Hangup Handlers were added in **Asterisk 11**

  



---


Overview
--------

Hangup handlers are subroutines attached to a channel that will execute when that channel hangs up. Unlike the traditional [h extension](/Handling-Special-Extensions), hangup handlers follow the channel. Thus hangup handlers are always run when a channel is hung up, regardless of where in the dialplan a channel is executing.

Multiple hangup handlers can be attached to a single channel. If multiple hangup handlers are attached to a channel, the hangup handlers will be executed in the order of most recently added first.




---


**Information: NOTES** * Please note that when the hangup handlers execute in relation to the h extension is not defined. They could execute before or after the h extension.
* Call transfers, call pickup, and call parking can result in channels on both sides of a bridge containing hangup handlers.
* Hangup handlers can be attached to any call leg using [pre-dial handlers](/Pre-Dial-Handlers).
  



---




---

**WARNING!: WARNINGS**  
* As hangup handlers are subroutines, they must be terminated with a call to [Return](/Asterisk-11-Application_Return).
* Adding a hangup handler in the h extension or during a hangup handler execution is undefined behaviour.
* As always, hangup handlers, like the h extension, need to execute quickly because they are in the hangup sequence path of the call leg. Specific channel driver protocols like ISDN and SIP may not be able to handle excessive delays completing the hangup sequence.
  



---


Dialplan Applications and Functions
-----------------------------------

All manipulation of a channel's hangup handlers are done using the [CHANNEL](/Asterisk-11-Function_CHANNEL) function. All values manipulated for hangup handlers are write-only.

### hangup\_handler\_push

Used to push a hangup handler onto a channel.




---

  
  


```

same => n,Set(CHANNEL(hangup\_handler\_push)=[[context,]exten,]priority[(arg1[,...][,argN])]);


```



---


### hangup\_handler\_pop

Used to pop a hangup handler off a channel. Optionally, a replacement hangup handler can be added to the channel.




---

  
  


```

same => n,Set(CHANNEL(hangup\_handler\_pop)=[[[context,]exten,]priority[(arg1[,...][,argN])]]);


```



---


### hangup\_handler\_wipe

Remove all hangup handlers on the channel. Optionally, a new hangup handler can be pushed onto the channel.




---

  
  


```

same => n,Set(CHANNEL(hangup\_handler\_wipe)=[[[context,]exten,]priority[(arg1[,...][,argN])]]);


```



---


### Examples

##### Adding hangup handlers to a channel

In this example, three hangup handlers are added to a channel: hdlr3, hdlr2, and hdlr1. When the channel is hung up, they will be executed in the order of most recently added first - so hdlr1 will execute first, followed by hdlr2, then hdlr3.




---

  
  


```

; Some dialplan extension
same => n,Set(CHANNEL(hangup\_handler\_push)=hdlr3,s,1(args));
same => n,Set(CHANNEL(hangup\_handler\_push)=hdlr2,s,1(args));
same => n,Set(CHANNEL(hangup\_handler\_push)=hdlr1,s,1(args));
; Continuing in some dialplan extension

[hdlr1]

exten => s,1,Verbose(0, Executed First)
same => n,Return()

[hdlr2]

exten => s,1,Verbose(0, Executed Second)
same => n,Return()

[hdlr3]

exten => s,1,Verbose(0, Executed Third)
same => n,Return()



```



---


##### Removing and replacing hangup handlers

In this example, three hangup handlers are added to a channel: hdlr3, hdlr2, and hdlr1. Using the [CHANNEL](/Asterisk-11-Function_CHANNEL) function's **hangup\_handler\_pop** value, hdlr1 is removed from the stack of hangup handlers. Then, using the **hangup\_handler\_pop** value again, hdlr2 is replaced with hdlr4. When the channel is hung up, hdlr4 will be executed, followed by hdlr3.




---

  
  


```

; Some dialplan extension
same => n,Set(CHANNEL(hangup\_handler\_push)=hdlr3,s,1(args));
same => n,Set(CHANNEL(hangup\_handler\_push)=hdlr2,s,1(args));
same => n,Set(CHANNEL(hangup\_handler\_push)=hdlr1,s,1(args));
; Remove hdlr1
same => n,Set(CHANNEL(hangup\_handler\_pop)=)
; Replace hdlr2 with hdlr4
same => n,Set(CHANNEL(hangup\_handler\_pop)=hdlr4,s,1(args));

; Continuing in some dialplan extension

[hdlr1]

exten => s,1,Verbose(0, Not Executed)
same => n,Return()

[hdlr2]

exten => s,1,Verbose(0, Not Executed)
same => n,Return()

[hdlr3]

exten => s,1,Verbose(0, Executed Second)
same => n,Return()

[hdlr4]

exten => s,1,Verbose(0, Executed First)
same => n,Return()



```



---


CLI Commands
------------




---

  
Single channel  


```

core show hanguphandlers <chan>


```



---




---

  
Output  


```

Channel Handler
<chan-name> <first handler to execute>
 <second handler to execute>
 <third handler to execute>


```



---




---

  
All channels  


```

core show hanguphandlers all


```



---




---

  
Output  


```

Channel Handler
<chan1-name> <first handler to execute>
 <second handler to execute>
 <third handler to execute>
<chan2-name> <first handler to execute>
<chan3-name> <first handler to execute>
 <second handler to execute>


```



---


