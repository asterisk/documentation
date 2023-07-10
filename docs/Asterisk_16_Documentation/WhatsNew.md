---
title: New in 16
---

# What's New in Asterisk 16

## WebRTC


Work has been done to improve the quality of the video experience in Asterisk with WebRTC. Both REMB and NACK are now supported. REMB allows the measured available bandwidth of each client to be aggregated and sent back to the sender of video, allowing the encoding size to be reduced to better fit available bandwidth. NACK allows ensures that out of order packets or lost packets are better handled by allowing each client to request retransmission or for Asterisk itself to request retransmission from the client.

For further details about REMB check out our [blog post](https://blogs.asterisk.org/2018/05/16/receiver-estimated-maximum-bitrate-support/) about it and for NACK you can check out the [blog post](https://blogs.asterisk.org/2018/05/02/rtp-retransmission-for-video-to-combat-packet-loss/) about it.

## PJSIP Performance

Qualify performance for PJSIP has been improved to allow a high number of AORs with no penalty on startup time and with reduced CPU usage.

## Conference Text Messaging and Events

Text messages sent through a conference bridge using ConfBridge will now be relayed to the other participants.

When configured (using the enable\_events) option the conference bridge will also send a JSON payload as a text message when events happen in the conference bridge to provide information to each client.

## app_originate

The 'a' option has been added which asynchronously places calls. The application will return immediately instead of waiting for the originated channel to answer.

## app_queue


A wrapup time can now be configured on a per-member basis instead of on a per-queue basis for static members as defined in the configuration file.

Predial handler support has also been added so that subroutines can be invoked on the callee or caller channels.

## PJSIP AMI


Additional AMI actions have been added to inspect more information about the configuration. PJSIPShowAors will list the AORs, PJSIPShowAuths will list the authentication sections, and PJSIPShowContacts will show the contacts.

