---
title: Pre-dial handlers Specification
pageid: 19008337
---



# Summary

Pre-dial - Ability to run dialplan on callee and caller channel right before actual Dial. Available on the Dial and FollowMe applications.

# Description

Pre-dial handlers allow you to execute a dialplan Gosub on a channel before a call is placed but after the Dial application is invoked. You can execute a dialplan Gosub on the caller channel and on each callee channel dialed.

The 'B' option executes a dialplan Gosub on the caller channel before any callee channels are created.

The 'b' option executes a dialplan Gosub on each callee channel after it is created but before the call is placed to the end-device.

Example execution sequences to show when things happen:
SIP/foo is calling SIP/bar
SIP/foo is the caller,
SIP/bar is the callee,
SIP/baz is another callee,

{noformat:title=Example 1}
<SIP/foo-123> Dial(SIP/bar,,B(context^exten^priority))
<SIP/foo-123> Executing context,exten,priority
<SIP/foo-123> calling SIP/bar-124
```

{noformat:title=Example 2}
<SIP/foo-123> Dial(SIP/bar,,b(context^exten^priority))
<SIP/bar-124> Executing context,exten,priority
<SIP/foo-123> calling SIP/bar-124
```

{noformat:title=Example 3}
<SIP/foo-123> Dial(SIP/bar&SIP/baz,,b(context^exten^priority))
<SIP/bar-124> Executing context,exten,priority
<SIP/baz-125> Executing context,exten,priority
<SIP/foo-123> calling SIP/bar-124
<SIP/foo-123> calling SIP/baz-125
```

# Syntax

```
b([[context^]exten^]priority[(arg1[^...][^argN])])
B([[context^]exten^]priority[(arg1[^...][^argN])])
```

The syntax is intentionally similar to the Gosub application. If context or exten are not supplied then the current values from the caller channel are used.

# Use cases

## Pre-dial callee channels (Option 'b')

Say SIP/abc is calling SIP/def. In the dialplan you have: Dial(SIP/def). When executed, SIP/def-123234 is created. But how can you tell that from dialplan?

You can use a pickup macro: M or U options to Dial(), but you have to wait till the called channel answers to know. The new pre-dial option 'b' to Dial(), will let you run dialplan on the newly created channel before the call is placed to the end-device.

{noformat:title=New way}
Dial(SIP/def,,b(context^exten^priority))
```

Dialplan will run on SIP/def-123234 and allow you to know right away what channel will be used, and you can set specific variables on that channel.

## Pre-dial caller channels (Option 'B')

You can run dialplan on the caller channel right before the dial, which is a great place to do a last microsecond UNLOCK to ensure good channel behavior.

{noformat:title=Example}
exten => \_X.,1,GotoIf($[${LOCK(foo)}=1]?:failed)
exten => \_X.,n,do stuff
exten => \_X.,n,Set(Is\_Unlocked=${UNLOCK(foo)})
exten => \_X.,n,Dial(SIP/abc)
exten => \_X.,n(failed),Hangup()
```

With this above example, say SIP/123 and SIP/234 are running this dialplan.

# SIP/123 locks foo
# SIP/123 unlocks foo
# Due to some CPU load issue, SIP/123 takes its time getting to Dial(SIP/abc) and doesn't do it right away.
# Meanwhile... SIP/234 zips right by, lock 'foo' is already unlocked
# SIP/234 grabs the lock, does its thing and it gets to Dial(SIP/abc).
# SIP/123 wakes up and finally gets to the Dial().

Now you have two channels dialing SIP/abc when there was supposed to be one.

If your intention is to ensure that Dial(SIP/abc) is only done one at a time, you may have unexpected behavior lurking.

{noformat:title=New way}
exten => \_X.,1,GotoIf($[${LOCK(foo)}=1]?:failed)
exten => \_X.,n,do stuff...
exten => \_X.,n,Dial(SIP/abc,,B(unlock^s^1))
exten => \_X.,n,GotoIf($[${Is\_Unlocked}=1]?already\_unlocked:not\_unlocked)
exten => \_X.,n(not\_unlocked),Set(Is\_Unlocked=${UNLOCK(foo)})
exten => \_X.,n(already\_unlocked),Do after dial stuff...
exten => \_X.,n(failed),Hangup()

[unlock]
exten => s,1,Set(Is\_Unlocked=${UNLOCK(foo)})
```

Now, under no circumstances can this dialplan be run through and execute the Dial unless lock 'foo' is released. Obviously this doesn't ensure that you're not calling SIP/abc more than once (you would need more dialplan logic for that), but it will allow a dialplan coder to also put the Dial in the locked section to ensure tighter control.

