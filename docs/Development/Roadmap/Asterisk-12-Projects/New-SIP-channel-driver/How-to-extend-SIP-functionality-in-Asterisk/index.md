---
title: Overview
pageid: 22773971
---

As someone who is interested in developing new SIP functionality for Asterisk, seeing the breadth of the new SIP work may cause some confusion in how to approach getting the problem you wish to solve solved. Depending on what sort of feature you are trying to add, there are several options available for you. Here, we will examine the various options available to you.


A brief note on design philosophy
=================================


One of the driving reasons for rewriting SIP was that `chan_sip` was monolithic. In other words, all of the functionality was crammed together within a single file, with application and underlying transaction, transport, and other SIP-related maintenance being intermixed. The new SIP work is modeled very differently. The SIP functionality is built on top of the PJSIP stack so that the majority of protocol-related logic is taken care of for us and we don't need to concern ourselves with it when writing application-level code. In addition, the approach of writing new code is more modular than it was in the past. Typically, a single module deals with one application-level aspect and nothing else. If you look inside the Asterisk source code in the `res/` directory, you will find many files that begin with the prefix `res_sip*`. Each of these is a separate module that is responsible for some small portion of functionality.


When making additions to the SIP code in Asterisk, it is strongly recommended that you write your new functionality in its own module. Unless you are making improvements to functionality that already exists in another module, you will likely want to keep your new logic completely separate from the rest of the SIP processing. This affords several benefits:


* It is easy to port your code to a new version of Asterisk when you decide to upgrade. Rather than worrying about whether your patch will apply cleanly in the new version of Asterisk, you can simply plug your module in and things should just work.
* It allows an easy method for people to enable or disable your functionality. Most SIP features are not essential to the core workings of Asterisk, so allowing your functionality to be optionally loaded will make people happy.
* It enforces discipline in your coding. If you keep the mindset that you have your own area you can mess with and not to try to change things outside that area, then you are less likely to muddy the core of SIP in Asterisk.


SIP session supplement
======================


The most common SIP use in Asterisk is the setting up of media sessions via a dialog initiated by an INVITE request. Asterisk has taken the shortcut of referring to such a dialog and its associated media session as a "session". Sessions in Asterisk are made extendable via a mechanism called "Session supplements". Session supplements are a set of callbacks that are called at various points throughout the lifetime of a session. The callbacks provided allow for your supplement to be visited when the session begins and ends, as well as when any SIP request or response is sent or received during the session. Session supplements also have datastores, similar to what channels have, so your supplement can store arbitrary data on a session and retrieve or remove it when necessary. Session supplements can be tuned to only be called for specific SIP methods as well. Some potential examples of when you might use SIP session supplements are:


* You wish to store some sort of information on a channel or other central Asterisk structure based on the value of a SIP header in a request or response.
* You wish to add headers to an outbound SIP request or response based on saved data in your module.
* You wish to send a specific error response to an inbound request based on a SIP header or system state.
* You wish to add support for some specific type of in-dialog request (such as a specific INFO package)


Some good examples of simple session supplements are in the following files


* `res/res_sip_rfc3326.c`
* `res/res_sip_callerid.c`


For an in-depth tutorial on writing a session supplement see the page [here](/Development/Roadmap/Asterisk-12-Projects/New-SIP-channel-driver/How-to-extend-SIP-functionality-in-Asterisk/Writing-a-SIP-Session-Supplement).


SIP SDP handler
===============


In addition to session supplements, the session architecture allows extensions with regards to handling of different media stream types in SDPs. SDP handlers provide callbacks in order to handle incoming SDP streams, negotiate SDP streams, apply negotiated SDP streams, and create outgoing SDP streams. Note the mention of "stream" in the previous sentence. SDP handlers register themselves as being able to handle a specific type of media stream, and are only called for those particular types of streams. Multiple SDP handlers for a specific type of stream can be registered as well. This way, if one handler is not able to handle the stream for whatever reason, a different registered handler may be able to do it instead. Some potential examples of when you might use SDP handlers are:


* You wish to be able to handle SDP streams of a type not currently supported by Asterisk
* You wish to extend the support of existing SDP handlers to add support for something they currently do not support, such as a specific codec type


A good example of an SDP handler in Asterisk code is in the file `res/res_sip_sdp_rtp.c`, which handles audio and video streams in SDPs.


For an in-depth tutorial on writing an SDP handler, see the page at TBD.




!!! note 
    While SDP extensibility is built into the SIP code, you likely will not find much use for it in Asterisk 12. The reason for this is that the core of Asterisk is not built in such a way as to handle arbitrary media types or multiple streams of the same type. So while we have the support ready in SIP, the core of Asterisk will first need an overhaul before any really cool SDP handlers can be written.

      
[//]: # (end-note)



SIP subscription handler
========================


Asterisk's SIP code provides an API for registering a module as a subscription handler. Subscription handlers register with a pubsub API and can act as either subscribers or notifiers. Subscription handlers are called into based on subscription activity. For instance, a notifier is called into when a new SUBSCRIBE arrives for the event package that the subscription handler handles. On established subscriptions, the notifier is called into when a subscription is terminated, expires, or is renewed. A subscriber is called into when a NOTIFY is received or when the time has come for the subscription to be renewed.


Subscription handlers are useful when you wish to have SUBSCRIBE and/or NOTIFY support for an event package that Asterisk does not already support.


A good example of a SIP subscription handler in Asterisk code is the file `res/res_sip_mwi.c`, which acts as a notifier for message waiting indication.


For an in-depth tutorial on writing a subscription handler, see the page at TBD.




!!! note 
    Subscription handlers are still in development. If you cannot find the `res/res_sip_mwi.c` file, it may be that it has not been merged yet.

      
[//]: # (end-note)



SIP Publication handler
=======================


This is similar to a subscription handler, except that this pertains to SIP PUBLISH transactions. Publication handlers work only as the recipients of PUBLISH requests, and are likely to work hand-in-hand with a specific notifier. Publication handlers are notified when a PUBLISH arrives, when a publication expires, when a publication changes, and when a publication terminates.


Publication handlers are useful when you wish to supplement a notifier with the ability to accumulate state from external SIP entities.


There are no current examples of publication handlers to look at.


For an in-depth tutorial on writing a publication handler, see the page at TBD.




!!! note 
    Publication handlers are in development. If you have difficulty locating information in the source about these, then support may not have been merged yet.

      
[//]: # (end-note)



