---
title: Stream Support Across Asterisk
pageid: 37455188
---

Streams! We've got streams!
===========================

Stream support has been merged into Asterisk as of 15. This has been done in a backwards compatible manner, allowing existing applications/APIs/components to remain untouched. Core APIs which interact with media have become a facade over the multistream support, presenting only the first media stream of each type which mirrors pre-15 behavior. Now that we have support it is time to discuss how existing functionality should be updated to take advantage of multiple streams and provide a better experience. This can thankfully be done over time. Items below are listed in order of difficulty (from least difficult to most) and also based on dependencies.

!!! note 
    The following recommendations assume that changes to APIs will prefer adding to them, and not removing or changing existing elements. Ideally anything written against them should build and behave as they do today. The same goes for dialplan functions or applications. Existing arguments should work as they do today.

[//]: # (end-note)

!!! info ""
    If you are reading this and have any questions consulting the [asterisk-dev mailing list](https://groups.io/g/asterisk-dev) or the [#asterisk-dev](/Asterisk-Community/IRC) IRC channel are the best venues for discussion.

[//]: # (end-info)

AMI Events
==========

When a channel is output into AMI the event should also contain information about the streams on the channel. This should include the name, type, formats, and state.

ARI Output
==========

When a channel is output into ARI the output should also contain information about the streams on the channel. This should include the name, type, formats, and state.

func_channel
=============

The dialplan function should be extended to allow retrieving information about the streams on the channel. This should include how many there are and individual stream details (name, type, formats).

res_mutestream
===============

This module should be updated to allow specifying what stream to mute, or if all streams should be muted. Since this uses a common core API (ast_channel_suppress) that API will need to be updated first to allow this. Two new API calls, ast_channel_suppress_stream and ast_channel_unsuppress_stream, should be added that take in a stream position on a channel (instead of a frame type) and mute specifically that stream.

Unreal/Local Channels

Unreal channels are used by Local channels and other things to create a virtual channel and use it in some manner. In one case it may be to have a channel in a bridge while the other side of it is playing audio. In the Local channel case it is to have one channel doing something while the other executes dialplan. Currently these channels do not take any notice of the stream control frames that are passing through them. They should take notice of one: the notice that the stream topology has changed. If this is received the stream topology on the appropriate channel should be updated to reflect what is present on the other side. Currently this isn't actually possible, so by updating the stream topology the Unreal channel will actually better reflect reality.

Framehooks
==========

Framehooks currently only hook themselves into the first stream of each type. The API should be extended to add an additional callback which is invoked on all streams. If the framehook implementation implements this callback it receives frames for all streams, with the frame stream_num guaranteed to be the stream position. It is up to the framehook itself to filter things appropriately.

func_jitterbuffer

This module should be updated to allow specifying what stream to place the jitterbuffer on (or even all audio streams). This will leverage the framehooks changes.

func_volume
============

This module should be updated to allow specifying what stream to manipulate volume on (or even all audio streams). This will leverage the framehooks changes.

func_speex
===========

This module should be updated to allow specifying what stream to enact DENOISE or AGC on (or even all audio streams). This will leverage the framehooks changes.

Audiohooks
==========

As they exist now audiohooks hook themselves into every audio frame of the first audio stream that is passing through a channel. The API should be extended to allow hooking into a specific stream (based on stream number). If a user of audiohooks wants to hook into multiple streams they should create an audiohook for each stream. A new API call, ast_audiohook_attach_stream, should be added that adds a stream position parameter which attaches the audiohook strictly to that stream.

func_periodic_hook
====================

This module should be updated to allow specifying what stream to act on. This information will be given to ast_audiohook_attach_stream. This will leverage the audiohooks changes.

func_talkdetect
================

This module should be updated to allow specifying what stream to act on. This information will be given to ast_audiohook_attach_stream. This will leverage the audiohooks changes.

Channel Translation
===================

Translation currently only reliably creates a translation path for the audio portion of a channel. Since a channel may have multiple streams on it it should be possible for each stream on a channel to have a read and write format set on it, allowing translation of that specific stream. Translation paths should be stored based on stream number on a channel with the existing API calls using the default audio type stream. New API calls should be added (ast_set_stream_read_format, ast_set_stream_write_format, etc) which control the translation for each individual stream. When a topology is set on the channel the translation paths should be reconciled such that any existing requested formats are maintained if possible. Streams may need to be extended to also have a format capabilities which are the active formats (not just the negotiated ones). This would allow more intelligent translation path choice. The ast_channel_make_compatible_helper function also needs to be updated to be aware of individual streams and set up translation paths on them accordingly.

RTP Native Bridging
===================

A new glue interface should be defined that allows retrieving an RTP instance based on stream position, querying whether bridging is permitted given an RTP instance and a stream number, indicating that streams are about to be native bridged, specifying a stream on the channel is remotely bridged to another RTP instance, and indicating that all native bridge requests are complete. This would allow the updating of each RTP instance with remotely bridging information to be done as separate calls instead of being done in a single call. Code would retrieve all the RTP instances for streams, indicate that native bridging is to begin, individually set each stream to be bridged, then indicate it is finished. Only at this point would the underlying channel driver act on the request. In SIP this would result in a reinvite. The bridge_native_rtp module ideally should support interop between both glues as best as possible, but at a minimum allow old glue and old glue to work with each other.

File Playback/Recording
=======================

A container format will be implemented which supports multiple streams within itself. Based on the characteristics of the streams the best file will be chosen and played back. The channel should be renegotiated to the stream topology of the underlying file. Each stream within the container will be played out (if the topology doesn't match then the possible streams are played out). For existing files without a container then it should behave as today - playing out to the default streams. The file playback/recording API will be updated to include knowledge of streams. Since this is one of the oldest APIs in Asterisk discussion will need to occur about how exactly that will look, as well as what container should be used.

ConfBridge Recording
====================

Right now ConfBridge only saves the mixed audio stream. Taking advantage of the file recording and Unreal channel changes the recording should be updated to record all streams (including the mixed audio) into a container.

MixMonitor
==========

Since MixMonitor is built on audiohooks it only mixes and saves the first audio stream. The code should be changed to also mix and save other audio streams on the channel if told to do so. This can leverage the file recording changes to store them.
