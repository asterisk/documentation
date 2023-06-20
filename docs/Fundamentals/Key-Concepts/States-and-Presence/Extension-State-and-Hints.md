---
title: Extension State and Hints
pageid: 28934189
---

Overview
========

Extension state is the state of an Asterisk extension, as opposed to the direct state of a device or a user. It is the aggregate of [Device state](/Device-State) from devices mapped to the extension through a **hint** directive. See the [States and Presence](/Fundamentals/Key-Concepts/States-and-Presence) section for a diagram showing the relationship of all the various states.

Asterisk's SIP channel drivers provide facilities to allow SIP presence subscriptions ([RFC3856](http://www.ietf.org/rfc/rfc3856.txt)) to extensions with a defined hint. With an active subscription, devices can receive notification of state changes for the subscribed to extension. That notification will take the form of a SIP NOTIFY with PIDF content ([RFC3863](http://www.ietf.org/rfc/rfc3863.txt)) containing the presence/state information.

Defining Hints
==============

For Asterisk to store and provide state for an extension, you must first define a **hint** for that extension. Hints are defined in the [Asterisk dialplan](/Configuration/Dialplan), i.e. extensions.conf.

When Asterisk loads the configuration file it will create hints in memory for each hint defined in the dialplan. Those hints can then be [queried or manipulated](/Fundamentals/Key-Concepts/States-and-Presence/Querying-and-Manipulating-State) by functions and CLI commands. The state of each hint will regularly be updated based on state changes for any devices mapped to a hint.

The full syntax for a hint is




---

  
  


```

exten = <extension>,hint,<device state id>[& <more dev state id],<presence state id>

```



---


Here is what you might see for a few configured hints.




---

  
  


```

[internal]

exten = 6001,hint,SIP/Alice&SIP/Alice-mobile
exten = 6002,hint,SIP/Bob
exten = 6003,hint,SIP/Charlie&DAHDI/3
exten = 6004,hint,SIP/Diane,CustomPresence:Diane
exten = 6005,hint,,CustomPresence:Ellen

```



---


Things of note:

* You may notice that the syntax for a hint is similar to a regular extension, except you use the **hint** keyword in place of the priority. Remember these special hint directives are used at load-time and not during run-time, so there is no need for a priority.
* Multiple devices can be mapped to an extension by providing an ampersand delimited list.
* A presence state ID is set after the device state IDs. If set with only a presence state provider you must be sure to include a blank field after the hint as in the example for extension 6005.
* Hints can be anywhere in the dialplan. Though, remember that dialplan referencing the extension and devices subscribing to it will need use the extension number/name and context. The hints shown above would be 6001@internal, 6002@internal, etc, just like regular extensions.

Querying Extension State
========================

The [Querying and Manipulating State](/Fundamentals/Key-Concepts/States-and-Presence/Querying-and-Manipulating-State) section covers accessing and affecting the various types of state.

For a quick CLI example, once you have defined some hints, you can easily check from the CLI to verify they get loaded correctly.




---

  
  


```

\*CLI> core show hints
 -= Registered Asterisk Dial Plan Hints =-
 6003@internal : SIP/Charlie&DAHDI/3 State:Unavailable Watchers 0
 6002@internal : SIP/Bob State:Unavailable Watchers 0
 6001@internal : SIP/Alice&SIP/Alice- State:Unavailable Watchers 0
 6005@internal : ,CustomPresence:Elle State:Unavailable Watchers 0
 6004@internal : SIP/Diane,CustomPres State:Unavailable Watchers 0
----------------
- 5 hints registered

```



---


In this example I was lazy, so they don't have real providers mapped otherwise you would see various states represented.

SIP Subscription to Asterisk hints
==================================

Once a hint is configured, Asterisk's SIP drivers can be configured to allow SIP User Agents to subscribe to the hints. A subscription will result in state change notifications being sent to the subscriber.

Configuration for **chan\_sip** is discussed in [Configuring chan\_sip for Presence Subscriptions](/Configuration/Channel-Drivers/SIP/Configuring-chan_sip/Configuring-chan_sip-for-Presence-Subscriptions)

Configuration for **res\_pjsip** is discussed in [Configuring res\_pjsip for Presence Subscriptions](/Configuration/Channel-Drivers/SIP/Configuring-res_pjsip/Configuring-res_pjsip-for-Presence-Subscriptions)

 

