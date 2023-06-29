---
title: Overview
pageid: 28315969
---

Asterisk includes the concepts of [Device State](/Fundamentals/Key-Concepts/States-and-Presence/Device-State) , [Extension State](/Fundamentals/Key-Concepts/States-and-Presence/Extension-State-and-Hints) and [Presence State](/Fundamentals/Key-Concepts/States-and-Presence/Presence-State) which together allow Asterisk applications and interfaces to receive information about the state of devices, extensions and the users of the devices.

As an example, channel drivers like chan_sip or res_pjsip/chan_pjsip may both provide devices with device state, plus allow devices to [subscribe to hints](/Fundamentals/Key-Concepts/States-and-Presence/Extension-State-and-Hints) to receive notifications of state change. Other examples would be app_queue which takes into consideration the device state of queue members to influence queue logic or the Asterisk Manager Interface which provides actions for [querying extension state and presence state](/Fundamentals/Key-Concepts/States-and-Presence/Querying-and-Manipulating-State).

In This SectionSee Also[Distributed Device State](/Configuration/Interfaces/Distributed-Device-State)

[Publishing Extension State](/Configuration/Channel-Drivers/SIP/Configuring-res_pjsip/Publishing-Extension-State)

[Exchanging Device and Mailbox State Using PJSIP](/Configuration/Channel-Drivers/SIP/Configuring-res_pjsip/Exchanging-Device-and-Mailbox-State-Using-PJSIP)

Additionally, modules exist for [Corosync](/Configuration/Interfaces/Distributed-Device-State/Corosync) and [XMPP PubSub](/Configuration/Interfaces/Distributed-Device-State/Distributed-Device-State-with-XMPP-PubSub) support to allow device state to be [shared and distributed](/Configuration/Interfaces/Distributed-Device-State) across multiple systems.

The sub-sections here describe these concepts, point to related module specific configuration sections and discuss [Querying and Manipulating State](/Fundamentals/Key-Concepts/States-and-Presence/Querying-and-Manipulating-State) information.

The figure below may help you get an idea of the overall use of states and presence with the Asterisk system. It has been simplified to focus on the flow and usage of state and presence. In reality, the architecture can be a bit more confusing. For example a module could both provide subscription functionality for a subscriber and be the same module providing the devices and device state on the other end.

![](StateAndPresenceOverview.png)

