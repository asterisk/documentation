---
title: SFU Test Coverage
pageid: 40141070
---

Overview
========

Asterisk 15 introduced a new feature that allows you to utilize multiple streams (both audio and video) to create cool applications for things like video conferencing. Some tests were created to ensure that everything is working as intended, and this wiki page aims to document those tests as well as older ones that are still relevant to SFU (selective forwarding unit) test coverage. This will help us understand the depth of coverage we have for SFU testing and what needs to be done in the future to provide a solid foundation.

To get started with SFU testing and WebRTC, look at .

This page covers areas that are catered towards SFU coverage with streams. Other things, such as fax, will need to be investigated as well but have been left out for the purpose of this page.

Testsuite: Pre Asterisk 15
--------------------------

Some tests that were introduced in versions prior to the release of Asterisk 15 but are still relevant to SFU test coverage (at least for future test reference).

* audio-video
	+ multiple-audio
		- accept inbound offer with multiple audio streams and one video stream, but only accept the first audio stream and the video stream
	+ multiple-video
		- accept inbound offer with multiple video streams and one audio stream, but only accept the first video stream and the audio stream
	+ codec-mismatch
		- accept inbound request with audio codec mismatch
		- accept inbound request with video codec mismatch
		- decline inbound request with codec mismatch (both audio and video)
	+ hold-declined
		- offer with an audio stream and an inactive video stream, establish a connection, then send a re-invite with audio on hold and get a 200 OK response
	+ initial-declined
		- respond with a 488 to an offer with a declined audio / video stream matching the codecs of the endpoint
* video
	+ multiple-video
		- accept inbound offer with multiple video streams, but only accept the first stream and decline the others
* audio
	+ multiple-audio
		- accept inbound offer with multiple audio streams, but only accept the first stream and decline the others
* audio-video-app
	+ accept inbound offer with one audio stream and one video stream, but decline application streams
* hold-inactive
	+ audio
		- test holding an audio stream with a re-invite as well unholding

Testsuite: New In Asterisk 15
-----------------------------

The tests added in Asterisk 15 are all under **tests/channels/pjsip/sdp\_offer\_answer/incoming/nominal/multiple-media-stream**.

* audio-video
	+ bundled
		- accept inbound offer with multiple video streams and one audio stream and bundled enabled
	+ multiple-audio
		- accept inbound offer with multiple audio streams and one video stream
	+ multiple-video
		- accept inbound offer with multiple video streams and one audio stream
* video
	+ multiple-video
		- remove multiple video streams once a call has been established
		- accept inbound offer with multiple video streams
		- add multiple video streams once a call has been established
* audio
	+ multiple-audio
		- remove multiple audio streams once a call has been established
		- accept inbound offer with multiple audio streams
		- add multiple audio streams once a call has been established

Unit Tests
----------

A comprehensive list of unit tests that are relevant to streams.

* test\_core\_format.c
	+ test creation of a format
	+ test creation of a format with attributes
	+ test retrieval of format attributes
	+ test cloning of a format
	+ test comparison of two different formats with same codec
	+ test comparison of two different formats with different codec
	+ test comparison of two different formats with attributes with same codec
	+ test joint format creation using two different formats with same codec
	+ test joint format creation using two different formats with attributes and with same codec
	+ test that there is no joint format between two different formats with different codec
	+ test copying of a format
	+ test that attribute setting on a format without an interface fails
	+ test that attribute retrieval on a format without an interface fails
	+ test that sdp parsing on format without an interface fails
	+ test that sdp parsing and generation on format with an interface succeeds
* test\_format\_cache.c
	+ test that adding a cached format succeeds
	+ test that adding acached format multiple times succeeds
	+ test that adding a NULL or empty format to the cache does not succeed
	+ test that getting of a cached format succeeds
	+ test that getting of a non-existant cached format does not succeed
* test\_format\_cap.c
	+ test that allocation of a format capabilities structure succeeds
	+ test that adding a single format to a format capabilities structure succeeds
	+ test that adding multiple formats to a format capabilities structure succeeds
	+ test that adding all formats to a format capabilities structure succeeds
	+ test that adding of all audio formats to a format capabilities structure succeeds
	+ test that adding a single format multiple times to a capabilities structure results in only a single format
	+ test that appending video formats from one capabilities structure to another succeeds
	+ test that appending capbailties structures multiple times does not result in duplicate formats
	+ test that global framing on a format capabilities structure is used when it should be
	+ test that removing a single format form a format capabilities structure succeeds
	+ test that removing a format from a format capabilities structure containing multiple formats succeeds
	+ test that removal of a specific type of format from a format capabilities structure succeeds
	+ test that removal of all formats from a format capabilities structure succeeds
	+ test that getting a compatible format from a capabilities structure succeeds
	+ test that checking whether a format is compatible with a capabilities structure succeeds
	+ test that getting the compatible formats between two capabilities structures succeeds
	+ test that checking if there are compatible formats between two capabilities structures succeeds
	+ test that obtaining the names from a format capabilities structure produces the expected output
	+ test that we can get the best format type out of a capabilities structure
* test\_jitterbuf.c
	+ tests the nominal case of putting audio data into a jitter buffer, retrieving the frames, and querying for the next frame
	+ tests the nominal case of putting control frames into a jitter buffer, retrieving the frames, and querying for the next frame
	+ every 5th frame sent to a jitter buffer is reversed with the previous frame, the expected result is to have a jitter buffer with frames in order, while a total of 10 frames should be recorded as having been received out of order (voice & control frames)
	+ every 5th frame that would be sent to a jitter buffer is instead dropped, when reading data from the jitter buffer, the jitter buffer should interpolate the voice frame
	+ every 5th frame that would be sent to a jitter buffer is instead dropped, when reading data from the jitter buffer, the jitter buffer simply reports that no frame exists for that time slot
	+ every 5th frame sent to a jitter buffer arrives late, but still in order with respect to the previous and next packet (voice & control)
	+ tests overfilling a jitterbuffer with voice frames
	+ tests overfilling a jitterbuffer with control frames
	+ tests sending voice frames that force a resynch
	+ tests sending control frames that force a resynch
* test\_stream.c
	+ test that creating a stream results in a stream with the expected values
	+ test that creating a stream with no name works
	+ test that changing the type of a stream works
	+ test that changing the formats of a stream works
	+ test that changing the state of a stream works
	+ test that creating a stream topology works
	+ test that cloning a stream topology results in a clone with the same contents
	+ test that appending streams to a stream topology works
	+ test test that setting streams at a specific position in a topology works
	+ test that deleting streams at a specific position in a topology works
	+ test that creating a stream topology from format capabilities results in the expected streams
	+ test that getting the first stream by type from a topology actually returns the first stream
	+ test that creating a stream topology from the setting of channel nativeformats results in the expected streams
	+ test that setting a stream topology on a channel works
	+ test that writing frames to a non-multistream channel works as expected
	+ test that writing frames to a multistream channel works as expected
	+ test that reading frames from a non-multistream channel works as expected
	+ test that reading frames from a multiestream channel works as expected
	+ test that an application trying to change the stream topology of a non-multistream channel gets a failure
	+ test that a channel requesting a stream topology change from a non-multistream application does not work
	+ test that an application changing the stream topology of a multiestream capable channel recieves success
	+ test that a channel requesting a stream topology change from a multistream application works
	+ test that converting a stream topology to format capabilities results in expected formats
	+ test that creating as stream topology map works

Improvements
------------

While we do have decent test coverage, there's always room for improvements! This list can and should be contributed to with scenarios that will help strengthen SFU test coverage.

* bundled
	+ accept inbound offer with multiple audio streams and one video stream and bundled enabled
	+ accept inbound offer with multiple audio and video streams and bundled enabled
* audio-video
	+ accept inbound offer with audio and video then remove all audio streams
	+ accept inbound offer with audio and video then remove all video streams
	+ add a video stream once a call has been established with audio and video
	+ decline inbound offer with no streams
* video
	+ accept inbound offer with multiple video streams then hold a certain number of video streams
	+ accept inbound offer with multiple video streams then add an audio stream
	+ accept inbound offer with multiple video streams, but only allow the maximum allowed number (max\_video\_streams)
	+ offer a set of codecs with multuple video codecs and get them back in priority order
	+ test holding a video stream with a re-invite as well as unholding
* audio
	+ accept inbound offer with multiple audio streams then hold a certain number of audio streams
	+ accept inbound offer with multiple audio streams, then add a video stream
	+ accept inbound offer with multiple audio streams, but only allow the maximum allowed number (max\_audio\_streams)
* outbound
	+ one instance of Asterisk originates an outgoing call with audio and video to SIPp with audio and video, which should succeed, and each side should recieve the other's audio and video steam
	+ one instance of Asterisk originates an outgoing call with audio and video to SIPp with audio only, which should succeed, but SIPp will receive both of the streams from Asterisk while Asterisk receives only the audio stream from SIPp
	+ one instance of Asterisk originates an outgoing call with one audio stream and multiple video streams to SIPp with audio and video, which should succeed with all streams accepted
	+ one instance of Asterisk originates an outgoing call with multiple audio streams and one video stream to SIPp with audio and video, which should succeed with all streams accepted
	+ one instance of Asterisk originates an outgoing call with multiple audio and video streams to SIPp with audio and video, which should succeed with all streams accepted
* general media  

	+ run through some of the tests and use a packet sniffer or some other to tool to ensure audio / video is working as intended
	+ in a basic audio / video call, make sure audio and video is actually being transmitted and recieved by both parties
	+ in a conference, have users join with both audio and video, while one or more joins with audio only, and make sure audio and video is being transmitted and recieved by the appropriate parties (confbridge examples!)

The above scenarios are more general. If we get into more specific scenarios (like ConfBridge), things still need to work. Certain APIs may be needed for this, such as abiltiy to pull down stream topology. Here's a list of scenarios that could be tested and make use of said API.

* confbridge
	+ add a large number of users with audio and video, leave conference running for an extended amount of time, then check to see if something went wrong
	+ add user with audio and video, check topology to make sure it's in the correct state, add another user with audio and video, check topology again
	+ add user with audio and video, check topology, remove user, check topology
	+ add user with audio and video, check topology, add another user with some different audio or video codecs, check topology, remove a user, check topology
	+ add user with only audio, check topology
	+ add user with only audio, check topology, add user with audio and video, check topology
	+ add user with audio and video, check topology, add user with only audio, check topology
	+ add user with only audio, check topology, add two more users with audio and video, check topology, remove user with only audio, check topology
	+ add user with only video, check topology
	+ add user with only video, check topology, add user with audio and video, check topology
	+ add user with audio and video, check topology, add user with only video, check topology
	+ add user with only video, check topolgoy, add two more users with audio and video, check topology, remove user with only video, check topology
	+ add user with only audio, check topology, add user with only video, check topology
	+ add user with only video, check topology, add user with only audio, check topology

These scenarios provide a thorough testing of stream topologies and some unique interactions with different setups. As for unit tests, here are some more that could be added to the current list.

* test\_stream.c  

	+ test that removing a stream results in that stream having a REMOVED state
	+ test that declining a stream results in that stream having a REMOVED state

There is a chance that some cases won't be caught in unit tests due to timing since the environment will be under ideal circumstances.

Future API changes should also come with a set of tests to ensure everything is working as it should. These changes could include the items below.

* bridge
	+ ability to fetch and manipulate stream topology (through AMI / ARI)
* endpoint
	+ ability to fetch and manipulate active / available streams on an endpoint (through AMI / ARI)

### Priorities

This list's purpose is to narrow down the above improvements and order them based on priority.

1. Set up a confbridge and add a user with audio and video. Make sure everything is in the appropriate state. Remove the user. Check the state again to ensure everything was cleaned up.
2. Set up a confbridge and add a user with audio and video. Add another user with audio and video (same codecs). Make sure everything is in the appropriate state. Remove the users. Check the state again to ensure everything was cleaned up.
3. Set up a confbridge and add a user with audio and video. Add another user with audio and video (different codecs). Make sure everything is in the appropriate state. Remove the users. Check the state again to ensure everything was cleaned up.
4. Set up a confbridge and add the standard maximum number of participants (16 streams default max, 8 users with audio and video). Make sure everything is in the correct state. Try to add one more, which should fail. Remove all users. Check the state again to ensure everything was cleaned up.
5. Set up a confbridge. Test with some audio only users.
	1. Add a user with audio only. Make sure everything is in the appropriate state. Add a user with audio and video. Check the state again. Remove the user with audio and video. Check the state again. Remove the last user. Check the state again to ensure everything was cleaned up.
	2. Add a user with audio and video. Make sure everything is in the appropriate state. Add a user with audio only. Check the state again. Remove the audio only user. Check the state again. Remove the last user. Check the state again to ensure everything was cleaned up.
6. Set up a confbridge with a packet sniffer (or something similar).  

	1. Add two users, both with audio and video. Make sure everything is in the correct state. Use the packet sniffer to ensure audio and video is being sent and received for both users. Remove the users. Check the state again to ensure everything was cleaned up.
	2. Add a user with audio and video. Add another user with audio only. Make sure everything is in the correct state. Use the packet sniffer to ensure that media is being sent and received for the appropriate users. Remove the users. Check the state again to ensure everything was cleaned up.
		1. Run through some basic scenarios to keep the gears turning.  
		
			1. Add two users with audio and video. Use the packet sniffer to make sure audio and video are being sent and received by both users.
			2. Add a user with audio and video. Add another user with audio only. Use the packet sniffer to make sure audio and video is being received by the audio only user, and the user with audio and video is only receiving audio.
		2. Run through these common scenarios that resulted in finicky behavior, e.g. this message popping up on Asterisk CLI when things go wrong: “res\_pjsip\_sdp\_rtp.c: set\_caps: No joint capabilities for ‘video’ media stream between our configuration ((vp8)) and incoming sdp ((ulaw))”.  
		
			1. Add a user with audio only. Add a user with audio and video. The user with audio only will be waiting for video. The packet sniffer should be used here to figure out if anything is actually being sent. Adding another user with audio and video results in all users receiving video. If the user that joined second leaves, the user with audio only loses video again.
			2. Add a user with audio and video. Add another user with audio and video. Add a third user with audio only. Then remove the first user that joined. The user with audio only will lose video.
			3. Add a user with audio and video. Add another user with audio only. Add a third user with audio and video. Remove the first user that joined. The user with audio only will lose video.
7. Set up a confbridge. Test with some video only users.  

	1. Add a user with video only. Make sure everything is in the appropriate state. Add a user with audio and video. Check the state again. Remove the user with audio and video. Check the state again. Remove the last user. Check the state again to ensure everything was cleaned up.
	2. Add a user with audio and video. Make sure everything is in the appropriate state. Add a user with video only. Check the state again. Remove the video only user. Check the state again. Remove the last user. Check the state again to ensure everything was cleaned up.
8. Accept an inbound offer with the maximum number of video streams. Try to add another video stream, which should result in a failure.
9. Accept an inbound offer with the maximum number of audio streams. Try to add another audio stream, which should result in a failure.

 

