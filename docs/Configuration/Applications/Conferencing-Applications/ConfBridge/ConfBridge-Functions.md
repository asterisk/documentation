---
title: ConfBridge Functions
pageid: 34014255
---

Function CONFBRIDGE
===================

The CONFBRIDGE dialplan function is used to set customized Bridge and/or User Profiles on a channel for the ConfBridge application. It uses the same options defined in confbridge.conf and allows the creation of dynamic, dialplan-driven conferences.

On This PageSyntax
------

```
CONFBRIDGE(type,option)

```

* type - Refers to which type of profile the option belongs to. Type can be either "bridge" or "user."
* option - Refers to the confbridge.conf option that is to be set dynamically on the channel. This can also refer to an existing Bridge or User Profile by using the keyword "template." In this case, an existing Bridge or User Profile can be appended or modified on-the-fly.

Examples
--------

**Example 1**  

```
exten => 1,1,Answer()
exten => 1,n,Set(CONFBRIDGE(user,announce_join_leave)=yes)
exten => 1,n,Set(CONFBRIDGE(user,startmuted)=yes)
exten => 1,n,ConfBridge(1)

```

**Example 2**  

```
exten => 1,1,Answer()
exten => 1,n,Set(CONFBRIDGE(user,template)=default_user)
exten => 1,n,Set(CONFBRIDGE(user,admin)=yes)
exten => 1,n,Set(CONFBRIDGE(user,marked)=yes)
exten => 1,n,ConfBridge(1)

```

Function CONFBRIDGE_INFO
=========================

The CONFBRIDGE_INFO dialplan function is used to retrieve information about a conference, such as locked/unlocked status and the number of parties including admins and marked users.

### Syntax

```
CONFBRIDGE_INFO(type,conf)

```

* type - Refers to which information type to be retrieved. Type can be either "parties," "admins," "marked," or "locked."
* conf - Refers to the name of the conference being referenced.

The CONFBRIDGE_INFO function returns a non-negative integer for valid conference identifiers, 0 or 1 for locked, and "" for invalid conference identifiers.
