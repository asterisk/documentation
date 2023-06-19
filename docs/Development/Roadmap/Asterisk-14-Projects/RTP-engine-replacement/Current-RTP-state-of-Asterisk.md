---
title: Current RTP state of Asterisk
pageid: 31752464
---

The API
-------

RTP in Asterisk is managed by a central API defined in `include/asterisk/rtp_engine.h`. It provides a front-end to pluggable RTP engines. The core Asterisk distribution ships with two RTP engines: res\_rtp\_asterisk and res\_rtp\_multicast.

The top-level is mostly used as a front-end to the underlying engines, providing methods for creating RTP instances, setting properties (such as enabling RFC 4733 DTMF, indicating media NAT in existence), reading and writing stream data, and some other miscellaneous utilities.

In addition to the RTP engines, there are other engines as well, such as DTLS engines and ICE engines, each with ICE and DTLS-specific callbacks. These engines currently are implemented within res\_rtp\_asterisk as well.

All RTP engines are hidden from users of the RTP API behind public methods that mostly correlate one-to-one to the various engines.

In the reverse direction, there is an RTP "glue" structure that is used as a go-between between an RTP engine and a channel driver. This can basically be seen as a channel-agnostic way of allowing for an RTP engine to call into a channel driver to get/set information.

Outside of `rtp_engine.h`, there  is also SRTP support within its own module. However, this module registers itself with the RTP engine upon module loading. The SRTP engine is similar to the DTLS and ICE engines in that they provide feature-specific callbacks for SRTP operations. There is also a core SRTP file, `main/sdp_srtp.c` that is responsible for parsing crypto SDP attributes and for getting certain relevant pieces of information (such as the RTP profile to use)

##### Criticisms

The idea of having a pluggable API is commendable. Implementation details may be a bit spottier, though. For instance, in `res_rtp_asterisk`, the RTP engine and ICE engine are very tightly coupled. This is not necessarily a bad thing on its own, except for the fact that the existence of a pluggable architecture does not suggest that this is the case.

I'll touch on this a bit more in the offer/answer section, but the RTP implementation is quite "dumb". An instance gets created and it is up to some higher level to feed it details. For instance, the RTP implementation has to be told what audio/video formats to use for the call. It also has to be told address information. However, this address information may ultimately be ignored if ICE ends up determining a different place to send media than what was in an initial SDP.

Handling incoming RTP/RTCP traffic
----------------------------------

Channels that use RTP can ask for the file descriptors for the incoming RTP and RTCP traffic and set those on the channel. This way, when one of the `ast_waitfor()` family of functions is called, if there is data to be read on one of those file descriptors, it can be read. Both RTP and RTCP traffic are read by having a channel's read callback call into the RTP engine's read callback. If RTCP is being read, then an `ast_null_frame` is returned instead of a voice, video, or DTMF frame.

While it is not formally specified, reading RTP pretty much goes through three phases

1) When the packet is read from the socket, some demultiplexing is done if ICE or DTLS is in use so that we, for instance, do not attempt to process a STUN or DTLS packet as an RTP packet. This demultiplexing also routes the packet through an SRTP unprotect if required.

2) The raw RTP packet is decoded into its header and payload. Checks at the RTP level are performed, such as strict RTP and symmetric RTP.

3) The payload is passed on to payload-specific functions depending on the type of payload. Most payloads have format definitions in Asterisk that take care of the payload, but other things (such as RFC 4733 DTMF) have special handlers in the RTP engine.

Most of the RTP payloads get converted into an Asterisk frame and returned by the read operation. An interesting optimization is when a native RTP local bridge is in effect. Instead of returning a frame, the RTP engine instead writes the RTP frame over to the bridged RTP instance directly and returns an `ast_null_frame`.

RTCP first goes through the same demultiplexing routine that RTP does. Then the compound RTCP packet is examined and each part is used to perform specific tasks. The packet types that do the most processing are the SR and RR packets, which update local stats and generate Stasis messages. The PSFB (VP8-specific) packet type will generate an `AST_CONTROL_VIDUPDATE` frame, but the rest of the RTCP packet types have no effect.

Incoming traffic that is not RTP or RTCP is typically passed off to a separate entity (such as PJNATH for ICE-related traffic or OpenSSL for DTLS traffic) and results in an `ast_null_frame` being returned.

##### Criticisms

I mentioned that there is no formal specification for the steps of handling incoming RTP traffic, but that I had been able to break it up into steps. The majority of incoming RTP handling occurs in one large function. This means that if we want to add processing, it is not an easy thing to know where to insert it.

The fact that all traffic is read from a channel thread is a bit odd. RTCP traffic has nothing to do with the channel, so why does it have the ability to wake a channel up? RTCP traffic ideally would be its own thing and not wake the channel up if data is ready. Same for STUN and DTLS traffic for that matter.

There is no buffering of RTP data at the RTP layer. There may be a jitterbuffer frame hook on the channel that owns the RTP instance, but it is not required. For the case where native RTP bridging is used, we could be sending data at wild intervals completely out of order between the two communicating endpoints. Lack of buffering also means we have no ability to synchronize media from different sources (e.g. lip-sync for audio and video). Synchronization of different media sources would not be helped any by a jitterbuffer.

Sending outbound RTP/RTCP traffic
---------------------------------

When a channel is told to write data (most commonly due to a bridge or file playback), it calls down into the RTP engine to do so. The voice, video, or DTMF frame's payload  has an RTP header enveloped over it. From there, it gets sent to a lower level function to send the data out, protecting the data with SRTP if required. As was mentioned in the previous section, RTP may also be written to a channel at the time that RTP is read from a bridged channel if using a native local RTP bridge.

RTCP, on the other hand has its writes scheduled based on a calculation performed when sending and receiving RTP traffic. The scheduler used for RTCP is passed into the RTP instance creation function and therefore, the threading is managed by the creator of the RTP instance. In the case of `chan_sip` and `res_pjsip_sdp_rtp`, they have all RTCP writes handled by a single thread. In `chan_sip`'s case, it is the monitor thread that also manages incoming SIP traffic, SIP reloads, and other scheduled tasks (such as outgoing registrations and OPTIONS requests).

##### Criticisms

Remember when I said that RTCP was scheduled based on a "calculation"? Well, that's a lie. There is a function to perform a calculation, but instead of actually performing a calculation, it instead just always says to wait 5 seconds between RTCP transmissions. In its defense, there is a todo XXX comment in the function saying to do a more reasonable calculation based on RFC 3550 Section A.7. This comment dates back to June 2006.

There are also some "hidden" writes throughout the RTP code. For instance, when receiving RTP, if we know that we are in the middle of sending DTMF to the user agent from which we are receiving the RTP, we will send a DTMF continuation as part of the read operation. In addition, when using DTLS, there are many times we can end up sending "pending" DTLS traffic.

Offer/Answer negotiation
------------------------

The RTP API does not involve itself in offer/answer negotiation directly. Instead, this is taken care of at a higher level, such as in `chan_sip` or `res_pjsip_sdp_rtp`. These modules will allocate an RTP instance, perform offer/answer negotiation, and set properties on the RTP instance based on the result of that offer/answer negotiation.

As was mentioned earlier in the API section, there are some helper methods in certain places to be able to parse specific types of SDP lines. For instance, the `sdp_srtp.h` API allows for parsing and adding of crypto attributes to streams.

When it comes to ICE, the RTP engine maintains data about the ICE session, including gathering local candidates. However, as far as the content of SDP is concerned, it is up to higher levels to add ICE candidates to outgoing SDPs.

##### Criticisms

Ideally, the RTP layer would be in charge of offer/answer negotiations. One big reason for this is that it would allow for code re-use instead of having to duplicate offer/answer logic in multiple channel drivers.

RTCP Reports
------------

RTCP report calculations are for the most part done exactly as you would expect them to be done. The only criticism (I'm not bothering with a second section) is that the health of a session can't be taken into account since individual streams are completely disconnected from one another.

Other points of interest
------------------------

The RTP API of Asterisk is written in such a way that it does not understand the concept of an RTP session. Rather, each RTP instance is a single stream that has no association with any other streams. Because of this, implementing synchronization of media streams, implementing BUNDLE, and implementing SSRC management becomes difficult.

When ICE is in use, we use PJNATH, which uses PJLIB under the hood. Because of this, all threads that call ICE functions have to be registered with PJNATH. This means that there are several places throughout the code where thread registration checks are performed. This can potentially be redundant and wasteful in threads that call ICE functions multiple times. In threads that rarely call ICE functions, it means that the thread has to get registered with PJLIB for barely any purpose.

