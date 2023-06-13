---
title: Overview
pageid: 21464468
---


This page is under construction. Please refrain from adding comments until a draft has been completed


A proposed architecture for the new SIP channel driver architecture is below.


new\_chan\_sip\_design
Transport
=========


This is straightforward. Each transport will be treated separately. The necessary transports when the new channel driver is created will be TCP, TLS, UDP, and Websocket. The transports may or may not be handled by the SIP stack itself.


Protocol conversion
===================


This is where Asterisk's main interaction with the third-party SIP stack will occur. A `res_sip` module will be defined in order to provide APIs for the upper layers of the architecture to use. The SIP operations will be application-agnostic. Concepts such as "media sessions" and "registrations" have no business here.


Message Interception
====================


This is an interesting piece. Before doing any application-specific parsing of SIP messages, there are some things that can be accomplished. For instance, logging the SIP message can be done here. In addition, transport-related security framework items can be placed at this layer. Authentication can also happen here since authentication is a global concept that does not pertain to individual SIP applications.


Application
===========


This is where specific SIP applications would find their home, as well as application-specific APIs. Each application should live separately from others as much as possible. There should be no need for the registrar to need to use any logic provided by the channel driver, for instance.


An explanation for servants: servants are essentially the workhorses for specific operations. In the diagram, they live directly below an API definition. So for instance, the channel driver implementation would provide the necessary channel technology callbacks but would immediately send the work off to a channel driver servant to perform the work. Doing this allows for quick dispatching of work into an appropriate thread.


Asterisk Integration
====================


This is the Asterisk core. Parts of the core already exist, such as the messaging core and the channel core. A new piece is the data access layer. The data access layer is a layer where persistent information can be stored and retrieved. This allows for different configuration backends to be able to store data into a common layer, and it allows for the SIP modules to access the data without having to know where the data originated from.

