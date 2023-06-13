---
title: Testing RTP
pageid: 32374998
---

Asterisk has many tests involving calls and channels, but there is little that tests RTP. As part of overhauling the RTP engine, a proper set of tests should be implemented as well.

Scoping the tests is a bit difficult, partially because the requirements for the RTP overhaul have not been nailed down yet. However, we can do some narrowing of scope up front since we know what is not going to be affected by the RTP work.

* Tests should not revolve around SDP parsing since SDP is not handled by the RTP engine
* Tests should not rely on specific channel driver behaviors to work.
* Since buffering, reordering, and synchronization of RTP streams has been ruled out as part of the design, this should not be tested.

Unit Tests
==========

RTP on the whole will be difficult to unit test, but there are individual components that may be easier to unit test. Here are some possibly unit-testable operations:

* Decoding incoming RTP packets (to include telephone-event)
* Encoding outgoing RTP packets (to include telephone-event)
* Generating RTCP reports from gathered statistics
* Decoding incoming RTCP packets
* Encoding outgoing RTCP packets
* Converting RTP packets to Asterisk frames

While state of RTP streams will affect how certain RTP and RTCP packets are generated, the functions that actually create the packets could be written to take the current stream state as function input, thereby making it easier to unit test.

Testsuite Tests
===============

The majority of RTP tests will be done in the Asterisk testsuite. This involves setting up an RTP session with some remote entity and sending and receiving RTP, testing the accuracy of RTP sent and received, and testing RTCP events for expected statistics.

RTP Testing Tools
-----------------

#### Within Asterisk

Asterisk currently has several channel drivers that are capable of setting up RTP sessions. However, all of these have the overhead of some signaling protocol that complicates the test and could potentially sabotage the test if they either have a bug themselves or silently correct a bug in the RTP implementation.

Asterisk has a channel driver for lightweight RTP setup called `chan_rtp`. RIght now, it is only capable of performing outbound calls using the formats given to it by `ast_request()`. It has no facility for setting up RTP features such as RTCP, RFC 4733, ICE, SRTP, etc. It also has no facility for accepting incoming calls. If facilities were added for `chan_rtp` to accept incoming calls and for `chan_rtp` to activate RTP features, then it would be an ideal choice for RTP testing in Asterisk.

#### External to Asterisk

When performing RTP tests, there will be several other entities required

* Something that can send RTP to Asterisk
* Something that can receive RTP from Asterisk
* For ICE tests:
	+ Something to provide NAT
	+ A STUN server
	+ A TURN server

I recently came across [RTPTools](http://www.cs.columbia.edu/irt/software/rtptools/), a possible contender for an entity to send and receive RTP to and from Asterisk. It has a SIPp-like tool called rtpsend that can take RTP packets in text form and send those to a remote address. It has a tool called rtpdump that can listen to RTP and write the result into a specialized file format. There is a third tool called rtpplay that can transmit RTP recorded by rtpdump. The possible downside with these tools is that the license is a bit vague about whether our use of it would be permissible. We will have to get in contact with the creators to determine if our use would be allowed.

If not, then writing a python-based tool that did essentially the same things as the tools described above would likely not be especially difficult, but it would require a time investment that using pre-made tools would not require. No matter what tools are used for transmitting RTP, we will need to find a library for encrypting RTP when sending SRTP.

For ICE tests, the current testsuite would not be a good fit for such tests since the testsuite does not currently make assumptions about external connectivity of the server on which the tests are being performed. For ICE tests, we would need external hardware that could be guaranteed to be present, which would be difficult to do for the testsuite. However, that does not mean that ICE testing should not be performed. A dedicated lab-like setup could be created somewhere that could run ICE tests. I have not yet looked into STUN and TURN servers to see what is available. In addition, we likely would require a more sophisticated channel driver than `chan_rtp` for ICE tests since we need to have a full offer-answer exchange to send local candidates and receive remote candidates.

RTP Transmission Tests
----------------------

RTP transmission tests involve having Asterisk transmit RTP and ensuring that the transmitted RTP is what we expect it to be. Some aspects to test:

* Ensure that RTP sequence numbers increase linearly and that timestamps increase in the expected increments
* Ensure that on typical RTP transmissions that the version, payload, and extension information is what it should be
* Ensure that the number of samples sent matches the expected packetization
* Ensure that RTP is sent to the proper address.
* Ensure that SRTP is sent encrypted and can be decrypted properly.
* Ensure that RTCP is sent at expected intervals.
* Ensure that when symmetric RTP is used, RTP is sent to the same address that RTP is received from.

RTP Reception Tests
-------------------

RTP reception tests involve having Asterisk receive RTP from some remote source.

* Ensure that inbound RTP is interpreted into appropriate Asterisk frame types
* Ensure that we do not accept inbound RTP from unknown locations when using strict RTP
* Ensure that reception of RTP results in the channel reading the data as expected.
* Ensure that received RTCP is somehow done something or other with.
* Ensure that received encrypted SRTP packets can be decrypted.

Native RTP Bridge Tests
-----------------------

Native RTP bridge tests involve having multiple endpoints that Asterisk communicates with over RTP. We will focus mainly on native local RTP bridging rather than native remote RTP bridging. We may need to use a more sophisticated channel driver than `chan_rtp` for this, depending on what RTP glue callbacks need to be defined by the channel driver.

* Ensure that media sent from one remote entity reaches the other remote entity, and vice-versa.
* Ensure that we send regular RTCP reports when performing native local RTP bridging
* Ensure that SRTP continues to function when using a native local RTP bridge.

ICE Tests
---------

ICE tests can be broken into several categories

* Ensure that we gather all expected local candidates in a given setup (host, server reflexive, peer reflexive, and relay).
* Ensure that we store all remote candidates that we receive.
* Ensure that we transmit RTP to an appropriate remote address based on connectivity checks.
