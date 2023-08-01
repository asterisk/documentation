---
title: Skinny call logging
pageid: 22088154
---

Page for details about call logging.


Calls are logged in the devices placed call log (directories->Place Calls) when a call initially connects to another device. Subsequent changes in the device (eg forwarded) are not reflected in the log.


If a call is not placed to a channel they will not be recorded in the log. eg a call to voicemail will not be recorded. You can force these to be recorded by including progress(), then ringing() in the dialplan.


Example (This will produce a logged call):

```

exten => 100,1,NoOp
exten => 100,n,Progress
exten => 100,n,Ringing
exten => 100,n,VoicemailMain(${CALLERID(num)@mycontext,s)

```

Example (This will not):

```

exten => 100,1,NoOp
exten => 100,n,VoicemailMain(${CALLERID(num)@mycontext,s)

```

