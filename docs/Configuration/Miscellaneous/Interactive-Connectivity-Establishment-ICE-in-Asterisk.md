---
title: Interactive Connectivity Establishment (ICE) in Asterisk
---

Overview
========

If an Asterisk server (or any VoIP server for that matter) is directly accessible on the Internet and and is being "called" by the average SIP softphone or appliance, chances are that turning "on" a check box or maybe some STUN server configuration is all that is needed to make everything "just work". Likewise, configuration is straightforward when servers and phones are on the same local network. If host A and host B are both behind *network address translation* (NAT) firewalls and they need to be able to connect and transmit and receive live data, things can become more difficult. If the networks are very basic, relatively static and the NAT sufficiently configurable, it may be possible to successfully configure a solution (DMZ's, port forwarding, etc). However, add a little additional complexity and things quickly become difficult. Common examples are: layers of NATs between A and B, dynamic address allocation, highly restrictive firewalls, shifting network configurations. Even if configuration is possible, it is burdensome to maintain and can be prohibitively costly in time and resources. The problem is common and severe enough that the VoIP community has been working on solutions for some time. The *Interactive Connectivity Establishment* protocol, or ICE, is a relatively recent and promising approach to resolving these kinds of problems.

Support for ICE was added to Asterisk in version 11. ICE is a standardized mechanism for establishing communication suitable for live media streams between software agents running behind NAT firewalls. Establishing connections through NATs is referred to as *traversing* the NAT. To achieve this, the ICE protocol defines:

* a series of tests for determining internally and externally accessible IP addresses;
* a standard form for specifying a set of prioritized candidate IP addresses in SDP that can be used to reach a software agent in an *offer*;
* a series of operations for validating potential candidates and matching with local candidates to the offered candidates, resulting in candidate pairs;
* a standard form for providing an *answer* specifying validated candidates; and
* a series of rules for picking which candidate pair to ultimately use.

There are mechanisms other than ICE that can be used to communicate through NAT firewalls. They generally require specialized end-to-end configuration or fragile assumptions that may not always be valid. With some basic general configuration (i.e. the hostname of a STUN or TURN server), ICE takes a logical approach to an optimal connection. Configured with available TURN server(s), ICE will even find a successful connection "through" symmetric NATs. In short, if all the software agents are properly configured, ICE will *find a way if there is a way*. It is worthwhile noting that while ICE is intended for RTP, there are other standard mechanisms for SIP messaging through firewalls.

There is a lot to ICE that is beyond the scope of this document. For in-depth detail, see the links to the relevant RFCs below. While the RFCs contain a lot of information, it is mostly oriented at implementation of the ICE protocol and is not necessary for using Asterisk's ICE support. At a user level ICE uses SDP offer/answer, so the general concepts are fairly easy to follow for those familiar with SIP. Also, the details of visually interpreting candidate lists are fairly straightforward and are as easily digestible as media format SDP after a small amount of practice.

Configuring ICE Support in Asterisk
===================================

Enabling ICE Support
--------------------

Asterisk ICE support is enabled globally by default throughout Asterisk, but is disabled by default for chan\_sip specifically, and can be enabled inside **chan\_sip** both globally or on a SIP peer basis in **`sip.conf`**.

icesupport=yesHowever, as ICE needs a STUN and/or TURN server to gather usable candidates, these do need to be configured to get things working. Since ICE is an RTP level feature, the configuration can be found in the `rtp.conf` file. The configuration applies to all RTP based communications so the options are set in the `general` section. To configure a STUN server add a `stunaddr` option with the hostname of the STUN server. For example,

 
stunaddr=setyourphaserson.stun.org 
*A short list of publicly accessible STUN servers can be found at the [VoIP-Info's STUN](http://www.voip-info.org/wiki/view/STUN) page.*

TURN servers are required for relay candidates and are configured through the `turnaddr` property. TURN servers often require authentication so options are provided for configuring the username and password.

 
turnaddr=4everyseason.turn.org 
turnusername=relayme 
turnpassword=please 
The `turnport` option can also be used if the TURN server is running on a non-standard port. If omitted, Asterisk uses the standard port number 3478.

Successful configuration can be visually verified by turning SIP debugging on (`sip set debug on`) in an Asterisk console and looking at INVITE messages as they go past. The body of a typical message would look something like this:

 
0: v=0 
1: o=root 1903343929 1903343929 IN IP4 10.0.1.40 
2: s=Asterisk PBX SVN-trunk-r372051 
3: c=IN IP4 10.0.1.40 
4: t=0 0 
5: m=audio 17234 RTP/AVP 0 3 8 101 
6: a=rtpmap:0 PCMU/8000 
7: a=rtpmap:3 GSM/8000 
8: a=rtpmap:8 PCMA/8000 
9: a=rtpmap:101 telephone-event/8000 
10: a=fmtp:101 0-16 
11: a=silenceSupp:off - - - - 
12: a=ptime:20 
13: a=ice-ufrag:0d9cc44338ad8ced48b2d92c34556f4e 
14: a=ice-pwd:193c1361446d012a1e298d5278b5c4b6 
15: a=candidate:Ha000128qZ 1 UDP 2130706431 10.0.1.40 17234 typ host 
16: a=candidate:Ha00030f 1 UDP 2130706431 10.0.3.15 17234 typ host 
17: a=candidate:S8e86c939 1 UDP 1694498815 142.134.201.57 17234 typ srflx 
18: a=candidate:Ha000128 2 UDP 2130706430 10.0.1.40 17235 typ host 
19: a=candidate:Ha00030f 2 UDP 2130706430 10.0.3.15 17235 typ host 
20: a=candidate:S8e86c939 2 UDP 1694498814 142.134.201.57 17234 typ srflx 
21: a=sendrecv 
The lines 13 through to 20 are ICE specific. Lines 13 and 14 are automatically generated and are used to identify a peer endpoint in an ICE session. Lines 15 through 20 are examples of candidates. Lines 17 and 20 are examples of *server reflexive* candidates as indicated by the "type srflx" at the end of the candidate strings. Server reflexive address are obtained through STUN and indicate an external binding on the NAT firewall. There are two because there is one for RTP and one for RTCP. RTP and RTCP candidates are distinguishable by their *component id* , 1 for RTP or 2 for RTCP, and is the 2nd "field" of the candidate string. The candidate strings that end in "typ host" are for *host candidates* and indicate actual network interfaces on the host computer. In this case, the host running Asterisk had two network interfaces, one bound to 10.0.1.40 and one bound to 10.0.3.15.

Disabling ICE Support
---------------------

Generation of SDP for ICE candidate lists can be disabled by adding `the following:`

icesupport=noto the general section in **`sip.conf`** or on a peer-by-peer basis. Since ICE operates on RTP, ICE details are configured in the **`rtp.conf`** file. To disable ICE support in RTP, add the same line to the general section in `rtp.conf`.

References
==========

rfcs RFCS:

[RFC 5245](http://tools.ietf.org/html/rfc5245) Interactive Connectivity Establishment (ICE): A Protocol for Network Address Translator (NAT) Traversal for Offer/Answer Protocols   
 [RFC 5389](http://tools.ietf.org/html/rfc5389) Session Traversal Utilities for NAT (STUN)   
 [RFC 5766](http://tools.ietf.org/html/rfc5766) Traversal Using Relays around NAT (TURN): Relay Extensions to Session Traversal Utilities for NAT (STUN)

