---
title: Pre-Dial Handlers
pageid: 20189344
---




---


**Information:**  Pre-Dial Handlers were added in **Asterisk 11**

  



---


Overview
--------

Pre-dial handlers allow you to execute a dialplan subroutine on a channel before a call is placed but after the application performing a dial action is invoked. This means that the handlers are executed after the creation of the caller/callee channels, but before any actions have been taken to actually dial the callee channels. You can execute a dialplan subroutine on the caller channel and on each callee channel dialed.

There are two ways in which a pre-dial handler can be invoked:

* The '**B**' option in an application executes a dialplan subroutine on the caller channel before any callee channels are created.
* The '**b**' option in an application executes a dialplan subroutine on each callee channel after it is created but before the call is placed to the end-device.

Pre-dial handlers are supported in the [Dial](/Asterisk-11-Application_Dial) application and the [FollowMe](/Asterisk-11-Application_FollowMe) application.




---

**WARNING!: WARNINGS**  
* As pre-dial handlers are implemented using [Gosub](/Asterisk-11-Application_Gosub) subroutines, they must be terminated with a call to [Return](/Asterisk-11-Application_Return).
* Taking actions in pre-dial handlers that would put the caller/callee channels into other applications will result in undefined behaviour. Pre-dial handlers should be short routines that do not impact the state that the dialing application assumes the channel will be in.
  



---


Syntax
------

For [Dial](/Asterisk-11-Application_Dial) or [FollowMe](/Asterisk-11-Application_FollowMe), handlers are invoked using similar nomenclature as other options (such as **M** or **U** in Dial) that cause some portion of the dialplan to execute.




---

  
  


```

b([[context^]exten^]priority[(arg1[^...][^argN])])
B([[context^]exten^]priority[(arg1[^...][^argN])])


```



---




---


**Information:**  If context or exten are not supplied then the current values from the caller channel are used.

  



---


Examples
--------

The examples illustrated below use the following channels:

* *SIP/foo* is calling either *SIP/bar*, *SIP/baz*, or both
* *SIP/foo* is the caller
* *SIP/bar* is a callee
* *SIP/baz* is another callee

#### Example 1 - Executing a pre-dial handler on the caller channel




---

  
  


```

[default]

exten => s,1,NoOp()
same => n,Dial(SIP/bar,,B(default^caller\_handler^1))
same => n,Hangup()

exten => caller\_handler,1,NoOp()
same => n,Verbose(0, In caller pre-dial handler!)
same => n,Return()



```



---




---

  
Example 1 CLI Output  


```

<SIP/foo-123> Dial(SIP/bar,,B(default^caller\_handler^1))
<SIP/foo-123> Executing default,caller\_handler,1
<SIP/foo-123> In caller pre-dial handler!
<SIP/foo-123> calling SIP/bar-124


```



---


#### Example 2 - Executing a pre-dial handler on a callee channel




---

  
  


```

[default]

exten => s,1,NoOp()
same => n,Dial(SIP/bar,,b(default^callee\_handler^1))
same => n,Hangup()

exten => callee\_handler,1,NoOp()
same => n,Verbose(0, In callee pre-dial handler!)
same => n,Return()



```



---




---

  
Example 2 CLI Output  


```

<SIP/foo-123> Dial(SIP/bar,,b(default^callee\_handler^1))
<SIP/bar-124> Executing default,callee\_handler,1
<SIP/bar-124> In callee pre-dial handler!
<SIP/foo-123> calling SIP/bar-124


```



---


#### Example 3 - Executing a pre-dial handler on multiple callee channels




---

  
  


```

[default]

exten => s,1,NoOp()
same => n,Dial(SIP/bar&SIP/baz,,b(default^callee\_handler^1))
same => n,Hangup()

exten => callee\_handler,1,NoOp()
same => n,Verbose(0, In callee pre-dial handler!)
same => n,Return()



```



---




---

  
Example 3 CLI Output  


```

<SIP/foo-123> Dial(SIP/bar&SIP/baz,,b(default^callee\_handler^1))
<SIP/bar-124> Executing default,callee\_handler,1
<SIP/bar-124> In callee pre-dial handler!
<SIP/baz-125> Executing default,callee\_handler,1
<SIP/baz-125> In callee pre-dial handler!
<SIP/foo-123> calling SIP/bar-124
<SIP/foo-123> calling SIP/baz-125


```



---


