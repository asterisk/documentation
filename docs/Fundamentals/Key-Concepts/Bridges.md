---
title: Bridges
pageid: 4817441
---

Overview
========

In Asterisk, a bridge is the construct that shares media among [Channels](/Channels). While a channel represents the path of communication between Asterisk and some device, a bridge is how that path of communication is shared. While channels are in a bridge, their media is exchanged in a manner dictated by the bridge's type. While we generally think of media being directed among channels, media can also be directed from Asterisk to the channels in a bridge. This can be the case in some conferences, where Music on Hold (MoH) or announcements are played for waiting channels.

On this Page


Creation
--------

Generally, a bridge is created when Asterisk knows that two or more channels want to communicate. A variety of applications and API calls can cause a bridge to be created. Some of these include:

* [Dial](/Asterisk-11-Application_Dial) - a bridge is created for the two channels when the outbound channel answers. Both the inbound channel and the outbound channel are placed into the bridge.
	+ DTMF feature invocations available from Dial() can create, modify, or destroy bridges.
* [Bridge](/Asterisk-11-Application_Bridge) - this directly creates a new bridge and places two channels into the bridge. Unlike Dial, both channels have to already exist.
* [BridgeWait](/Asterisk-13-Application_BridgeWait) (Asterisk 12+) - creates a special holding bridge and places a channel into it. Any number of channels may join the holding bridge, which can entertain them in a variety of ways.
* [MeetMe](/Application_MeetMe)/[ConfBridge](/Asterisk-11-Application_ConfBridge) - both of these applications are used for conferencing, and can support multiple channels together in the same bridge.
* [Page](/Asterisk-11-Application_Page) - a conferencing bridge (similar to MeetMe/ConfBridge) is used to direct the audio from the announcer to the many dialed channels.
* [Parking](/Asterisk-13-Application_Park) (Asterisk 12+) - a special holding bridge is used for Parking, which entertains the waiting channel with hold music.

 




---

**Tip: Asterisk 12+: Bridging Changed** In Asterisk 12, the bridging framework that [ConfBridge](/ConfBridge) was built on top of was extended to all bridges that Asterisk creates (with the exception of MeetMe). There are some new capabilities that this afforded Asterisk users; where applicable, this page will call out features that only apply to Asterisk 12 and later versions.

  



---


Destruction
-----------

Channels typically leave a bridge when the application that created the bridge is terminated (such as a conference leader ending a ConfBridge conference) or when the other side hangs up (such as in a two-party bridge created by Dial). When channels leave a bridge they can continue doing what they were doing prior to entering the bridge, continue executing dialplan, or be hung up.

Types
=====

There are many types of bridges in Asterisk, each of which determine how the media is mixed between the participants of the bridge. In general, there are two categories of bridge types within Asterisk: two party and multiparty. Two party bridge variants include core bridges, local native bridges, and remote native bridges. Multiparty bridge variants include mixing and holding.

 




---

**Tip: Asterisk 12+: Bridges are Smart**  In Asterisk 12, the bridging framework is smart! It will automatically choose the best mixing technology available based on the channels in the bridge and - if needed - it will dynamically change the mixing type of the bridge based on conditions that occur. For example, a two-party core bridge may turn into a multiparty bridge if an attended transfer converges into a three-way bridge via the `atxferthreeway` DTMF option.

  



---


Two-Party
---------

A two-party bridge shares media between two channels. Because there are only two participants in the bridge, certain optimizations can take place, depending on the type of channels in the bridge. As such, there are "sub-types" of two-party bridges that Asterisk can attempt to use to improve performance.

### Core

A core bridge is the basic two-party bridge in Asterisk. Any channel of any type can communicate with any channel of any other type. A core bridge can perform media transcoding, media manipulation, call recording, DTMF feature execution, talk detection, and additional functionality because Asterisk has direct access to the media flowing between channels. Core bridges are the fallback when other types of bridging are not possible due to limiting network factors, configuration, or functionality requirements.

two-party300

### Native

A native bridge occurs when both participants in a two-party bridge have similar channel technologies. When this occurs, Asterisk defers the transfer of media to the channel drivers/protocol stacks themselves, and simply monitors for the channels leaving the bridge (either due to hangup, time-out, or some other condition). Since media is handled in the channel drivers/protocol stacks, no transcoding, media manipulation, recording, DTMF, or other features depending on media interpretation can be done by Asterisk. The primary advantage to native bridging is higher performance.

The following channel technologies support native bridging:

* [RTP capable channel drivers](/SIP) (such as SIP channels)
* [DAHDI channels](/DAHDI)
* [IAX2 channels](/Inter-Asterisk-eXchange-protocol--version-2--IAX2-) (Asterisk 11-)




---

**Tip: Asterisk 12+ IAX2 Native Bridging is Gone** As it turned out, IAX2 native bridging was not much more efficient than a standard core bridge. In an IAX2 native bridge, the media must still be handled a good bit, i.e., placed into internal Asterisk frames. As such, when the bridging in Asterisk was converted to the new smart bridging framework, the IAX2 native bridge did not survive the transition.

  



---

#### Local

A local native bridge occurs when the media between two channels is handled by the channel drivers/protocol stacks themselves, but the media is still sent from each device to Asterisk. In this case, Asterisk is merely proxying the media back and forth between the two devices. Most types of native bridging in Asterisk are local.

two-party native local300

#### Remote

A remote native bridge occurs when the media between two channels is redirected by Asterisk to flow directly between the two devices the channels talk to. When this occurs, the media is completely outside of Asterisk. With [SIP](/SIP) channels, this is often called "direct media". Not surprisingly, since the media is flowing outside of Asterisk, this bridge has the best performance in Asterisk. However, it can only be used in certain circumstances:

* Both channels in the native bridge must support direct media.
* The devices communicating with Asterisk cannot be behind a NAT (or otherwise obscured with a private IP address that the other device cannot resolve).

Only [SIP](/SIP) channels support this type of native bridge.

two-party remote native300

Multiparty
----------

Multiparty bridges interact with one or more channels and may route media among them. This can be thought of as an extension to two-party core bridging where media from multiple channels is merged or selected to be forwarded to the channels participating in the bridge. These bridges can have some, all, or none of the extended features of two-party core bridges depending on their intended use.

### Mixing

There are several ways to access mixing multiparty bridges:

* [MeetMe](/Application_MeetMe) - This is a legacy conference bridge application and relies on DAHDI. This type of conference is limited to narrow band audio.
* [ConfBridge](/Asterisk-11-Application_ConfBridge) (Asterisk 11+) - This is a conference bridge application based that supports wide band mixing.
* Ad-hoc Multiparty Bridges (Asterisk 12+) - Some DTMF features like 3-way attended transfers can create multiparty bridges as necessary.

### Holding

Holding bridges are only available in Asterisk 12+ and provide a waiting area for channels which you may not yet be prepared to process or connect to other channels. This type of bridge prevents participants from exchanging media, can provide entertainment for all participants, and provides the ability for an announcer to interrupt entertainment with special messages as necessary. Entertainment for waiting channels can be MoH, silence, ringing, hold, etc.. Holding bridges can be accessed via [BridgeWait](/Asterisk-13-Application_BridgeWait) or [Introduction to ARI and Channels - ARI](ARI-Asterisk-channel-to-endpoint).

multi-party300

