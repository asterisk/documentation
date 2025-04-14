---
title: Querying and Manipulating State
pageid: 28934227
---

Overview
========

This section will enumerate and briefly describe the ways in which you can query or manipulate the various Asterisk state resources. [Device State](/Fundamentals/Key-Concepts/States-and-Presence/Device-State), [Extension State](/Fundamentals/Key-Concepts/States-and-Presence/Extension-State-and-Hints) and [Presence State](/Fundamentals/Key-Concepts/States-and-Presence/Presence-State). Where mentioned, the various functions and commands will be linked to further available documentation.

Device State
============

The [**DEVICE_STATE**](/Latest_API/API_Documentation/Dialplan_Functions/DEVICE_STATE) **function** will return the Device State for a specified device state identifier and allow you to set Custom device states.

On the command line, the **devstate** command will allow you to list or modify Custom device states specifically.

```
devstate change -- Change a custom device state
devstate list -- List currently known custom device states

```

On this Page

Extension State
===============

The **[EXTENSION_STATE](/Latest_API/API_Documentation/Dialplan_Functions/EXTENSION_STATE)** **function** will return the [Extension State](/Fundamentals/Key-Concepts/States-and-Presence/Extension-State-and-Hints) for any specified extension that has a defined hint.

The CLI command **core show hints** will show extension state for all defined hints, as well as display a truncated list of the mapped Device State or Presence State identifiers.

```
myserver\*CLI> core show hints
 -= Registered Asterisk Dial Plan Hints =-
 6002@from-internal : SIP/6002 State:Unavailable Watchers 0
 7777@from-internal : SIP/6003,CustomPrese State:Unavailable Watchers 0
----------------
- 2 hints registered

```

Presence State
==============

Added in Asterisk 11, the **[PRESENCE_STATE](/Latest_API/API_Documentation/Dialplan_Functions/PRESENCE_STATE) function** will return [Presence State](/Fundamentals/Key-Concepts/States-and-Presence/Presence-State) for any specified Presence State identifier, or set the Presence State for specifically for a [CustomPresence identifier](/Fundamentals/Key-Concepts/States-and-Presence/Presence-State).

The **presencestate** CLI command will list or modify any currently defined Presence State resources provided by the CustomPresence provider.

```
myserver\*CLI> core show help presencestate 
presencestate change -- Change a custom presence state
presencestate list -- List currently know custom presence states

```

Asterisk Manager Interface actions
==================================

Any of the previously mentioned functions could be called via [AMI](/Configuration/Interfaces/Asterisk-Manager-Interface-AMI) with the [Setvar](/Latest_API/API_Documentation/AMI_Actions/Setvar) and [Getvar](/Latest_API/API_Documentation/AMI_Actions/Getvar) actions.

Then there are two more specific actions called [ExtensionState](/Latest_API/API_Documentation/AMI_Actions/ExtensionState) and [PresenceState](/Latest_API/API_Documentation/AMI_Actions/PresenceState). See the linked documentation for more info.
