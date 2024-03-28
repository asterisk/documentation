---
title: Bridge Application
pageid: 32375253
---

Overview of the Bridge Application
==================================

The Bridge application takes two channels and attempts to put them into a [Bridge](/Fundamentals/Key-Concepts/Bridges). Both channels and bridges are very common elements of Asterisk operation, so this is a really useful application to learn.

For Bridge to work, two channels are required to exist. That is the channel executing the Bridge application and a target channel that you want to bridge with. If the operation is successful the two channels will be bridged and media exchanged among the channels.

To help out let's contrast Dial and Bridge:

* When a channel executes Dial a new channel is created for the target device. If the new channel is answered then both channels are bridged.
* When a channel executes Bridge then Asterisk will attempt to bridge the two existing channels; the executing channel and the target channel.

Note that bridge provides several options to tweak behavior and upon completion Bridge will return status on a channel variable. These are detailed in the app documentation.

Using the Bridge application
----------------------------

Read the Bridge documentation for your version of Asterisk (e.g. Asterisk 13 - [Asterisk 13 Application_Bridge](/Latest_API/API_Documentation/Dialplan_Applications/Bridge)) and the [Key Concepts](/Fundamentals/Key-Concepts) section on [Bridges](/Fundamentals/Key-Concepts/Bridges) to get a good start.

See Also
========

* [Bridging Modules](/Fundamentals/Asterisk-Architecture/Types-of-Asterisk-Modules/Bridging-Modules)
* [Pre-Bridge Handlers](/Configuration/Dialplan/Subroutines/Pre-Bridge-Handlers)
* [Introduction to ARI and Bridges](/Configuration/Interfaces/Asterisk-REST-Interface-ARI/Introduction-to-ARI-and-Bridges)
* [Asterisk 13 Application_BridgeWait](/Latest_API/API_Documentation/Dialplan_Applications/BridgeWait)
* [Conferencing Applications](/Configuration/Applications/Conferencing-Applications)







