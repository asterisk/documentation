---
title: Hangup Handlers Specification
pageid: 19726432
---



# Summary

Hangup handlers - Ability to attach subroutines to a channel that runs dialplan when the channel hangs up.

# Description

Hangup handlers are an alternative to the h extension. They can be used in addition to the h extension. The idea is to attach a Gosub routine to a channel that will execute when the call hangs up. Whereas which h extension gets executed depends on the location of dialplan execution when the call hangs up, hangup handlers are attached to the call channel. You can attach multiple handlers that will execute in the order of most recently added first.

{note}
Please note that when the hangup handlers execute in relation to the h extension is not defined. They could execute before or after the h extension.
{note}

Call transfers, call pickup, and call parking can result in channels on both sides of a bridge containing hangup handlers.

Hangup handlers can also be attached to any call leg because of pre-dial routines.

## When hangup handlers are executed

Any hangup handlers associated with a channel are always executed when the channel is hung up.

{note}
Adding a hangup handler in the h extension or during a hangup handler execution is undefined behavior. 
{note}

{warning}
As always, hangup handlers like the h extension need to execute quickly because they are in the hangup sequence path of the call leg. Specific channel driver protocols like ISDN and SIP may not be able to handle excessive delays completing the hangup sequence.
{warning}

## Manipulating hangup handlers on a channel

Hangup handlers pass the saved handler string to the Gosub application to execute. The syntax is intentionally the same as the Gosub application. If context or exten are not supplied then the current values from the channel pushing the hangup handler are inserted before storing on the hangup handler stack.

{noformat:title=Push a hangup handler onto a channel}
same => n,Set(CHANNEL(hangup\_handler\_push)=[[context,]exten,]priority[(arg1[,...][,argN])]);
```

{noformat:title=Pop a hangup handler off a channel and optionally push a replacement}
same => n,Set(CHANNEL(hangup\_handler\_pop)=[[[context,]exten,]priority[(arg1[,...][,argN])]]);
```

{noformat:title=Pop all hangup handlers off a channel and optionally push a replacement}
same => n,Set(CHANNEL(hangup\_handler\_wipe)=[[[context,]exten,]priority[(arg1[,...][,argN])]]);
```

{noformat:title=Cascading hangup handlers}
same => n,Set(CHANNEL(hangup\_handler\_push)=hdlr3,s,1(args));
same => n,Set(CHANNEL(hangup\_handler\_push)=hdlr2,s,1(args));
same => n,Set(CHANNEL(hangup\_handler\_push)=hdlr1,s,1(args));
```

## AMI events

The hangup handler AMI events are output as part of the AMI dialplan permission class.

The AMI event HangupHandlerPush is generated whenever a hangup handler is pushed on the stack by the CHANNEL() function.
The AMI event HangupHandlerPop is generated whenever a hangup handler is popped off the stack by the CHANNEL() function.
The AMI event HangupHandlerRun is generated as a hangup handler is about to be executed.

## CLI commands

{noformat:title=Single channel}
core show hanguphandlers <chan>
```

{noformat:title=Output}
Channel Handler
<chan-name> <first handler to execute>
 <second handler to execute>
 <third handler to execute>
```

{noformat:title=All channels}
core show hanguphandlers all
```

{noformat:title=Output}
Channel Handler
<chan1-name> <first handler to execute>
 <second handler to execute>
 <third handler to execute>
<chan2-name> <first handler to execute>
<chan3-name> <first handler to execute>
 <second handler to execute>
```

