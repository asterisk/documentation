---
title: Notes on RTP standards
pageid: 31752459
---

This page contains a selected list of IETF RFCs and drafts that specify RTP behavior. The goal of this section is not to exhaustively detail the operation of these but rather to describe what sort of alterations to the base implementation each make. From this, we can potentially draw conclusions on how an RTP stack might be architected.

RTP (RFC 3550)
--------------

RTP is an interesting protocol in how lightweight and purposely underspecified it is. From section 1:

> RTP is a protocol framework that is deliberately not complete

> ...RTP is intended to be tailored through modifications and/or additions to the headers as needed

As far as RTP is concerned, the specification is incredibly loose. The specification leaves most of the implementation details to other specifications which define "profiles" for RTP usage. RFC 3550 defines a fixed RTP header, but interestingly does not require that the header be used exactly as defined. From section 5.3

> ...the header MAY be tailored through modifications or additions defined in a profile specification while still allowing profile-independent monitoring and recording tools to function.

and

> If a particular class of applications needs additional functionality independent of payload format, the profile under which those applications operate SHOULD define additional fixed fields to follow immediately after the SSRC field of the existing fixed header

So in other words, it's difficult to impossible to define a universal profile-independent RTP recorder since profiles have the ability to change the meanings of bits in the RTP header and to lengthen the header beyond what is described in RFC 3550.

RTP defines a means of extending the header, as well. This is not to be confused with profile-dependent additions to the fixed RTP header. Section 5.3.1 states

> `Note that this header extension is intended only for limited use. Most potential uses of this``mechanism would be better done another way, using the methods described in the previous section.``For example, a profile-specific extension to the fixed header is less expensive to process``because it is not conditional nor in a variable location.`

The conclusion I gather from this is that writing a general-purpose RTP stack would need to allow for alternate behavior at nearly all stages since a profile could presumably change what the fields in an RTP header mean, could change the expected length of an RTP header, and may variably add extensions to the RTP header. Furthermore, since payloads have the ability to add their own payload-specific metadata to the data portion of an RTP packet, consideration needs to be taken for different payload types to override certain behaviors intrinsic to whatever profile they belong to.

RTCP (RFC 3550)
---------------

In addition to RTP, RFC 3550 defines the RTP control protocol. The RFC goes into specifics, but in general, this is a companion to the RTP stream and allows for metadata about the session to be collected. Metadata includes network conditions (e.g. jitter, packet loss), participants in an RTP session, etc. Unlike with RTP, the RFC goes into much greater detail and does not leave implementation details as open-ended. In fact, to aid in implementation, the RFC goes details algorithms for maintaining and calculating information for RTCP transmissions.

The only mention of profile-specific changes is in section 6.4.3, which indicates that sender reports and receiver reports may be extended by specific RTP profiles. There is leeway built into RTCP to allow some application-specific behavior. For instance, in RTCP SDES, there is a PRIV type that can be used for experimental or application-specific reasons. Similarly, there is an entire RTCP packet type called APP that is application-dependent.

RTP/AVP (RFC 3551)
------------------

This starts out pretty innocuous, mostly just saying "all the defaults from RFC 3550 stand", and then they go and pull this:

> `While CNAME information MUST be sent every reporting interval, other items SHOULD only``be sent every third reporting interval, with NAME sent seven out of eight times within``that slot and the remaining SDES items cyclically taking up the eighth slot, as defined``in Section 6.2.2 of the RTP specification. In other words, NAME is sent in RTCP packets``1, 4, 7, 10, 13, 16, 19, while, say, EMAIL is used in RTCP packet 22.`

OH COME ON, WHAT? RFC 3550 section 6.2.2 doesn't exist!

This profile goes into detail to define its payload space as a set of statically-defined payloads for known audio and video codecs, some unassigned values, and a dynamic range of codecs.

The specification defines some payload codes for common audio and video codecs. Each defined payload type is then talked about in detail, with frame-based codecs getting much more in-depth explanation than octet-based (streamed) codecs. Interestingly, the RFC states that no new static payload types can be defined beyond what is already in this RFC (though there is an RFC that seeks to remove DVI4 from the supported static payload types). All payload types not referenced in this RFC (as well as some within the RFC such as H.263-1998) have to use payload numbers from the dynamic range.

DTMF (and other telephony signals) (RFC 4733)
---------------------------------------------

There are many RFCs that define payload types to be used over RTP. This was picked because it is so commonly used in VoIP telephone calls and may be an indicator of payload-specific special handling required in an RTP stack. Reading this highlights several considerations to take into account:

* RTP payloads, despite carrying the name "audio" in the description, should not be assumed to be voice/video. They can be events, descriptions of tones, or states.
* RTP payloads will often define their own meanings for the M bit in an RTP header. In the case of RFC 4733, the M bit represents the beginning of a telephone event. In AVP, setting the M bit for audio was done for the beginning of a talkspurt. Similar, but not quite the same as here.
* Senders are expected to send the end of event packet a total of three times, the idea being that it minimizes the end of event notification from being lost. This means that certain payload types have their own rules regarding how to transmit data. You can't always assume that one event/frame/etc. equates to one transmission. The inverse of this had already been established by RFC 3551, which explains that frame-based codecs can have multiple frames expressed in a single RTP packet.
* Receivers of RFC 4733 events are expected to be able to know about unrelated packets in the stream. For instance, the RFC defines an E bit that is supposed to be set once a tone has ended. However, it is possible that network conditions could result in the packet(s) with the E bit set being lost. Therefore, the RFC has a couple of fallbacks to avoid a tone lasting forever. For one, if a new tone is received, then obviously that ends the earlier tone and starts the new one. However, if the tone is standalone, then the RFC also suggests ending the tone if a non-tone packet on the stream is received and requires that if three packet arrival times elapse without a tone continuation packet, the tone ends. Therefore, a handler for RFC 4733 RTP payloads needs to be made aware of other audio packets that arrive, and if a timer is employed to indicate read-out times, then

SRTP (RFC 3711)
---------------

This document creates a new RTP profile, called RTP/SAVP. From section 3:

> 
> ```
> We define SRTP as a profile of RTP.  This profile is an extension to the RTP Audio/Video Profile [[RFC3551](https://tools.ietf.org/html/rfc3551)].
> ```
> 
> ```
> Except where explicitly noted, all aspects of that profile apply, with the addition of the SRTP security features.
> ```
> 
> ```
> Conceptually, we consider SRTP to be a "bump in the stack" implementation which resides between the RTP application
> ```
> 
> ```
> and the transport layer.  SRTP intercepts RTP packets and then forwards an equivalent SRTP packet on the sending
> ```
> 
> ```
> side, and intercepts SRTP packets and passes an equivalent RTP packet up the stack on the receiving side.
> ```
> 

At the outset, this looks like the RTP/SAVP won't add special behavior for audio/video processing, aside from the "except where explicitly noted" sections. Hopefully there will be very few of these and they won't be a nuisance. So far, the only things I'm noticing are additions to RTP and RTCP packets that, once processed, should behave the same as RTP/AVP.

RTP/AVPF (RFC 4585)
-------------------

This RFC registers the RTP/AVPF profile. It specifically lays out up front that it works the same as RTP/AVP, except that it defines some extra RTCP message types and adds some further considerations for congestion control.

In section 3.2, it outlines the rule changes from RFC 3550 with regards to RTCP transmission intervals. The minimum 5 second interval is not enforced and instead the bandwidth of the connection is used to determine the interval (though a minimum may still be optionally selected). Sending packets early is referred to, appropriately, as "early RTCP". Early RTCP follows its own rules about what types of RTCP packets can make up the compound RTCP packet. Honestly, it's a bit of a mess. The rules are:

* I decide I need to send a feedback packet, and I want to send it NOW, not at the next interval
* I wait a brief period to make sure no one else that noticed the event has already sent their own feedback packet.
* I have to check if early feedback is permitted.
* I can send an an early feedback packet if all the above are fulfilled.

So in order to send RTCP feedback, I modify timing with regards to sending RTCP, I can violate those timers and send early feedback, I have to insert small intervals in timing to allow for other feedback senders to send their feedback first, I have to determine permissiveness of sending early feedback.

Or I can just add feedback to my compound RTCP packets I'm already sending. I think I know how I'd implement this if given the choice...

Like with everything so far, capabilities for understanding specific pieces are conveyed in the SDP.

RTP/SAVPF (RFC 5124)
--------------------

As the name implies, this is is an RTP profile that combines RTP/SAVP and RTP/AVPF into a single profile that has features of both. From section 1:

> 
> ```
>    As SAVP and AVPF are largely orthogonal, the combination of both is
>    mostly straightforward.  No sophisticated algorithms need to be
>    specified in this document.  Instead, reference is made to both
>    existing profiles and only the implications of their combination and
>    possible deviations from rules of the existing profiles are described
>    as is the negotiation process
> ```
> 

The disturbing thing about reading this RFC is that if a third common RTP profile were to be created (say, AVTP), then there would presumably be SAVTP, AVTPF, and SAVTPF profiles that would need to be created for it. This is not cool.

Luckily, this RFC is short and to the point. It basically just provides clarification that SAVP and AVPF can be used together. There is nothing new provided here, but clarifications are made where they are deemed necessary.

DTLS-SRTP (RFC 5764, RFC 5763)
------------------------------

RFC 5764 defines a means of using DTLS as a transport for SRTP traffic. The majority of the implementation work would actually be taken care of by third party tools (such as OpenSSL). However, there are some de-muxing activities that an RTP implementation would have to perform. I won't quote it, but in section 5.1.2, it outlines how the first byte of incoming packets needs to be examined to determine if the incoming packet is RTP, STUN, or DTLS. We would have to perform this check ourselves.

RFC 5763 details the process of setting up DTLS using SDP, and includes notes about how features like ICE affect behavior. The SDP is modeled after RFC 4145's method of setting up TCP media sessions. Interestingly, this RFC also stipulates that in order to be supported, an implementation MUST also support RFC 5939 (SDP capability negotiation). Unlike a shocking number of RFCs I've viewed, this one actually has some example message flows and therefore is quite nice.

ICE (RFC 5245)
--------------

ICE provides a unifying document that is intended to be the one-stop shop that describes how to communicate in NATted environments. ICE is an incredibly pervasive thing:

* ICE needs to be part of the offer/answer exchange in order to add candidates to the outgoing offer/answer, and be told of remote candidates in the incoming offer/answer.
* Supporting ICE means implementing a STUN and TURN client in order to gather local candidates and perform connectivity checks
* Supporting ICE means implementing a STUN server as well for incoming connectivity checks. STUN binding requests arrive the same place as media would, so demultiplexing is necessary in the RTP stack.
* ICE can have direct effects on SIP behavior as well. If you're curious what I'm talking about, read Section 12 of the RFC.
* ICE's required keepalives mean that ICE could be the impetus to restart ICE in case a remote endpoint no longer appears to be alive.
* Most of the work ICE does is orthogonal to the rest of the media stack, so it can safely run in parallel to most other operations.
* ICE has some direct effects on the RTP as well
	+ ICE makes the determination of what source and destination addresses on which to send media.
	+ ICE can drop media that the RTP stack wants to send if connectivity checks have not yet completed.
	+ ICE may set the marker bit on RTP packets if we switch which candidate pair we are sending media on.

ICE also MAY have negative interactions with direct media. I have not seen any indication that a reinvite is allowed to stop using ICE for a stream in order to re-route the stream to a remote endpoint.

ICE has a flavor called "ICE lite" that may be used by peers, which means that we essentially have to have two separate ICE stacks in place in order to deal with the remote peer being an ICE-lite user or a full ICE user. We, of course, will only ever use full ICE ourselves.

Trickle-ICE (draft-ietf-mmusic-trickle-ice)
-------------------------------------------

This modifies the behavior of ICE by essentially making it asynchronous. Rather than waiting for all local candidates to be learned before sending an offer or answer, trickle ICE allows for candidates to be sent as they are learned instead. It also allows for connectivity checks to be performed as soon as candidate pairs can be created. It makes modifications to language from RFC 5245 in order to not claim check lists have failed prematurely. Interestingly, this draft mentions the recommendation of using RFC 3388 (which is actually obsoleted by RFC 5888) MIDs in order to associate new ICE candidates with an existing media offer.

The method of indicating new candidates the remote entity is not mentioned in this draft. For SIP, draft-ivov-mmusic-trickle-ice-sip has been defined. It specifies using the INFO method with a newly-defined INFO package in order to trickle in new candidates. This means that in addition to RTP stack changes, some SIP-level changes would need to be made in order to understand the new INFO package, as well as have the ability to signal to the RTP layer that new candidates have been trickled in. It also means that there has to be a common interface (independent of which Asterisk SIP implementation is in use?) that allows for the RTP layer to send a SIP INFO when new local candidates are harvested.

BUNDLE (draft-ietf-mmusic-sdp-bundle-negotiation)
-------------------------------------------------

BUNDLE is a draft that allows for multiple media streams to be multiplexed onto the same transport address. This is an extension of RFC 5888 (already mentioned above in Trickle-ICE as a prereq). This also has the requirement of using draft-ietf-mmusic-sdp-mux-attributes.

Ugh, this one is a confusing mess. I've had to re-read many sections because the language is unclear, and there are still some concepts (such as the answerer choosing the offerer bundle address) that after rereading and looking at the examples still make no sense.

This once again completely changes the entire offer-answer methodology.

Also, the usefulness of BUNDLE diminishes when ICE is used. When a BUNDLE offer is generated, in anticipation of the far end possibly not supporting BUNDLE, an offerer must supply unique addresses (or at least ports) for each bundled m= line. Section 11.2.1 stipulates that unique ICE candidates must also be generated for each m= line in the offer. This means that if the offerer is behind NAT, then it must perform STUN and/or TURN requests to create pathways for unique source ports. The end goal is for the answerer to support BUNDLE and select an offerer address for all bundled media to use, thus only actually needing the ICE candidates from one of the m= lines, but the damage has already been done. We could mitigate this by forcing "bundle-only" streams. In fact it's not really a bad idea to do that since we likely would force people to enable bundle support and they'd only want to do that when communicating with bundle-capable endpoints.

The draft also specifies an RTCP SDES item and RTP header extension that can be used to associate an SSRC with a particular media stream by including the media identification tag in the RTP/RTCP packet. Now, the draft never says this, but to me, it seems like it might be possible to re-use address/port combinations across BUNDLE groups as long as you guarantee that you are generating globally unique media identification tags in your SDPs and that the entities you communicate with use globally unique SSRC identifiers.

Others
------

* RFC 5761: Multiplexing RTP and RTCP on the same port: This has been touched on by other RFCs. This extends the offer-answer model by indicating that this is supported and adds more demultiplexing logic into packet reception
* RFC 5285: General mechanism for RTP header extension: I didn't read this because I don't really care. Since we're not actually extending RTP headers but reading extensions in RTP headers, this probably doesn't really matter.
* RFC 5506: Reduced sized RTCP: This changes how RTCP is decoded.
* RFC 6904: Encryption of RTP header extensions: This is an extension to SRTP for encrypting header extensions. This factors into the logic for encrypting and decrypting header extensions and likely can plug into the stack at some point.
* RFC 2198: RTP payload for redundant data: I didn't read this.
* RFC 4961: Symmetric RTP: This basically codifies what a lot of people were already doing in order to get around NATs. We already do this in Asterisk through a config option.
* RFC 4145: Setting up TCP media sessions in SDP: I only skimmed this, but it does show that it is possible for media streams to use transports other than UDP. The examples in the RFC highlight the usefulness for UDPTL streams, but there is nothing that precludes the use of this specification for RTP/RTCP as well.
* RFC 4572: Setting up TCP/TLS media sessions in SDP: Like RFC 4145, this specifies how TCP/TLS can be used for media instead of UDP.
