---
title: The Stasis Message Bus
pageid: 30277635
---

 

 

Overview
========




!!! tip Asterisk 12 and Later
    This content only applies to Asterisk 12 and later.

      
[//]: # (end-tip)



In Asterisk 12, a new core component was added to Asterisk: the Stasis Message Bus. As the name suggests, Stasis is an internal publish/subscribe message bus that lets the real-time core of Asterisk inform other modules or components – who subscribe for specific information topic – about events that occurred that they were interested in.

While the Stasis Message Bus is mostly of interest to those developing Asterisk, its existence is a useful piece of information in understanding how the Asterisk architecture works.

On This PageKey Concepts
============

The Stasis Message Bus has many concepts that work in concert together. Some of the most important are:

Publisher
---------

A Publisher is some core component that wants to inform other components in Asterisk about some event that took place. More rarely, this can be a dynamically loadable module; most publishers however are real-time components in the Asterisk core (such as the Channel Core or the Bridging Framework).

Topic
-----

A Topic is a high level, abstract concept that provides a way to group events together. For example, a topic may be all changes to a single channel, or all changes to all bridges in Asterisk.

Message
-------

A Message contains the information about the event that just occurred. A Publisher publishes a Message under a specific Topic to the Stasis Message Bus.

Subscriber
----------

A Subscriber subscribes to a particular topic, and chooses which messages it is interested in. When the Stasis Message Bus receives a Message from a Publisher, it delivers the Message to each subscribed Subscriber.

Cache
-----

Some Messages - particularly those that affect core communications primitives in Asterisk (such as channels or bridges) are stored in a special cache in Stasis. Subscribers have the option to query the cache for the last known state of those primitives.

 

Example: Channel HangupStasis Bus Copy

Benefits
========

Prior to Asterisk 12, various parts of the real-time core of Asterisk itself would have been responsible for updating AMI, the CDR Engine, and other modules/components during key operations. By decoupling the consumers of state (such as AMI or the CDR Engine) from the producer (such as the Channel Core), we have the following benefits:

* Improved Modularity: the logic for AMI, CDRs, and other consumers of state is no longer tightly coupled with the real-time components. This simplifies both the producers and the consumers.
* Insulation: because the APIs are now based on the Stasis Message Bus, changes to other parts of the Asterisk core do not immediately affect the APIs. The APIs have the ability to transform, buffer, or even discard messages from the message bus, and can choose how to represent Asterisk to their consumers. This provides increased stability for Asterisk users.
* Extensibility: because real-time state is now readily available over the message bus, adding additional consumers of state becomes much easier. New interfaces and APIs can be added to Asterisk without modifying the Asterisk core.
