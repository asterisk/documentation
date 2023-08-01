---
title: app_macro Deprecation
pageid: 19008210
---

Macro Deprecation
=================


These changes to Asterisk allow for the final deprecation of all usage of app_macro within Asterisk. There should now be app_stack based alternatives for every use case. Because of the way macros are implemented, they are limited to a nesting depth of 7. This is a result of its heavy usage of the stack when called recursively and the significant possibility of a crash when doing so. In addition, certain applications may not function as expected when called from within a macro call.


Call Completion Supplementary Services
--------------------------------------


Starting with Asterisk 11, Call Completion Supplementary Services(CCSS) callback macro functionality has been deprecated in favor of an app_stack-based approach. Usage in channel driver configurations is nearly identical to that of the existing app_macro-based option.


### Differences in Usage


In channel configurations, 'cc_callback_sub' should be used instead of 'cc_callback_macro' and a complete location in the dialplan such as 'local,1234,1' should be provided instead of a macro context. Arguments and argument order have been preserved to make the change as smooth as possible.


### Example


Assuming a SIP configuration of the following:

```

[general]
limitonpeers=yes
udpbindaddr = 127.0.0.2

[alice]
type = friend
context = to-bob
host = 127.0.0.1
qualify = no
insecure = invite
cc_agent_policy=generic
cc_monitor_policy=generic
cc_callback_sub=cc_test,s,1
callcounter=yes

[bob]
type = friend
fromuser = bob
context = bob-in
host = 127.0.0.1
qualify = no
insecure = invite
cc_agent_policy=generic
cc_monitor_policy=generic
cc_callback_sub=cc_test,s,1
callcounter=yes

```

And dialplan:

```

[to-bob]
exten => 1234,1,NoOp
exten => 1234,n,Dial(SIP/bob)

exten => 1235,1,Answer()
exten => 1235,n,CallCompletionRequest()

[cc_test]
exten => s,1,NoOp(CCSS callback run for CCBS)
exten => s,n,Return

```

#### Events


A call is made to bob. While this call is active, Alice attempts a call to Bob by dialing 1234, fails, and then requests CCBS by dialing 1235. Once Bob ends his call, Asterisk runs the callback (cc_test), calls Bob, and then calls Alice to complete the CCBS request.


Connected Line Information
--------------------------


Starting with Asterisk 11, the use of a connected line information (CLI) callback macro for CLI interception and modification has been deprecated in favor of an app_stack-based approach. If both app_macro-based and app_stack-based callbacks have been defined, the app_stack-based callback will be run instead of the app_macro-based callbacks. To accomplish this deprecation, two new dialplan variables have been introduced: CONNECTED_LINE_SEND_SUB and CONNECTED_LINE_SEND_SUB_ARGS. If CONNECTED_LINE_SEND_SUB is set, it will override its equivalent macro-based callback. If neither CONNECTED_LINE_SEND_SUB nor its macro equivalents are set, connected line information will be passed along unmodified.


### Differences in Usage


The primary difference between the app_macro-based callbacks and the new app_stack-based callback is that there is only one variant of the app_stack-based callback where there were previously callee and caller variants of the macro callback. Caller and callee distinctions break down in transfer situations so the caller and callee variants were combined in the app_stack-based implementation. CONNECTED_LINE_SEND_SUB must be provided with a full dialplan location such as 'local,1234,1'. Otherwise, usage is identical to the deprecated app_macro-based callback.


### Example


Starting dialplan execution at 'test,100,1', the following is a working example of the app_stack-based CLI callback using local channels.

```

[test]
exten => 100,1,NoOp
exten => 100,n,Set(CONNECTED_LINE_SEND_SUB=callback,s,1)
exten => 100,n,Set(CONNECTED_LINE_SEND_SUB_ARGS=45,4)
exten => 100,n,Dial(local/101@test)
exten => 100,n,Hangup

exten => 101,1,NoOp
exten => 101,n,Set(CONNECTEDLINE(name,i)="Company Name")
exten => 101,n,Set(CONNECTEDLINE(name-pres,i)=allowed)
exten => 101,n,Set(CONNECTEDLINE(num,i)=5551212)
exten => 101,n,Set(CONNECTEDLINE(num-pres)=allowed)
exten => 101,n,Answer
exten => 101,n,Echo()

[callback]
; ARG1 is the prefix to add.
; ARG2 is the number of digits at the end to add the prefix to.
; When the subroutine ends the CONNECTEDLINE data is passed to the
; channel driver.
exten => s,1,NoOp()
exten => s,n,GotoIf($[${CONNECTEDLINE(number)} != 5551212]?end)
exten => s,n,NoOp(Running connected line subroutine with arg1: ${ARG1} and arg2: ${ARG2})
exten => s,n,Set(NOPREFIX=${CONNECTEDLINE(number):-${ARG2}})
exten => s,n,Set(CONNECTEDLINE(num,i)=${ARG1}${NOPREFIX})
exten => s,(end),Return

```

Redirecting Information
-----------------------


Starting with Asterisk 11, the use of a redirecting information (RI) callback macro for RI interception and modification has been deprecated in favor of an app_stack-based approach. If both app_macro-based and app_stack-based callbacks have been defined, the app_stack-based callback will be run instead of the app_macro-based callbacks. To accomplish this deprecation, two new dialplan variables have been introduced: REDIRECTING_SEND_SUB and REDIRECTING_SEND_SUB_ARGS. If REDIRECTING_SEND_SUB is set, it will override its equivalent macro-based callback. If neither REDIRECTING_SEND_SUB nor its macro equivalents are set, redirecting information will be passed along unmodified.


### Differences in Usage


The primary difference between the app_macro-based callbacks and the new app_stack-based callback is that there is only one variant of the app_stack-based callback where there were previously callee and caller variants of the macro callback. Caller and callee distinctions break down in transfer situations so the caller and callee variants were combined in the app_stack-based implementation. REDIRECTING_SEND_SUB must be provided with a full dialplan location such as 'local,1234,1'. Otherwise, usage is identical to the deprecated app_macro-based callback.


### Example


Starting dialplan execution at 'test,100,1', the following is a working example of the app_stack-based RI callback using local channels.

```

[test]
exten => 100,1,NoOp
exten => 100,n,Set(REDIRECTING_SEND_SUB=callback,s,1)
exten => 100,n,Set(REDIRECTING_SEND_SUB_ARGS=45,4)
exten => 100,n,Dial(local/101@test)
exten => 100,n,Hangup

exten => 101,1,NoOp
exten => 101,n,Set(REDIRECTING(to-num,i)=2000)
exten => 101,n,Set(REDIRECTING(to-num-pres)=allowed)
exten => 101,n,Set(REDIRECTING(from-num,i)=1000)
exten => 101,n,Set(REDIRECTING(from-num-pres,i)=allowed)
exten => 101,n,Set(REDIRECTING(count,i)=$[${REDIRECTING(count)} + 1])
exten => 101,n,Set(REDIRECTING(reason,i)=cfu)
exten => 101,n,Answer
exten => 101,n,Echo()

[callback]
; ARG1 is the prefix to add.
; ARG2 is the number of digits at the end to add the prefix to.
; When the subroutine ends the REDIRECTING data is passed to the
; channel driver.
exten => s,1,NoOp()
exten => s,n,GotoIf($[${REDIRECTING(to-num)} != 2000]?end)
exten => s,n,NoOp(Running caller redirecting subroutine with arg1: ${ARG1} and arg2: ${ARG2})
exten => s,n,Set(NOPREFIX=${REDIRECTING(to-num):-${ARG2}})
exten => s,n,Set(REDIRECTING(to-num,i)=${ARG1}${NOPREFIX})
exten => s,(end),Return

```

