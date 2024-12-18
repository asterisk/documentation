---
title: Overview
pageid: 29395573
---

The Evolution of Asterisk APIs
==============================

When Asterisk was first created back in 1999, its design was focussed on being a stand-alone Private Branch eXchange (PBX) that you could configure via static `.conf` files. Control of the calls that passed through it was done through a special `.conf` file, `extensions.conf`, known as the "dialplan". The dialplan script told Asterisk which applications to execute on the call, and made logical decisions based on what the users did through their phones. This model worked well for a long time - it was certainly more flexible than what existed at the time, and the plethora of dialplan applications provided a large suite of functionality.

These dialplan applications, however, were - and still are - written in C. Because the applications act directly on the raw primitives in Asterisk, they are incredibly powerful. They have access to the channels, media, bridges, endpoints, and all other objects that Asterisk uses to make phones communicate. However, while powerful, there are times when a business use case is not met by the existing suite of applications. In the past, if the functionality you needed wasn't met by the dialplan application, you really only had one solution: write a patch in C - possibly adding a parameter to the application to tweak the behaviour - and submit it to the project. If you could not write the feature in C, you were, unfortunately, stuck.

Enter AMI and AGI
-----------------

Not long into the project, two application programming interfaces (APIs) were added to Asterisk: the Asterisk Gateway Interface (AGI) and the Asterisk Manager Interface (AMI). These interfaces have distinct purposes:

1. AGI is analogous to CGI in Apache. AGI provides an interface between the Asterisk dialplan and an external program that wants to manipulate a channel in the dialplan. In general, the interface is synchronous - actions taken on a channel from an AGI block and do not return until the action is completed.
2. AMI provides a mechanism to control where channels execute in the dialplan. Unlike AGI, AMI is an asynchronous, event driven interface. For the most part, AMI does not provide mechanisms to control channel execution - rather, it provides information about the state of the channels and controls about where the channels are executing.

Both of these interfaces are powerful and opened up a wide range of integration possibilities. Using AGI, remote dialplan execution could be enabled, which allowed developers to integrate Asterisk with PHP, Python, Java, and other applications. Using AMI, the state of Asterisk could be displayed, calls initiated, and the location of channels controlled. Using both APIs together, complex applications using Asterisk as the engine *could* be developed.

40%On This PageARI In More DetailHowever, there are some drawbacks to using AMI and AGI to create custom communication applications:

1. AGI is synchronous and blocks the thread servicing the AGI when an Asterisk action is taken on the channel. When creating a communications application, you will often want to respond to changes in the channel (DTMF, channel state, etc.); this is difficult to do with AGI by itself. Coordinating with AMI events can be challenging.
2. The dialplan can be limiting. Even with AMI and AGI, your fundamental operations are limited to what can be executed on a channel. While powerful, there are other primitives in Asterisk that are not available through those APIs: bridges, endpoints, device state, message waiting indications, and the actual media on the channels themselves. Controlling those through AMI and AGI can be difficult, and can often involve complex dialplan manipulation to achieve.
3. Finally, both AMI and AGI were created early in the Asterisk project, and are products of their time. While both are powerful interfaces, technologies that are used today were not in heavy use at the time. Concepts such as SOAP, XML/JSON-RPC, and REST were not in heavy use. As such, newer APIs can be more intuitive and easier to adopt, leading to faster development for users of Asterisk.

And so, before Asterisk 12, if you wanted your own custom communication application, you could:

* Write an Asterisk module in C, **or**
* Write a custom application using both AGI and AMI, performing some herculean effort to marry the two APIs together (as well as some dialplan trickery)



ARI: An Interface for Communications Applications
-------------------------------------------------

The Asterisk RESTful Interface (ARI) was created to address these concerns. While AMI is good at call control and AGI is good at allowing a remote process to execute dialplan applications, neither of these APIs was designed to let a developer build their own custom communications application. ARI is an asynchronous API that allows developers to build communications applications by exposing the raw primitive objects in Asterisk - channels, bridges, endpoints, media, etc. - through an intuitive REST interface. The state of the objects being controlled by the user are conveyed via JSON events over a WebSocket.

These resources were traditionally the purview of Asterisk's C modules. By handing control of these resources over to all developers - regardless of their language choice - Asterisk becomes an engine of communication, with the business logic of how things should communicate deferred to the application using Asterisk.

***ARI is not about telling a channel to execute the VoiceMail dialplan application or redirecting a channel in the dialplan to VoiceMail.***

***It is about letting you build your own VoiceMail application.***

 ![](AMI-ARI-AGI.png)ARI Fundamentals
================

ARI consists of three different pieces that are - for all intents and purposes - interrelated and used together. They are:

1. A [RESTful](http://en.wikipedia.org/wiki/Representational_state_transfer) interface that a client uses to control resources in Asterisk.
2. A WebSocket that conveys events in [JSON](http://www.json.org/) about the resources in Asterisk to the client.
3. The [Stasis](/Latest_API/API_Documentation/Dialplan_Applications/Stasis) dialplan application that hands over control of a channel from Asterisk to the client.

All three pieces work together, allowing a developer to manipulate and control the fundamental resources in Asterisk and build their own communications application.

What is REST?
-------------

[Representational State Transfer (REST)](https://en.wikipedia.org/wiki/Representational_state_transfer) is a software architectural style. It has several characteristics:

* Communication is performed using a client-server model.
* The communication is stateless. Servers do not store client state between requests.
* Connections are layered, allowing for intermediaries to assist in routing and load balancing.
* A uniform interface. Resources are identified in the requests, messages are self-descriptive, etc.

ARI *does not* strictly conform to a REST API. Asterisk, as a stand-alone application, has state that may change outside of a client request through ARI. For example, a SIP phone may be hung up, and Asterisk will hang up the channel - even though a client through ARI did not tell Asterisk to hang up the SIP phone. Asterisk lives in an asynchronous, state-ful world: hence, ARI is *RESTful*. It attempts to follow the tenants of REST as best as it can, without getting bogged down in philosophical constraints.

What is a WebSocket?
--------------------

[WebSockets](http://en.wikipedia.org/wiki/WebSocket) are a relatively new protocol standard ([RFC 6455](http://tools.ietf.org/html/rfc6455)) that enable two-way communication between a client and server. The protocol's primary purpose is to provide a mechanism for browser-based applications that need two-way communication with servers, without relying on HTTP long polling or other, non-standard, mechanisms.

In the case of ARI, a WebSocket connection is used to pass asynchronous events from Asterisk to the client. These events are related to the RESTful interface, but are technically independent of it. They allow Asterisk to inform the client of changes in resource state that may occur because of and in conjunction with the changes made by the client through ARI.

What is Stasis?
---------------

[Stasis](/Latest_API/API_Documentation/Dialplan_Applications/Stasis) is a dialplan application in Asterisk. It is the mechanism that Asterisk uses to hand control of a channel over from the dialplan - which is the traditional way in which channels are controlled - to ARI and the client. Generally, ARI applications manipulate channels in the Stasis dialplan application, as well as other resources in Asterisk. Channels not in a Stasis dialplan application generally cannot be manipulated by ARI - the purpose of ARI, after all, is to build your own dialplan application, not manipulate an existing one.

Diving Deeper
=============

This space has a number of pages that explore different resources available to you in ARI and examples of what you can build with them. Generally, the examples assume the following:

* That you have some phone registered to Asterisk, typically using `chan_pjsip` or `chan_sip`
* That you have some basic knowledge of configuring Asterisk
* A basic knowledge of Python, JavaScript, or some other higher level programming language (or a willingness to learn!)

Most of the examples will not directly construct the HTTP REST calls, as a number of very useful libraries have been written to encapsulate those mechanics. These libraries are listed below.

Where to get the examples
-------------------------

All of the examples on the pages below this one are available on [github](https://github.com/asterisk/ari-examples). Check them out!

ARI Libraries
-------------

See the [ARI Libraries](/Configuration/Interfaces/Asterisk-REST-Interface-ARI/ARI-Libraries) page for a list of Asterisk Rest Interface libraries and frameworks.

Recommended Practices
=====================

Don't access ARI directly from a web page
-----------------------------------------

It's very convenient to use ARI directly from a web page for development, such as using Swagger-UI, or even abusing the [WebSocket echo demo](http://www.websocket.org/echo.html) to get at the ARI WebSocket.

But, *please*, do not do this in your production applications. This would be akin to accessing your database directly from a web page. You need to hide Asterisk behind your own application server, where you can handle security, logging, multi-tenancy and other concerns that really don't belong in a communications engine.

Use an abstraction layer
------------------------

One of the beautiful things about ARI is that it's so easy to just bang out a request. But what's good for development isn't necessarily what's good for production.

Please don't spread lots of direct HTTP calls throughout your application. There are cross-cutting concerns with accessing the API that you'll want to deal with in a central location. Today, the only concern is authentication. But as the API evolves, other concerns (such as versioning) will also be important.

Note that the abstraction layer doesn't (and shouldn't) be complicated. Your client side API can even be something as simple wrapper around GET, POST and DELETE that addresses the cross-cutting concerns. The Asterisk TestSuite has a very simple abstraction library that can be used like this:

```python linenums="1"
ari = ARI('localhost', ('username', 'password'))

# Hang up all channels
channels = ari.get('channels')
for channel in channels:
 ari.delete('channels', channel['id'])

```

In other words: **use one of the aforementioned libraries or write your own!**



