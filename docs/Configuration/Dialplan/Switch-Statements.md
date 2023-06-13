---
title: Switch Statements
pageid: 31097228
---

Dialplan Switch Statements
==========================

The **switch** statement permits a server to share the dialplan with another server. To understand when a switch would be searched for dialplan extensions you should read the  section as it covers Dialplan search order.

Use with care: Reciprocal switch statements are not allowed (e.g. both A -> B and B -> A), and the switched server need to be on-line or else dialing can be severely delayed.

Basic switch statement
----------------------

As an example, with remote IAX switching you get transparent access to the remote Asterisk PBX.

[iaxprovider]
switch => IAX2/user:password@myserver/mycontextThe lswitch statement
---------------------

An "lswitch" is like a switch but is literal, in that variable substitution is not performed at load time but is passed to the switch directly (presumably to be substituted in the switch routine itself)

lswitch => Loopback/12${EXTEN}@othercontextThe eswitch statement
---------------------

An "eswitch" is like a switch but the evaluation of variable substitution is performed at runtime before being passed to the switch routine.

eswitch => IAX2/context@${CURSERVER} 

 

