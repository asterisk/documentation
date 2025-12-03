---
title: Simulcast and SVC
pageid: 38764870
---

General
=======

When it comes to acting as an SFU we don't always want to forward a full high quality video stream to each participant. Some participants may only want to see a lower quality version of the other person, until they gave them focus. Depending on bandwidth constraints you may also want to provide a lower quality video stream until bandwidth improves and you can change. This is accomplished by using either simulcast or SVC. Simulcast is the act of sending multiple streams of the same content with different qualities. SVC on the other hand sends a single stream but the video payload itself can yield different qualities depending on which parts are extracted from it.

Simulcast
=========

Support exists for simulcast within both Google Chrome and Firefox. They differ wildly though.

### Chrome

The [Chrome implementation](http://www.rtcbits.com/2014/09/using-native-webrtc-simulcast-support.html) stems from the days of Google Hangouts. It does not implement the RFC and is very simple. Each alternative stream is defined as another SSRC within the SDP and simulcast is enabled by creating a SIM ssrc-group. The quality is fixed within Chrome itself not to exceed specific maximums. The RTCP exchange determines what substreams Chrome will send.

### Firefox

The Firefox implementation follows the [RFC](https://tools.ietf.org/html/draft-ietf-mmusic-sdp-simulcast-10) and defines within the SDP alternative streams. The quality of each is also provided in the SDP, unlike Chrome, as well as the direction. What is not present is the SSRC of the alternative streams. In WebRTC usage you have to associate them by first looking at the [MID RTP extension](https://www.ietf.org/id/draft-ietf-mmusic-sdp-bundle-negotiation-39.txt) to determine what media stream it is for. After that you have to associate it with the alternative stream using the RtpStreamId RTP extension. These together allow you to determine what media stream and substream it is for.

SVC
===

 SVC is a bit of an uncharted territory right now. Support is not widespread. Chrome when simulcast is enabled will also enable SVC, but only for VP8 right now. I think SVC should be left to bake some more and improve first before tackling it.

Asterisk
========

### RTCP

RTCP is critically important for simulcast usage. Extensions like [REMB](https://datatracker.ietf.org/doc/draft-alvestrand-rmcat-remb/), [TMMBR (and PLI)](https://tools.ietf.org/html/rfc5104), and [transport-cc](https://tools.ietf.org/html/draft-holmer-rmcat-transport-wide-cc-extensions-01) allow bandwidth estimation to occur so that remote parties know the conditions and can adjust the video encoding accordingly. They are also important to Asterisk so it can know what streams (when simulcast is in use) to forward depending on the conditions to the remote participant. While simulcast is a huge part of this it is not useful at all without the proper RTCP support.

The data provided by the improved RTCP support will need to be propagated up so higher level implementations can use the information accordingly, for example bridge_softmix to know what simulcast stream to use. This should be done by either providing a new control frame that includes the information, or the existing RTCP frame.

### Streams

Asterisk currently has no way to provide information about substreams. What further complicates matters is that a stream directly maps to an "m=" line in SDP generally, so substreams can not be part of the normal list of streams. I propose that substreams are stored on the main stream itself, and iterators provided. This would allow applications/users to query for substreams and also allow them to request them by creating a topology with substreams placed on the main stream. Frames would also need to be modified to include a substream identifier. This could be used when writing frames out if we wanted to support sending simulcast as well (not just receiving it).

### RTP

Support for the MID RTP extension will need to be added. Support for the RtpStreamId RTP extension will need to be added. Support for setting a substream identifier on an RTP instance will need to be added, and this will need to be present on any frames received. If no SSRC mapping is found the MID and RtpStreamId should be used to determine what RTP instance the packet is for, and then an SSRC mapping added based on that.

### Bridging

Support for mapping not just a stream to a stream but also a stream to a substream will need to be added.

### bridge_softmix

The module will need to react to RTCP information it receives and update the substream mappings accordingly if possible.

### chan_pjsip

Support for the Chrome method of simulcast will need to be added, as well as the RFC implementation. Substreams will be present in the ast_sip_session_media, with 0 being the main stream. This should keep changes fairly minimal.

### Core

The "core show channel" CLI command should be extended to also show substreams.
