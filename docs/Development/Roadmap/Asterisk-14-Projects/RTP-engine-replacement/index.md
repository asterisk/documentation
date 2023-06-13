---
title: Overview
pageid: 31752285
---

This page has not received peer review and is still undergoing edits.

Purpose of this project
=======================

Asterisk development has shifted from pure PBX functionality in the past two years towards being a media communications server. WebRTC and other newer technology has prompted the creation and more rapid adoption of Internet RFCs. Many of these augment media handling in ways that Asterisk would have difficulty implementing. This page will delve into a few topics:

* A list of RTP standards, some of which Asterisk already supports, others of which are not yet supported.
* A breakdown of Asterisk's RTP implementation (res\_rtp\_asterisk, and maybe res\_rtp\_multicast) to determine what is currently supported, what is currently unsupported, and what it would take to add support for the unsupported features. In addition, this section will critique non-compliance with certain parts of supported standards.
* A verdict on the path forward for implementing the missing features and fixing behavior of existing features.
* A plan for testing RTP in Asterisk.

Narrowing the scope of this project
===================================

This project's aim is to change the underlying RTP implementation as much as is required in order to facilitate ease of adding known and possibly future missing features. Some specific areas that are not affected by this project are:

* Codec negotiation
* SDP, aside from RTP additions that also require SDP additions
* Automatic behavior based on network conditions
* Areas of media handling in Asterisk outside of RTP

RTP standards
=============

I took some notes on a selection of RTP standards, noting what sort of considerations an RTP architecture would need in order to support those standards. These are not necessarily a list of standards that we wish to support, but such a sampling helps to give a good idea of the type of architecture required. The notes can be found here.

The current state of RTP in Asterisk
====================================

In addition to notes on current RTP standards, I also have some rambling notes on the current state of RTP in Asterisk. These can be found here.

An Ideal RTP stack for Asterisk
===============================

There's a difference between an "ideal RTP stack" and an "ideal RTP stack for Asterisk". An ideal RTP implementation would be one that has a minimal interface between channel driver and media. A channel driver would gather a media description into some format understood by the RTP layer, and the RTP layer would use that information to set itself up as required (in other words, "smart media layer, dumb channel driver"). Unfortunately, the model of using RTP in Asterisk is to have channel drivers each parse their media descriptions and communicate individual settings to the RTP layer, sometimes hiding the reason for specific actions being taken (in other words, "smart channel driver, dumb media layer"). Asterisk is already hugely dependent on the high-level RTP engine API provided in `include/asterisk/rtp_engine.h.` Moving to a separate API would require major overhauls in all channel technologies that use RTP for their media. This makes a new media API not an option for the time being. So making an ideal RTP stack for Asterisk means the following:

* A new RTP engine to replace `res_rtp_asterisk` is fine.
* Augmentations to the current RTP engine API are fine.
* New helper APIs in addition to the current RTP engine API are fine
* All effort should be made to make anything new "just work" with any legacy channel drivers that use RTP, as well as make anything new not require new configuration.

A glossary of terms:
--------------------

You'll see some Asterisk-specific terminology used on this page. Here are definitions for those terms.

* RTP API (or RTP engine API): The top-level API that channel drivers use to create RTP instances. Most of what the RTP engine API does is to call into RTP engines to perform requested duties.
* RTP instance: An RTP instance is the structure that the RTP engine API creates and that the channel drivers act upon. An RTP instance correlates with a single media stream.
* RTP engine: A pluggable implementation of the RTP engine API.
* `res_rtp_asterisk`: The RTP engine that is used for the vast majority of calls in open source Asterisk.
* Steel Zebra: Code name for a replacement RTP engine that will be written as part of the work being done here. Constantly referring to it as "the new RTP engine" is lame
* RTP stream: RTP instances created by Steel Zebra will be referred to as RTP streams.
* RTP session: A structure created by Steel Zebra that contains related RTP streams and coordinates activities between streams where necessary.

Media Flow: Incoming Media
--------------------------

Media flow refers to the regular incoming and outgoing RTP and RTCP packets that occur after an RTP session has been set up. This is the easier of the two parts to rewrite in Asterisk because it mostly involves replacing `res_rtp_asterisk` with Steel Zebra. For this, we'll focus on requirements for incoming and outgoing media.

In general when processing inbound RTP, components will be concerned with either transport information, packet information, or payload information (or some combination). Incoming RTP and RTCP will go through the following phases:

* Transport reception
* Demultiplexing
* Decoding
* Packet reception

#### Transport reception

This is the act of reading a packet from a transport, typically a socket. Transport reception will be pluggable since there presumably could be multiple transport types (UDP, TCP) for RTP/RTCP.

#### Demultiplexing

Demultiplexing refers to distinguishing the different packet types that may be received over a transport. A demultiplexer is an entity that knows how to inspect an incoming packet and recognize it as a specific packet type. So the RTP demultiplexer will know how to recognize a packet as being RTP, and the RTCP demultiplexer will know how to recognize RTCP.

The most typical UDP transport will not have to do much demultiplexing since the only packet types being received are RTP and RTCP, and each is received on a distinct port. However, once other existing features are brought into play (such as ICE and DTLS-SRTP), there comes a need to inspect the incoming packets and make a determination of which type of packet has been received. Demultipexers will pass received RTP and RTCP packets to a decoder. Other types of packets may be passed to some third-party library that acts on the packet.

#### Decoding

Decoding refers to the process of taking raw bytes from the network and parsing them into easy-to-use structures.

For RTP packets and RTCP packets, decoding logic is specific to each RTP profile. For instance, the RTP/AVP profile will be able to decode RTP and RTCP packets. RTP/SAVP will be able to decode RTP and RTCP packets and decrypt the SRTP payload. RTP/AVPF will be able to decode RTP and RTCP packets, plus it will be able to decode certain RTCP packet types that other profiles cannot. While decoding behavior can be described by the RTP profile in use, Asterisk unfortunately does not communicate the RTP profile directly to the RTP layer. Instead, the profile in use has to be inferred based on certain function calls.

In addition to the base decoding provided by an RTP profile, RTP streams may specify additional decoding steps for certain packet types. As an example if RFC 4733 DTMF is being used, then the decoder will need to call into a special RFC 4733-specific decoding operation in order to decode the payload properly.

#### Packet reception

Packet reception refers to processing the packet that the decoder outputs and acting on it in some way. This provides a useful way to record information that a packet contains or perform transformations on the packet if desired.

For RTP, statistics can be gathered for use in RTCP transmissions, and the payloads can be interpreted into Asterisk frames and sent where they need to be sent. The most common action for these frames will be to queue them on an Asterisk channel.

For RTCP, the compound packet will have its constituent parts sent to various stat collectors and other components that may wish to act on the reception of RTCP.

#### Media Flow: Outgoing media

The flow for outgoing RTP is mostly the same as for incoming, just in reverse. RTP goes through the following steps:

* Playout
* Encoding
* Routing
* Transmission

#### Playout

Playout occurs when it is time to play media out over an RTP stream. Playout will most commonly occur when a channel has media to write out. However, it may also occur due to native local RTP bridging as well. Playout for non-RTP stream can also occur when it is time for an RTCP report to be sent. It may also create STUN packets for keepalive purposes during ICE negotiation. Once appropriate data is constructed, the packet is passed down to a corresponding encoder for that type of data.

#### Encoding

This takes a structure of a particular type and places the data in a format suitable to be transmitted over the wire. Like with decoding, there may be multiple necessary steps for the encode (Encode RTP packet -> Add RTP extensions -> Encrypt with SRTP, e.g.). Some encoding steps can be determined by the RTP profile in use. Others will require specific plugins to be used instead.

#### Routing

Routing determines what the destination of the media will be. The default routing scheme is to send media to the address that was in the c= line of an SDP. However, media may be routed differently depending on if symmetric RTP or ICE is in use. The job of the router is to present the packet to the underlying transport along with a destination address.

#### Transmission

This involves sending the packet out over the configured transport type. For now, UDP and DTLS constitute the only transports in use, but it is possible to add support for TCP or other forms of transport later if desired.

Media Flow: Threading
---------------------

How does the threading model look with this media flow? There are two required threads, though they could be expanded to use threadpools instead. One thread is an RTP monitor thread. It is responsible for polling the transports, reading the data from ready transports, and passing the data to the demultiplexer. The demultiplexer passes the packet to the appropriate decoder, which passes the decoded packet to the packet handler(s) for that packet type.

A second thread is responsible for performing regularly-scheduled tasks. This includes transmission of RTCP reports and transmission of RFC 4733 DTMF continuation packets, among potentially other things. This second thread is managed by the channel driver that creates RTP instances. The channel driver passes a scheduler context into RTP instance creation, and Steel Zebra will simply schedule tasks on that scheduler context as needed.

Transmission of RTP happens in whatever thread calls a channel's `write()` method. Typically, this will happen in PBX threads or bridge channel threads.

The code will be structured such that if additional threads are needed, they can be added without requiring too much effort. For instance, the single threads could be modified to use a threadpool. Or the parts of incoming packet handling could be separated into separate threads based on "actors" on the data.

Media Setup
-----------

Because the goal is to alter the top-level RTP engine API as little as possible, there will not be any unified new API for media setup.

Ideally, the new RTP engine would be able to accept SDP offers and answers and set itself up based on this information. However, this would be too large a departure from the current model of RTP setup. So instead, SDP will continue to be parsed by the channel drivers that receive the SDPs.

In addition to RTP streams, an RTP session will be created under the hood as well. This will be done by creating the session when the first RTP stream is created and then associating subsequent RTP streams with the same created session. This is a bit of an odd way to construct an RTP session, but we're restricted to doing it this way since the high-level RTP engine API does not know about sessions. The session will be responsible for coordinating activities between streams, such as synchronizing incoming audio and video streams. When BUNDLE support is added, it is likely that the RTP session will have some responsibility in coordinating the underlying streams to use a single transport.

#### BUNDLE

BUNDLE is not currently implemented in Asterisk, and the plan is not necessarily to actually implement BUNDLE at this time. However, the RTP stack needs to be designed with BUNDLE in mind and be able to support it without too much difficulty. The addition of an RTP session structure allows for BUNDLE to be more easily integrated into the RTP engine since the RTP session will be able to coordinate the different streams. The different layers of the media inflow and outflow should allow for BUNDLE plugins to be added at appropriate places in order to facilitate BUNDLE.

#### The actual process

A channel driver discovers the need to create an RTP instance, either because it is going to make an outgoing call or is accepting an incoming call. The channel driver calls `ast_rtp_instance_new()` to create a new RTP instance. The final parameter for this function call will be a custom structure for Steel Zebra, which will contain at least the channel on which the RTP instance is being created. This structure may be expanded in the future if it turns out that other pieces of information would be useful during stream creation.

When the first RTP instance for a channel is allocated, Steel Zebra creates both an RTP stream and an RTP session. Some default properties are set on the session and the stream. If the channel creates more RTP instances, then the new RTP engine will create RTP streams for each RTP instance. The new RTP streams will be added to the RTP session that was created when the first RTP stream was created.

Afterwards, the channel driver will inspect SDP attributes and call into the RTP engine to set values just as it has always done.

Session Creation

Session creation results in a playout timer being set on the scheduler context that is passed in (see `ast_rtp_instance_new()`).

##### Stream Creation

When an RTP stream is created, it has some defaults put in place for its media flows. Going through the flow from above:

* Incoming
	+ A UDP transport is created for RTP.
	+ A demultiplexer that understands RTP/AVP is put in place, along with an RTP decoder.
* Outgoing
	+ An RTP encoder is put in place.
	+ The same transport that was created for incoming RTP is set as the transport to use on outgoing RTP.

After the stream and session have been created, they should be in shape to be able to receive and send RTP traffic. There are no frills, but it will work.

As the channel driver parses SDP attributes, it will call into RTP engine APIs that will do logical things for the media inflow and outflow. For instance

* Setting the remote address will adjust the packet router's destination address setting.
* Enabling symmetric RTP will result in a separate symmetric RTP packet router being used.
* Stopping an RTP instance will result in no longer sending or receiving data on the stream.
* Destroying an RTP instance will result in de-allocation of memory and removal of the stream from the RTP session.

Other stuff
-----------

The general setup and media flow are the main points of interest for the new RTP engine, but there are some other points to bring up, to include implementation details for the new engine, as well as the inevitable changes to be made in places outside of the new engine.

#### Native local RTP bridges

Native local RTP bridges have a few considerations when implementing a new RTP engine.

First, `bridge_native_rtp` requires that the RTP engine's `local_bridge` method has to be the same for each of the bridged RTP instances. If we create a new RTP engine, it will not have the same `local_bridge` method as `res_rtp_asterisk`. This means that calls that use `res_rtp_asterisk` will not be able to be locally bridged with calls that use the new RTP engine. I think it is possible to rework the inner workings of native local bridges such that they can be between different RTP engines. However, if the goal is the total removal of `res_rtp_asterisk` from the codebase, then such considerations are not as necessary.

Second, native local RTP bridging is performed at the main RTP API layer by having the bridged RTP instances point at each other. It is up to the individual RTP instances to detect that this has occurred and act accordingly. It might work better if the job of setting bridges on RTP instances were passed down to the engines themselves in case they want to perform other side effects besides changing a pointer.

A LATER EDIT: After discussing native RTP bridging some, the verdict is that altering the actual native RTP bridge is a desirable thing, but that it does not necessarily need to be done as part of the same project of getting the RTP engine up to date.

#### ICE

ICE deserves its own special section because it's so different from everything else that goes on, plus there is a desire for the RTP engine to be trickle ICE capable. `res_rtp_asterisk` has a few flaws with regards to ICE. To name a few:

* ICE candidates are gathered for every RTP instance no matter whether ICE is actually going to be used or not. This is wasteful since it can delay call setup considerably when communicating with STUN and TURN servers.
* ICE relies on PJNATH directly.
* Gathering local ICE candidates is 100% synchronous right now. While this is fine for vanilla ICE, trickle ICE absolutely cannot work this way.
* ICE candidates are sent in an SDP answer when the corresponding SDP offer had no ICE support present.
* When sending direct media reinvites, ICE candidates are sent that do not correspond to the c= line in the outgoing SDP. This is a violation of RFC 5245.

We should do our best to ensure that none of these flaws are duplicated in the new RTP engine.

As was mentioned in the bulleted list above, `res_rtp_asterisk`'s ICE implementation relies heavily on direct usage of PJNATH.  This is fine, except for the fact that PJNATH does not currently support trickle ICE. At some point we will want to add trickle ICE support to our RTP implementation. That may mean adding trickle ICE support into PJNATH and pushing the change to PJProject. Then again, if PJNATH appears to be fundamentally incapable of the necessary changes to implement trickle ICE, then writing our own ICE implementation may be the path forward. In the meantime, wrapping the necessary parts of PJNATH insde a higher-level set of ICE functions is a sensible idea. This way, the underlying implementation can be changed out without the need for huge rewrites by the higher-level components. Note that when I mention an intermediary layer, I don't necessarily mean a formal API with pluggable backends, though that may end up being the way we go.

Trickle ICE has been mentioned a few times, and the current RTP design allows for trickle ICE to be integrated without too much trouble. The main changes for trickle ICE are in the internal ICE state machine rather than for users of ICE. The other changes are at the signaling level to indicate new trickled candidates and to indicate support for trickle ICE. The biggest change required at the RTP level is to be able to call a glue callback of some sort whenever it is time to trickle a new local ICE candidate to the far end.

#### DTLS

A DTLS engine is another type of engine that can be implemented by RTP engines. The DTLS engine for the new RTP engine will be mostly the same as the old DTLS engine. In fact, it may be worth deciding if DTLS functionality would be better suited as a separate API outside of RTP since it is difficult to picture many areas where DTLS will function differently in the new engine.

The Actual Work
===============

I have created a task list for what would be required in order to write an RTP engine from scratch. The page can be found here.

My personal opinion on the matter is that the positive impact of having a new RTP engine does not outweigh the risks and time investment. Since the goal is not to ruffle the feathers of higher-level users of the RTP engine API, the amount of work that can actually be done within an RTP engine is not that much. However, I do think that the current RTP engine could use an overhaul, architecturally, so refactoring `res_rtp_asterisk` to be more able to accept new features is a good idea.

