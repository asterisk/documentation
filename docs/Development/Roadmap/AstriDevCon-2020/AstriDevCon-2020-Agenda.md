---
title: AstriDevCon 2020 Agenda
pageid: 44798887
---

Date
----

Discussion items
----------------



| Time | Item | Who | Notes |
| --- | --- | --- | --- |
| 10:15-11 | State of Asterisk Talk | Matthew Fredrickson | Link to presentation:  |
| 11-11:45 | Asterisk 18 - Codec Work | George Joseph | Link to presentation:  |
| 11:45-1:15 | Lunch |  |  |
| 1:15 | Start building detailed agenda |  |   |

 

Afternoon topics:

* Outbound ARI discussion (websocket initiates from Asterisk rather from external agent)
* Are there ways to improve bug reports on the public issue tracker?
	+ PCAPs
	+ Core dumps
	+ sipp scenario files
	+ Maybe adding a bounty flag on the tracker so that people could figure out which ones have bounties attached.
* What happened to the bridge created event in ARI (not showing up until first channel is added)?
	+ Handling on [-dev list](http://lists.digium.com/pipermail/asterisk-dev/2020-October/078019.html)
* Is there additional information that needs to be added to certain debug/error/warning messages to better understand the original source of error?
	+ Consistent identifying attributes on log messages (IAX, chan\_sip) - owner information, callId/reference.
	+ Add log message per channel driver linking channel\_id and channel\_name and protocol specific callId/callref
	+ Would helper functions help enforce this?
* Group photo
* Discussion around challenges supporting queue strategy changes for dynamic environments
* Adapting codec quality to the network (potentially using RTCP feedback or native means)
	+ Feedback to sender to alter sending
	+ Handled in codec module (callback exists to provide RTCP information so codec module can adjust)
	+ End to end sequence number preservation exists now to help determine gaps for codec implementations
* Improved RTCP stats logging
	+ Ability to disable RTCP messages in AMI
	+ Would be nice to get RTCP stats in stasisend event (due to not having access in ARI after stasis end)
	+ Ability to add to CDR log or CEL event log would be neat.  Perhaps using custom CDR log.
	+ Better documentation and easier to find
	+ Do access to things work in hangup handlers?
* Are there challenges that people have with provisioning fleets of Asterisk instances in the cloud?  (missing provisioning APIs, logging interfaces, ...)?
	+ Nice to have a solid ARI version of app\_voicemail that works well across multiple instances (all playing together well with recordings, metadata, etc)
	+ Challenges with the way files are stored with app\_voicemail across multiple instances of Asterisk and shared file stores.
	+ It would be nice to record files and send them to another server directly from Asterisk (maybe using remote FTP/HTTP storage or something of that nature).  We can already playback remotely, why not recording as well?
* What would be interesting to see next?
	+ Blind transfer across Asterisk instances
	+ Media failover (between Asterisk instances when one fails or for draining of calls from one misbehaving instance to another).
	+ PauseRecording/UnPauseRecording support in mixmonitor is missing - recommended workaround is to use mixmonitor stop and then mixmonitor append.
	+ Better handling of RTP header extensions in Asterisk. (passthrough or processing of radio related header, potentially also for webrtc and other header extensions)
	+ Optimistic encryption support when using DTLS with chan\_pjsip

 

