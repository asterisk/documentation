---
title: Followme - Realtime
pageid: 4260003
---

Followme is now realtime-enabled.


To use, you must define two backend data structures, with the following fields:

```

followme:
 name Name of this followme entry. Specified when invoking the FollowMe
 application in the dialplan. This field is the only one which is
 mandatory. All of the other fields will inherit the default from
 followme.conf, if not specified in this data resource.
 musicclass OR The musiconhold class used for the caller while waiting to be
 musiconhold OR connected.
 music
 context Dialplan context from which to dial numbers
 takecall DTMF used to accept the call and be connected. For obvious reasons,
 this needs to be a single digit, '\*', or '#'.
 declinecall DTMF used to refuse the call, sending it onto the next step, if any.
 call_from_prompt Prompt to play to the callee, announcing the call.
 norecording_prompt The alternate prompt to play to the callee, when the caller
 refuses to leave a name (or the option isn't set to allow them).
 options_prompt Normally, "press 1 to accept, 2 to decline".
 hold_prompt Message played to the caller while dialing the followme steps.
 status_prompt Normally, "Party is not at their desk".
 sorry_prompt Normally, "Unable to locate party".

```
```

followme_numbers:
 name Name of this followme entry. Must match the name above.
 ordinal An integer, specifying the order in which these numbers will be
 followed.
 phonenumber The telephone number(s) you would like to call, separated by '&'.
 timeout Timeout associated with this step. See the followme documentation
 for more information on how this value is handled.

```

