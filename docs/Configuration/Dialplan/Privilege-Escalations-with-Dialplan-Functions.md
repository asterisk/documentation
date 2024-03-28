---
title: Privilege Escalations with Dialplan Functions
pageid: 27198166
---

Dialplan functions within Asterisk are incredibly powerful, which is wonderful for building applications using Asterisk. Dialplan functions can be 'read' or 'written'. But during the read or write execution, certain diaplan functions do much more. For example, reading the [SHELL()](/Latest_API/API_Documentation/Dialplan_Functions/SHELL) function can execute arbitrary commands on the system Asterisk is running on. Writing to the [FILE()](/Latest_API/API_Documentation/Dialplan_Functions/FILE) function can change any file that Asterisk has write access to.

From the context of executing the dialplan defined in `extensions.conf`, this is not a problem. From other contexts, however, it could be a problem.

Channel variables can be get or set via external mechanisms (like [AMI](/Latest_API/API_Documentation/AMI_Actions/Getvar) or [ARI](/Latest_API/API_Documentation/Asterisk_REST_Interface/Channels_REST_API)), during which time dialplan functions are evaluated. These external protocols have permission levels associated with them, so the fact that executing a read on a certain function could effect a change on the system results in a [privilege escalation](http://en.wikipedia.org/wiki/Privilege_escalation).

In order to avoid this security issue, Asterisk can now inhibit the execution of privilege escalating functions from external protocols. These functions will continue to execute normally when invoked from the dialplan. For legacy configurations where the less secure behavior is desired, a new flag called `live_dangerously` has been added to `asterisk.conf`. When set to `yes`, Asterisk will allow privilege escalating functions to execute, even from external protocols.

For Asterisk 11 and earlier, in order to maintain backward compatibility, `live_dangerously` defaults to yes. In Asterisk 12, that default was changed to no.

