---
title: RTP task list
pageid: 31752472
---

!!! warning 
    This page has not received peer review and may still be undergoing edits.

[//]: # (end-warning)

This page contains a list of necessary tasks in order to write a new RTP engine. The tasks start out with incredibly specific detail and eventually move into much more general terms. The reason for this is to help remain agile in the process. Undoubtedly, requirements will change, or mistakes in the design early will change the nature of later tasks.

Bare-Bones calls
================

The first milestone will be to get the RTP engine written to the point that we can successfully pass media through Asterisk. This means successfully constructing the media flows as described in the parent page and putting some basic setup in place. For this phase, it is encouraged to use hard-coding in place of pluggable elements. The sooner we can get to a point where we have successful calls, the easier it is to rapidly develop new features (and tests!) with confidence that they work as intended.

Create initial skeletons and stubs
----------------------------------

The goal of this task is basically to make sure that when channel drivers attempt to interact with the RTP engine, they do not crash.

#### Create the RTP engine structure

Fill in all required functions with stubs that return some error value. All optional functions should be left empty for now. Required functions are:

* `new()`: Return NULL
* `destroy()`: Return -1
* `read()`: Return -1
* `write()`: Return -1
* `name`: "Steel Zebra"

#### Create the RTP stream structure

The RTP stream structure will have nothing on it for the time being. We will add the requisite parts to it as tasks require them.

#### Create the RTP session structure

The RTP session structure will currently contain a single RTP stream and nothing else. We will add parts to it as tasks require them.

#### Un-stub the RTP engine new() method

For the time being, this will allocate an RTP session and an RTP stream. The RTP stream will be placed on the RTP session.

Construct the media outflow
---------------------------

The first task is to be able to play audio over an RTP stream. In order to reach this, the media outflow will need to be implemented. Media outflow means implementing the `write()` method on the RTP engine to completion. According to the planned outflow, a media write should go through an encoder, a router, and a transport.

#### Create an RTP encoder

Create an RTP encoder structure. Write an `encode()` method that will accept an `ast_frame` and return an encoded RTP header with an appropriate payload. For the time being, the encoder can work only on `AST_FRAME_VOICE` frames. Since this is the bare-bones phase, the RTP encoder can cheat in some respects, such as always using the same SSRC and never setting the marker bit. However, it must properly indicate sequence numbers and timestamps. The payload type number for the payload to transmit can be learned with `ast_rtp_codecs_payload_code()`.

#### Create a default packet router.

Create a default packet router structure. Add this structure to the RTP stream structure. Write a `route()` method that will pass an encoded RTP packet to the stream's transport's `write()` method. The main job of the default packet router is to provide an address for the packet to be routed to. The default packet router can call `ast_rtp_instance_get_remote_address()` to get the address to route the packet to.

#### Create an RTP transport

Create a UDP RTP transport structure. Add this structure to the RTP stream structure.

* Write an `init()` method and call it from the RTP engine's `new()` callback. The `init()` method should create a UDP socket and set any socket level flags required (e.g. nonblocking I/O). For this first phase, this can bind to a hard-coded IP address and port.
* Write a `write()` method that accepts an encoded RTP packet (a sequence of bytes), its size, and a destination address (an `ast_sockaddr`), and have that method call `ast_sockaddr_sendto()` when invoked.

#### Write the RTP engine write() function

In order to actually transmit media, the RTP engine's write function will need to be implemented. For this task, the write function will operate like so

* Accept `AST_FRAME_VOICE` frames and pass the payloads down to the RTP encoder's `encode()` method.
* Pass the encoded data to the default packet router's `route()` method.

Frame types other than `AST_FRAME_VOICE` can be ignored for now.

Construct the media inflow
--------------------------

The next logical task is to be able to create the media inflow. With this task completed, a call should be capable of receiving media and passing it up to the channel when requested.

#### Add packet reception to the RTP transport

The UDP RTP transport that was created previously needs to be modified to be able to receive packets.

* Write a `read()` callback that will call `ast_recvfrom()` on the UDP socket. The `read()` callback should take a buffer and size as its arguments and return the number of bytes read.

#### Create an RTP transport monitor thread

Create a thread whose purpose is to detect when incoming RTP media is received.

* Create the function that runs in the thread. The thread should run a loop that polls a collection of file descriptors to determine if any is ready for reading. If any file descriptor is ready for reading, read data from that file descriptor. Pass this data to the associated stream's demultiplexer.
* Write a function that will allow for a file descriptor to be monitored by the monitor thread. The function should take a file descriptor and an RTP stream as arguments so that a file descriptor can be associated with its associated stream.
* Modify the `init()` method for the transport to call the above function after creating its socket.

#### Create an RTP packet handler

The RTP packet handler will be responsible for taking decoded RTP frames, packaging the payload into an `ast_frame` and queuing that frame onto the channel associated with the stream. For the time being, the packet handler can assume that all frames are `AST_FRAME_VOICE` frames and that all frames should be queued onto the channel.

#### Create an RTP Decoder

Create a structure to represent an RTP decoder, and add this structure to the RTP stream structure.

* Create a structure that represents an RTP header. A suggested structure can be found in [Appendix A](http://tools.ietf.org/html/rfc3550#appendix-A) of RFC 3550.
* Write a `decode()` method that can take raw bytes and separate them into a decoded RTP header and a payload. When decoding RTP, the routine does not need to try to understand or decode RTP header extensions for the time being, but it does need to be prepared for header extensions to be present. This routine should not attempt to perform any processing on the payload. The decoder should pass the decoded RTP packet to the RTP packet handler created in the previous step.

#### Create an RTP demultiplexer

Create a structure to represent an RTP demultiplexer, and add this to the RTP stream structure.

* Write a `demux()` method that will pass all data it receives to the RTP decoder's `decode()` method. For now, this method is pretty useless, but having it in place now will make future demultiplexing efforts much easier.

Destruction
-----------

Once a call is hung up, we need to be able to clean up the RTP

#### Stop

The goal of this task is to stop RTP when requested.

* Create a "null" packet router. This packet router's `route()` method should simply drop all packets passed to it.
* Write a `stop()` RTP engine method. It should do the following:
	+ Install the null packet router for the RTP stream.
	+ Remove the file descriptor for the UDP socket from the RTP monitor thread.

#### Destroy

The goal of this task to is to ensure that all memory is freed when requested.

Write a `destroy()` method for the RTP engine. It should do the following:

* Destroy all dynamically allocated data on the RTP stream, including closing the UDP socket on the transport.
* Remove the RTP stream from the list of streams on the RTP session.
* If the RTP session no longer has any streams, then free all dynamically allocated data on the RTP session. Since RTP sessions currently only have one stream, this should happen every time.

Basic RTP features
==================

Once we have the bare minimum setup created and tested, we can start to add more basic RTP features.

Get rid of some of those hard-coded items
-----------------------------------------

#### RTP encoder

The RTP encoder initially has been using hard-coded values for

* SSRC
* Marker bit

Modify the RTP encoder to use proper values for these.

* SSRC
	+ An initial SSRC can be created at random when the encoder is allocated. RFC 3550 [Appendix A.6](http://tools.ietf.org/html/rfc3550#appendix-A.6) has a suggeseted algorithm for generating random 32-bit values. Feel free to use this or something else if desired.
	+ Implement a `change_source()` RTP engine callback that will change our SSRC to a different random value when called. One of the reasons for us creating a new RTP engine was due to "mangling SSRC". It may be wise to keep in consideration that the `change_source()` method on Steel Zebra should be a bit smarter about when to actually change SSRC. For this particular task, though, we're going to leave this method stupid.
* Marker bit

	+ The marker bit should always be set during the first packet that we send during an RTP stream.
	+ Implement an `update_source()` RTP engine callback that will indicate that the marker bit should be set on the next media frame sent

#### Configuration

Configuration is a necessary predecessor for getting rid of some hard-coded values in the engine. The goal is to use the existing `rtp.conf` configuration file and its existing settings so that migration is painless.

Add configuration loading and reloading capabilities to the module that implements Steel Zebra.

* The module's `load()` method should load configuration from `rtp.conf`. For the time being, the only configuration item that we are worried about are the `rtpstart` and `rtpend` options.
* The module's `reload()` method should re-read `rtp.conf` and update the saved port range based on new values of `rtpstart` and `rtpend`.

There is no hard requirement to use the new config API, though its use would be nice here.

#### Port binding

Steel Zebra's `new()` method should use the configured `rtpstart` and `rtpend` values to bind RTP to an even numbered port in that range. The current method employed by `res_rtp_asterisk` is to choose a random even number in the range and attempt to bind to it. If binding fails, the number is incremented by 2 and binding is retried. It is unknown how much this impedes RTP stream setup times on loaded systems, so you will want to implement port selection as a function that can be replaced with a new algorithm if desired. One naive suggestion for a different port selection algorithm would be to have all legal ports defined by the configured range in a queue (with the order randomized). Pop a number off the queue when it is time to allocate a port. When you have finished using that port, push it back onto the queue. This way is less likely to result in failed bind attempts, but it is also potentially memory-heavy (default range of RTP is 10000 ports, which is 5000 even numbered ports, which is 5000 \* 16 bits ~= 80KB). If you can devise something better, then go for it!

#### Packetization

All code currently is assuming 20 ms packetization for audio, but it shouldn't!

Audio presented to Steel Zebra's `write()` method may not be of the same packetization as requested by the remote receiver. The goal is to ensure that we only send media of the requested packetization.

* Create an RTP playout structure. For the time being, the structure should only have an `ast_smoother` on it.
* Add a `write()` method to the playout structure that takes an `AST_FRAME_VOICE` as a parameter. The first time that a frame of a particular audio type is received, the smoother should have `ast_smoother_reset()` called on it, with the size of the smoother being  calculated from the format on the frame. The audio data should be fed into the smoother. Then we should read from the smoother in order to get the correct number of samples to send. After these samples have been retrieved, these are passed down to the encoder.
* Modify the `write()` method on Steel Zebra not to call the encoder's `encode()` method. Instead, this should be replaced by calling the playout's `write()` method.

No change is required for the inflow since code at the channel or bridge layer can provide buffering and smoothing of media. The RTP inflow should remain packaging received media in `ast_frames` based on the amount of media received.

Add telephone-event support
---------------------------

Telephone-event refers to RFC 4733 DTMF telephone events. DTMF telephone-event support requires a decent chunk o' work in order to get correct. This is because this is the first feature that requires that existing components of the RTP stack become extensible.

#### Incoming telephone events

RTP packet handler changes:

* The RTP packet handler will need to be made pluggable, so that when RFC 4733 packets are received, they can be packaged into an `AST_FRAME_DTMF_BEGIN` or `AST_FRAME_DTMF_END` as appropriate.
* An RFC4733 plugin will need to be created and installed when the `AST_RTP_PROPERTY_DTMF` property is set on a Steel Zebra instance. The plugin will implement a state machine to determine the current DTMF state of incoming audio. Here are the states:
* The packet handler will need to call into the plugin on **all** RTP frames. This may seem odd since RFC 4733 should be concerned with specific payloads of RTP; however, the plugin does need to know when non-DTMF RTP has been received since that can affect its operation.

Decoder changes:

* The decoder will need to be able to decode specific types of encoded payloads, such as RFC 4733. So whereas the payload of an RTP packet may have been stored as an array of bytes before, the payload now needs to be able to be stored in alternate formats.
* The decoder will need to be made pluggable so that when decoding, the RTP packet may be passed to the plugin in order to be decoded properly. Plugins only need to be called into when an RTP packet of an appropriate payload is received.

#### Outgoing telephone events

The channel driver maintains information about whether RFC 4733 DTMF should be used on an RTP stream and will call into an RTP stream in order to begin and end DTMF.

* Write a `dtmf_begin()` method for Steel Zebra.
	+ The method should begin by creating a DTMF payload based on the specified digit.
	+ The method should pass this payload to the RTP encoder, indicating that the marker bit should be set.
	+ The method should schedule DTMF continuations to be sent at regular intervals based on the packetization of the outgoing stream.
* Write a `dtmf_end()` method for Steel Zebra.
	+ The method should begin by canceling the DTMF continuations that have been sent.
	+ The method should generate an RFC 4733 DTMF end payload.
	+ The method should send send this payload to the RTP encoder three times.
* Write a DTMF continuation scheduler callback function.
	+ This method will take as its user data the DTMF digit being sent, and the timestamp of the DTMF begin.
	+ The method will create an RFC 4733 payload with updated duration based on the timestamp.
	+ The method will then pass this RFC 4733 payload to the RTP encoder to be transmitted.

!!! warning 
    This section currently is saying to pass the RFC 4733 payload to the encoder. Previous language on this page said to pass `ast_frame` payloads to the encoder, which are different. This probably means that the `encode()` method should have its input parameters broken up a bit more. For instance, instead of `encode(voice_frame)`, it should be `encode(timestamp, marker_bit, raw_voice_data)`. This way, when it comes time to encode RFC 4733 DTMF, this works just as well.

[//]: # (end-warning)

Add support for multiple remote media sources
---------------------------------------------

When communicating with a remote endpoint, even though we may be receiving media from only a single remote IP address and port, the media could originate from multiple sources, represented by different SSRC identifiers. This section mostly deals with what should be done when receiving audio from multiple SSRCs.

!!! warning 
    Honestly, I'm not really sure what should be done here. Should this mostly be a statistical thing? Should we actually even expect to be communicating with an endpoint that sends us audio from multiple sources on a single stream?

[//]: # (end-warning)

Basic RTCP support
==================

Now that RTP has reached a state where it works generally well, we can start to add RTCP support in.

Create structures for different RTCP packet types
-------------------------------------------------

RFC 3550 defines  5 RTCP packet types: SR, RR, SDES, BYE, and APP. Create structures that can represent decoded packets of these types. Some suggested structures appear in Appendix A of RFC 3550; however, I do not suggest using these directly because the union approach they use does not allow for easy addition of new RTCP packet types. We already know that we will require additional packet types for RTP/AVPF, so don't box yourself in too early!

Add RTCP creation
-----------------

RTCP is activated and deactivated via RTP properties on an RTP instance. For this task, create a `prop_set()` method for Steel Zebra. For now, the only property that it needs to recognize is `AST_RTP_PROPERTY_RTCP`. If this property gets set, then we need to create an RTCP stream to live alongside the RTP stream. The RTCP stream will need to get statistics from the RTP stream, and the RTP stream may have need to force RTCP packets to be sent, so the two structures should have mutual access to each other somehow.

If the `AST_RTP_PROPERTY_RTCP` property is set with a zero value, then RTCP should be deactivated. This should completely destroy the RTCP stream, not just stop it. Part of the destruction process for RTCP should be to send an RTCP BYE packet, since presumably the reason RTCP is being stopped is because we will no longer be the source of media on this stream.

Add RTCP inflow
---------------

RTCP inflow works similarly to RTP inflow. RTCP comes in through a transport, is sent to a demultiplexer (in this case, the demultiplexer can recognize all traffic as RTCP), is sent to a decoder, and then is sent to something that acts on the RTCP packet. RTCP can re-use the RTP transport structures that have already been written since their job is no different. The RTCP demultiplexer is trivial for now since it, much like the RTP demultiplexer, will only ever interpret incoming packets as a single type.

#### Write the RTCP decoder

The RTCP decoder is a bit different from the RTP decoder since RTCP is received in compound packets, and there are multiple different types of RTCP sub-packets that can be received at once. The RTCP decoder should be designed such that a top-level decoder breaks the packets into sub-packets, recognizes what type of packet it is, and sends the packet to be decoded by a subpacket decoder. The subpacket decoder is responsible for decoding the contents of the subpacket and sending that packet to a packet handler that takes some sort of action on that type of packet.

#### Write RTCP subpacket handlers

Once an RTCP subpacket has been decoded, the subpacket needs to be given to someone that is interested in acting on that type of subpacket. The most common thing that a subpacket handler will do is emit a Stasis event with the information in it. We do not want to take any sort of automatic action on the RTP stream at this time.

Add RTCP to media outflow
-------------------------

RTCP outflow also works similarly to RTP outflow. At periodic intervals, RTCP reports need to be generated. When the time arrives, An RTCP report generator feeds data into encoders to create encoded RTCP subpackets. The report generator concatenates these encoded packets into a compound RTCP packet. This packet is then sent to a packet router, which sends it out the transport. The packet router and transport behave exactly the same for RTCP as they do for RTP, so the same structures can be re-used for RTCP.

#### Write RTCP encoders

Write encoders that can create RTCP SR, RR, SDES, and BYE packets. There is no need for us to create APP packets at this time since we are not doing anything that requires their use. Since appropriate statistics are not yet being collected, the RTCP sender and receiver reports will not provide accurate details about the session.

#### Write an RTCP report generator

The RTCP report generator will be called into periodically to send RTCP reports. The RTCP report generator will determine what type of RTCP packets should be sent at this time and call into the encoders to create packets with the appropriate information. Once the RTCP packets have been encoded, the report generator will concatenate these reports and send them down to the packet router to be transmitted.

Gather statistics for RTCP SR and RR
------------------------------------

RTP transmission and reception need to be augmented to gather statistics that can be sent in RTCP SR and RR packets. I suggest reading in-depth RFC 3550 section 6, as well as all sections in Appendix A for gathering RTCP statistics. I also have an RTP book whose RTCP chapter goes into more detail than RFC 3550 about details being reported in RTCP reports.

Advanced RTP features
=====================

These RTP features go beyond the humble

Strict RTP
----------

Strict RTP is an Asterisk security feature that prevents injection of media from unknown sources. RFC 3550 provides an algorithm in Appendix A.1 that allows for an RTP implementation not to accept packets from a new SSRC until after receiving a certain minimum number of RTP packets from that SSRC. Strict RTP is similar, except that

* Rather than applying the algorithm to new SSRCs, we apply the algorithm to source IP addresses and ports on arriving packets.
* We have to recognize periods where our strictness needs to be opened back up and reset the learning period.

Strict RTP is controlled through an option in `rtp.conf`.  

Symmetric RTP
-------------

Symmetric RTP is defined in RFC 4961. It describes a local policy of sending RTP to the same IP address and port that the data was received from, no matter what address had previously been communicated to be used for media. This is mainly used for NAT traversal. Symmetric RTP is controlled by setting an RTP property.

The `prop_set()` method on Steel Zebra needs to be updated to understand the `AST_RTP_PROPERTY_NAT` property. While this property may end up contributing additional behavior changes, for this task, the goal is to enable/disable symmetric RTP when this property is set/unset.

Symmetric RTP consists of two parts

* A transport plugin that will record the address of received RTP/RTCP.
* A packet router that will be used to route the packets to the recorded address.

Add support for multiple media streams on a session
---------------------------------------------------

Most changes required for supporting multiple streams will happen at the RTP session level. For this task, the easiest way to implement this is to think of the common situation of having an audio and video stream on a session. Most of the work is going to be verifying that previous tasks provided for multiple streams correctly and that there are no bugs.

#### Verify multiple stream creation works as expected

When multiple RTP streams are created on a session, the first stream's creation should create the RTP session. The second stream's creation should result in looking up the already-created RTP session and simply adding the second stream to the session. This should not result in the creation of a second RTP session.

#### Verify multiple stream stopping works as expected

When a single RTP stream is stopped, the stream should be deactivated on the session, meaning that the synchronizer no longer will take it into account when reading RTP data. Verify that if a session has multiple streams, stopping a single stream does not prevent data from being read from the other stream. Verify that once all streams are stopped that the synchronizer no longer runs.

#### Verify multiple stream destruction works as expected

When a single RTP stream is destroyed, it should be removed from the RTP session. Ensure that destroying the first of multiple RTP streams does not result in the session being destroyed. Verify that once all streams are destroyed that the session is destroyed.

Native RTP bridging
-------------------

Native RTP bridging refers to a shortcut where received RTP packets can have their payloads directly placed into a new RTP header and sent out without incurring the overhead of the Asterisk core. The way this currently works is that the native RTP bridge technology will set pointers on the RTP instances in the native bridge so that they can know if they should short-circuit. Since we have such a well defined inflow and outflow of media, the best way to handle native bridging is to run all of the current steps for media inflow, except that instead of queuing the frame onto the channel, we instead write the frame to the bridged RTP instance. This way, the outflow works exactly the same as any other frame, and the inflow is only slightly altered.

#### Alter the RTP Packet Handler

The RTP packet handler currently creates frames from incoming decoded RTP packets and queues them onto the channel. The RTP packet handler needs to be altered so that when the stream has a bridged RTP instance, the RTP packet handler will write the frames to the bridged RTP instance instead of queuing the frames on the channel.

SRTP
====

Create RTP/SAVP decoder
-----------------------

When the RTP profile in use for a stream is RTP/SAVP, then this decoder should be used for the stream. The RTP/SAVP decoder is essentially a decorator of the RTP/AVP decoder. The RTP headers are still going to be decoded exactly the same since they are not encrypted. However, the payloads will need to be decoded differently since they require decryption. Therefore, the easiest way to write the RTP/SAVP decoder is to have it unprotect the payload, and then simply embed the RTP/AVP decoder and have it do the rest of the job.

Create RTP/SAVP encoder
-----------------------

When the RTP profile in use for a stream is RTP/SAVP, then this encoder should be used for the stream. The RTP/SAVP encoder is essentially a decorator of the RTP/AVP encoder. The RTP headers are still going to be encoded exactly the same since they do not need to be encrypted. However, the payloads will need to be encoded differently since they will need to be encrypted. The easiest way to write the RTP/SAVP encoder is to have it use the RTP/AVP encoder to encode the data and then to have the RTP/SAVP encoder protect the data before sending the data down to the packet router.

Add SRTP setup and destruction code
-----------------------------------

Unfortunately, when SRTP is set up on an RTP instance, the underlying RTP engine is not notified that this has happened. Instead, an RTP engine is supposed to detect that an SRTP policy has been set up on an RTP instance when receiving or sending traffic and adapting based on that. For us, it makes a lot of sense to know when SRTP is being applied to a stream rather than having to find out later. So the strategy here is going to be to modify the RTP engine API to allow for RTP engines to be notified when an SRTP policy has been added to an RTP instance. This way, the RTP engine can make any structural changes it deems necessary. In the case of Steel Zebra, when SRTP is set up on an RTP instance, we will switch the current encoder and decoder on the stream to be the RTP/SAVP encoder and decoder.

DTLS-SRTP
=========

Create DTLS transport
---------------------

When the DTLS `set_configuration` method is called, a DTLS transport will need to be installed in place of the traditional UDP transport. This way, once a remote address has been determined for the media, a DTLS session can be set up.

Create DTLS demultiplexer
-------------------------

On DTLS streams, you can receive either RTP/RTCP packets or DTLS packets. The demultiplexer on an RTP stream needs to be able to discern RTP packets from DTLS packets. Similarly, on an RTCP stream, the demultiplexer needs to be able to discern RTCP packets from DTLS packets. RTP and RTCP packets will go through the typical process. DTLS packets will need to be passed to something that knows what to do with DTLS packets. In our case, that currently just means handing the packet to OpenSSL and being done with it.

Create DTLS setup and destruction code
--------------------------------------

Like with `res_rtp_asterisk`, Steel Zebra will need a DTLS engine. The majority of what this engine does will be very similar to what `res_rtp_asterisk` does. For the time being, focus more on getting things functional than trying to refactor the two engines into a single shared engine. The `set_configuration` method is going to be the method that sets the transport and demultiplexer into place. The `stop` method can be used to put the vanilla demultiplexer and transports back into their proper places.

ICE
===

Ice is one of the areas that needs a great deal of improvement over the current implementation in `res_rtp_asterisk`.

Create an intermediary ICE layer to wrap PJNATH
-----------------------------------------------

In anticipation of a possible switch to a different implementation of ICE than PJNATH, wrapping PJNATH in an API is a good idea. Some functions that will be required:

* Adding local candidates
* Adding remote candidates
* Performing STUN/TURN queries (both asynchronously and synchronously)
* Creating check lists
* Initiating connectivity checks
* Querying for a remote address to send media to (or alternatively providing a callback for being notified when connectivity checks have completed)
* Stopping/shutdown functions
* Methods for translating an ICE candidate into an SDP line (and vice-versa)

The `pj_ice_sess` API from PJNATH is very good and can be used as a model for constructing our ICE API.

Add local ICE candidate harvesting
----------------------------------

`res_rtp_asterisk` currently harvests local ICE candidates when an RTP instance is created if the `icesupport` option in `rtp.conf` is enabled. For Steel Zebra, this will be altered somewhat. Instead, the ICE engine implemented by Steel Zebra will start gathering local ICE candidates when the `get_local_candidates()` method is called. This way, we will only gather ICE candidates when demanded by the channel driver. Subsequent calls to `get_local_candidates()` may return cached candidates instead of re-learning ICE candidates.

Create an ICE packet router
---------------------------

When ICE is in use, the destination for media packets depends on the results of the connectivity checks performed during negotiation. The ICE packet router will be able to get an appropriate remote address and communicate to the transport in use to use the negotiated address.

Create an RTP ICE engine
------------------------

Steel zebra needs an RTP ICE engine. Many of the calls to the ICE engine will result in direct calls to the new ICE API that was created. The RTP engine's `start` method is appropriate for installing the ICE packet router. The `stop` method can restore the old packet router.

RTP/AVPF (?)
============

RTP/AVPF adds new kinds of RTCP packets and redefines the rules about the intervals between sending RTCP packets. `res_rtp_asterisk` currently supports RTP/AVPF in name only. There is nothing that attempts to modify the RTCP transmission interval, and there is no code to parse the new RTCP packe types defined by RFC 4585. Any work done in this section will be breaking new ground in Asterisk's support of RTP/AVPF.

Create RTP/AVPF RTCP packet decoders.
-------------------------------------

Modify the table of understood RTCP packet types to include RTPFB and PSFB payload types. Currently, it will be good enough to log that these have been received in some way (such as a Stasis Event). It's better than what `res_rtp_asterisk` is currently doing.

Add feedback sending support(?)
-------------------------------

The majority of RTCP feedback defined in RFC 4585 is payload-specific and is mostly based around problems during video reception. Payload-specific feedback would have to be requested by a higher layer than the RTP stack since the RTP stack does not possess the capability to understand payload-specific information. Even transport-specific RTP feedback would need to be initiated by a higher-level construct in Asterisk since it would be responsible for knowing if any packets were missed.

Trickle-ICE (?)
===============

Trickle-ICE is a draft that modifies ICE to be able to initiate connectivity checks before all local ICE candidates have been gathered. Since it is a draft, it is unlikely that we would aim to implement this in the new RTP stack until the draft is finalized into an RFC. Using the current draft as a guide, we can get a good idea of the tasks involved in adding support for Trickle ICE

#### ICE state machine changes

This is where the majority of changes need to take place in order to facilitate Trickle ICE. The state machine has to be updated to take into account that new local candidates can be added after connectivity checks have begun, and the state machine has to be told not to consider ICE negotiation to have failed if connectivity checks fail while local candidates are still being gathered.

The changes to the ICE state machine would require an audit of whether making the appropriate changes to PJNATH is the way to go or if writing our own ICE implementation is the way to go. Having the ICE API as previously defined will make this sort of transition less painful if that is what we deicde to do.

#### RTP glue changes

If we send an RTP offer/answer with ICE candidates and we learn of a new local ICE candidate, we have to be able to "trickle" that candidate to the remote signaling endpoint. This means implementing a new RTP glue callback that channel drivers can implement in order to send an appropriate channel technology message with the trickled candidate.

#### Asynchronous candidate harvesting

Steel Zebra's vanilla ICE implementation will make use of synchronous calls to the ICE API to gather all local candidates at once. With trickle ICE, the calls to the ICE API will need to switch to being asynchronous so that an SDP offer/answer can be sent as soon as it is possible to do so. The most likely way this will happen is to gather host candidates synchronously and send those in the initial offer, and then trickle in server-reflexive, relay, and peer-reflexive candidates as they are learned.

BUNDLE (?)
==========

BUNDLE is a draft that allows for separate media streams in a media session to use a common transport, thus allowing for fewer port allocations on the host and fewer NAT headaches as well. Implementing BUNDLE has challenges since it is inherently a session-level feature, but channel drivers do not have access to an RTP stream.

#### Add necessary SDP parsing to channel drivers

BUNDLE support requires some reinterpretation of SDP from the norm. Specifcially, if an m= line in an SDP has port 0 on it, it does not mean the same thing as it normally does. Channel drivers will need to be capable of not misinterpreting this when BUNDLE is used.

#### Add RTP engine callback for adding a stream to a bundle group

The channel driver calls this function in order to add an RTP instance to a bundle group. This can be as a result of an incoming SDP offer or it can be done on an outgoing SDP offer. The method will take the media identification tag of the stream as well as some identifier for the BUNDLE group. When a Steel Zebra RTP stream is told it belongs to a BUNDLE group, it can relay this information to the RTP session, thus allowing the RTP session to be able to keep track of which RTP streams are bundled. This method will need to have the means of rejecting adding a stream to a bundle group if there are conflicting properties on the stream (such as differing transport protocols between the streams).

#### Add RTP engine callback for setting a BUNDLE address

This is called on the RTP instance whose local address has been chosen as the BUNDLE address for the session. The RTP stream will need to communicate to the RTP session that it has been selected. The RTP session can then point the other streams in the BUNDLE group to the chosen stream's transport and packet router so they all use the same one.

Also at this point, the RTP session will need to add a stream selection plugin to the chosen stream's decoder so that after the RTP header can be decoded and then sent to the appropriate stream for further processing. This can be a bit complicated since different streams may have different decoding steps required (e.g. an audio stream uses RTP/AVP and a video stream uses RTP/SAVPF). This means that the initial part of a decode may be performed by one decoder, but a subsequent decode step may be performed by a separate decoder. Getting this to work will sure be fun!
