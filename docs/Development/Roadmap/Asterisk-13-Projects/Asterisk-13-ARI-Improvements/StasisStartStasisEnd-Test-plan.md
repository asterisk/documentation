---
title: StasisStart/StasisEnd Test plan
pageid: 30279826
---

StasisStart and StasisEnd events are the most crucial events to be sent since Stasis applications use these to determine if channels are in or not in their applications any longer. The problem is that the process for determining channel's existence in Stasis is not as straight-forward as seeing the channel enter and exit the Stasis() dialplan application. This page's intent is to detail a list of tests that will ensure that StasisStart and StasisEnd messages are received when we expect and are not received when not expected.




Transfers
=========

Attended: Non-Stasis Application to Stasis Bridge
-------------------------------------------------

Alice calls into the Echo application

Alice initiates an attended transfer

Alice dials a Stasis application

Stasis should emit a StasisStart event for Alice's channel

The Stasis application originates a call to Bob

Stasis should emit a StasisStart event for Bob's channel

When Bob answers, the Stasis application bridges Alice and Bob

Alice completes the Transfer

(Expected scenario: A Local channel is created. One half masquerades into the Echo application, and the other half is swapped in for Alice's channel in the bridge with Bob)   


Stasis should emit a StasisStart for the Local channel and a StasisEnd for Alice's channel. The StasisStart on the Local channel should indicate it is replacing Alice.  


Bob hangs up.

Stasis should emit a StasisEnd for Bob's channel.

The Stasis application hangs up the Local channel half that is in the bridge with Bob.

Stasis should emit a StasisEnd for the Local channel half.

Destroy the Stasis Bridge.

Attended: Non-Stasis Bridge to Stasis Bridge
--------------------------------------------

Alice dials the Dial() application to call Bob

Once they are bridged, Alice initiates an attended transfer

Alice dials a Stasis application

Stasis should emit a StasisStart event for Alice's channel

The Stasis application originates a call to Carol

Stasis should emit a StasisStart event for Carol's channel

When Carol answers, the Stasis application bridges Alice and Carol

Alice completes the transfer.

(Expected scenario: A Local channel is created to link the Stasis bridge and Non-Stasis bridges)

Stasis should emit a StasisStart for the Local channel and a StasisEnd for Alice's channel. The StasisStart on the Local channel should indicate it is replacing Alice.  


Bob hangs up.

(Expected scenario: Since Bob and the local channel are in a basic bridge, the local channel should be hung up)

Stasis should emit a StasisEnd for the local channel.

Carol hangs up.

Stasis should emit a StasisEnd for Carol's channel.

Destroy the Stasis bridge.

 

Attended: Non-Stasis Bridge to Stasis Application
-------------------------------------------------

Alice dials the Dial() application to call Bob

Once they are bridged, Alice initiates an attended transfer

Alice dials a Stasis application

Stasis should emit a StasisStart event for Alice's channel

Alice completes the transfer.

(Expected scenario: Bob's channel is masqueraded into the Stasis application in place of Alice's channel)

Stasis should emit a StasisStart for Bob's channel and a StasisEnd for Alice's channel. The StasisStart on Bob's channel should indicate it is replacing Alice.  


Bob hangs up.

Stasis should emit a StasisEnd for Bob's channel.  


Attended: Stasis Bridge to Non-Stasis Application
-------------------------------------------------

Alice dials a Stasis application.

Stasis should emit a StasisStart event for Alice's channel.

The Stasis application originates a call to Bob

Stasis should emit a StasisStart for Bob's channel.

When Bob answers, the Stasis application bridges Alice and Bob.

Alice initiates an attended transfer

Alice dials the Echo application

Alice completes the transfer

(Expected scenario: A Local channel is created. One half is masqueraded into the Echo application. The other half is swapped into the Stasis bridge for Alice's channel)

Stasis should emit a StasisStart for the local channel and a StasisEnd for Alice's channel. The StasisStart on the Local channel should indicate it is replacing Alice.  


Bob hangs up.

Stasis should emit a StasisEnd event for Bob's channel.

The Stasis application hangs up the local channel that was bridged to Bob.

Stasis should emit a StasisEnd event for the local channel.

Destroy the Stasis bridge.

Attended: Stasis Bridge to Non-Stasis Bridge
--------------------------------------------

Alice dials a Stasis application.

Stasis should emit a StasisStart event for Alice's channel.

The Stasis application originates a call to Bob

Stasis should emit a StasisStart for Bob's channel.

When Bob answers, the Stasis application bridges Alice and Bob.

Alice initiates an attended transfer.

Alice dials the Dial() application to call Carol.

When Alice and Carol are bridged, Alice completes the transfer.

(Expected scenario: A local channel is created to link the Stasis and non-Stasis bridges)

Stasis should emit StasisStart for the Local channel and a StasisEnd for Alice's channel. The StasisStart on the Local channel should indicate it is replacing Alice.  


Bob hangs up.

Stasis should emit a StasisEnd for Bob's channel.

Carol hangs up.

(Expected scenario: Since Carol and the local channel are in a basic bridge, the local channel should be hung up)

Stasis should emit a StasisEnd for the Local channel.

Destroy the Stasis bridge.  


Attended: Stasis Bridge to Stasis Bridge in same Stasis application
-------------------------------------------------------------------

Alice1 dials a Stasis application.

Stasis should emit a StasisStart event for Alice1's channel.

The Stasis application adds Alice1 to a bridge.

The Stasis application originates a call to Bob

Stasis should emit a StasisStart for Bob's channel.

The Stasis application adds Bob to the same bridge as Alice1.

Alice1 initiates an attended transfer.

Alice2 dials the same Stasis application.

Stasis should emit a StasisStart event for Alice2's channel.

The Stasis application adds Alice2 to a bridge (different from the bridge Alice1 and Bob are in).

The Stasis application originates a call to Carol

Stasis should emit a StasisStart for Carol's channel.

The Stasis application adds Carol to the same bridge as Alice2.

Alice2 completes the transfer.

(Expected scenario: A local channel is created to link the two bridges)

 Stasis should emit a StasisStart for each half of the local channel, and StasisEnd events for Alice1 and Alice2. The StasisStart on the Local channels should indicate they are replacing the Alice channels.  


Bob hangs up

Stasis should emit a StasisEnd for Bob's channel.

Carol hangs up

Stasis should emit a StasisEnd for Carol's channel

The Stasis app hangs up the local channel that was previously bridged to Bob

Stasis should emit a StasisEnd for both local channels.

Attended: Stasis Bridge to Stasis Bridge in Different Stasis application
------------------------------------------------------------------------

Alice1 dials Stasis application A.

Stasis should emit a StasisStart event for Alice1's channel, application A.

The Stasis application adds Alice1 to a bridge.

Stasis Application A originates a call to Bob

Stasis should emit a StasisStart for Bob's channel, application A.

The Stasis application adds Bob to the same bridge as Alice1.

Alice1 initiates an attended transfer.

Alice2 dials  Stasis application B.

Stasis should emit a StasisStart event for Alice2's channel, application B.

The Stasis application adds Alice2 to a bridge (different from the bridge Alice1 and Bob are in).

The Stasis application originates a call to Carol

Stasis should emit a StasisStart for Carol's channel, application B.

The Stasis application adds Carol to the same bridge as Alice2.

Alice2 completes the transfer.

(Expected scenario: A local channel is created to link the two bridges)

Stasis should emit a StasisStart for each half of the local channel, one in application A and one in application B. The StasisStart on the Local channels should indicate they are replacing Alice1 and Alice2.  


Stasis should emit a StasisEnd event for Alice 1, application A, and Alice2, application B.

Bob hangs up

Stasis should emit a StasisEnd for Bob's channel, applicaiton A.

Carol hangs up

Stasis should emit a StasisEnd for Carol's channel, application B.  


The Stasis app hangs up the local channel that was previously bridged to Bob

Stasis should emit a StasisEnd for both local channels, one in application A and one in application B.

Blind: Stasis Bridge to Non-Stasis application
----------------------------------------------

Alice dials a Stasis application.

Stasis should emit a StasisStart event for Alice's channel.

The Stasis application originates a call to Bob

Stasis should emit a StasisStart for Bob's channel.

When Bob answers, the Stasis application bridges Alice and Bob.

Alice initiates a blind transfer.

Alice dials an extension that calls the Echo() application

(Expected scenario: A local channel will be created. One half of the local channel will be masqueraded into the Echo application. The other half will be swapped in for Alice's channel in the Stasis bridge.)

Stasis should emit a StasisStart for the local channel and a StasisEnd event for Alice. The StasisStart on the Local channel should indicate it is replacing Alice.  


Bob hangs up.

Stasis should emit a StasisEnd for Bob's channel.

The Stasis application hangs up the local channel that was bridged to Bob.

Stasis should emit a StasisEnd for the local channel.

Destroy the Stasis bridge.

Blind: Stasis Bridge to same Stasis application
-----------------------------------------------

Alice dials a Stasis application.

Stasis should emit a StasisStart event for Alice's channel.

The Stasis application originates a call to Bob

Stasis should emit a StasisStart for Bob's channel.

When Bob answers, the Stasis application bridges Alice and Bob.

Alice initiates a blind transfer.

Alice dials an extension that calls the same Stasis application

(Expected scenario: A local channel will be created. One half of the local channel will be masqueraded into the Stasis application. The other half will be swapped in for Alice's channel in the Stasis bridge.)

Stasis should emit a StasisStart for each of the local channel halves and a StasisEnd event for Alice. The StasisStart on one of the Local channel halves should indicate it is replacing Alice.  


Bob hangs up.

Stasis should emit a StasisEnd for Bob's channel.

The Stasis application hangs up the local channel that was bridged to Bob.

Stasis should emit StasisEnd events for both local channel halves.

Destroy the Stasis bridge.

Blind: Stasis Bridge to different Stasis application
----------------------------------------------------

Alice dials Stasis application A.

Stasis should emit a StasisStart event for Alice's channel, application A.

The Stasis application originates a call to Bob

Stasis should emit a StasisStart for Bob's channel, application A.

When Bob answers, the Stasis application bridges Alice and Bob.

Alice initiates a blind transfer.

Alice dials an extension that calls Stasis application B.

(Expected scenario: A local channel will be created. One half of the local channel will be masqueraded into the Stasis application. The other half will be swapped in for Alice's channel in the Stasis bridge.)

Stasis should emit a StasisStart for each of the local channel halves, one for application A and one for application B, and a StasisEnd event for Alice in application A. The StasisStart for the Local channel in application A should indicate it is replacing Alice.  


Bob hangs up.

Stasis should emit a StasisEnd for Bob, application A.

The Stasis application hangs up the local channel that was bridged to Bob.

Stasis should emit StasisEnd events for both local channel halves, one for application A and one for application B.

Destroy the Stasis bridge.

External Bridging
=================

One channel in Stasis Bridge, One channel in non-Stasis application
-------------------------------------------------------------------

Alice dials a Stasis application.

Stasis should emit a StasisStart event for Alice's channel.

The Stasis application adds Alice to a bridge.

### AMI Bridge Action

Bob dials the Echo application.

The AMI Bridge action is used to bridge Alice and Bob.

Stasis should emit a StasisEnd for Alice.

Bob hangs up.

Alice should not re-enter Stasis.

Destroy the Stasis bridge.  


### Bridge() Dialplan Application

Bob dials the Bridge dialplan application to be bridged to Alice.

Stasis should emit a StasisEnd for Alice.

Bob hangs up.

Alice should not re-enter Stasis.

Destroy the Stasis bridge.

### Bridge() Dialplan Application (x option)

Bob dials the Bridge dialplan application to be bridged to Alice.

Stasis should emit a StasisEnd for Alice.

Bob hangs up.

Alice should be hung up.

Destroy the Stasis bridge.

One channel in Stasis Bridge, One channel in non-Stasis Bridge
--------------------------------------------------------------

Alice dials a Stasis application.

Stasis should emit a StasisStart event for Alice's channel.

The Stasis application adds Alice to a bridge.

Bob dials an extension that calls the Dial() application to call Carol.

Once Bob and Carol are bridged, the AMI Bridge action is used to bridge Alice and Bob.

Stasis should emit a StasisEnd for Alice's channel

Bob hangs up.

Alice should not re-enter Stasis.

Destroy the Stasis bridge.

One channel in Stasis Bridge, One channel in Same Stasis application
--------------------------------------------------------------------

Alice dials a Stasis application

Stasis should emit a StasisStart event for Alice's channel.

The Stasis application adds Alice to a bridge.

Bob dials the same Stasis application.

Stasis should emit a StasisStart for Bob's channel.

The AMI bridge action is used to bridge Alice and Bob.

Stasis should emit a StasisEnd for Alice and Bob.

Bob hangs up.

Alice should not re-enter Stasis.

Destroy the Stasis bridge.

One channel in Stasis Bridge, One channel in Different Stasis application
-------------------------------------------------------------------------

Alice dials Stasis application A

Stasis should emit a StasisStart event for Alice's channel, application A.

The Stasis application adds Alice to a bridge.

Bob dials Stasis application B.

Stasis should emit a StasisStart for Bob's channel, application B.

The AMI bridge action is used to bridge Alice and Bob.

Stasis should emit a StasisEnd for Alice, application A

Stasis should emit a StasisEnd for Bob, application B

Bob hangs up.

Alice should not re-enter Stasis.

Destroy the Stasis bridge.

Both channels in Stasis Bridge, Same Stasis Application
-------------------------------------------------------

Alice dials a Stasis application

Stasis should emit a StasisStart event for Alice's channel.

The Stasis application adds Alice to a bridge.

Bob dials the same Stasis application.

Stasis should emit a StasisStart for Bob's channel.

The Stasis application adds Bob to the same bridge as Alice.

The AMI bridge action is used to bridge Alice and Bob.

Stasis should emit a StasisEnd for Alice and Bob.

Bob hangs up.

Alice should not re-enter Stasis.

Destroy the Stasis bridge.

Both channels in Stasis Bridge, Different Stasis Application
------------------------------------------------------------

Alice dials Stasis application A

Stasis should emit a StasisStart event for Alice's channel, application A.

Stasis application A adds Alice to a bridge.

Bob dials Stasis application B.

Stasis should emit a StasisStart for Bob's channel, application B.

Stasis application B adds Bob to a bridge.

The AMI bridge action is used to bridge Alice and Bob.

Stasis should emit a StasisEnd for Alice, application A

Stasis should emit a StasisEnd for Bob, application B

Bob hangs up.

Alice should not re-enter Stasis.

Destroy the Stasis bridge in application A.

Destroy the Stasis bridge in application B.  


Both channels in Same Stasis application
----------------------------------------

Alice dials a Stasis application

Stasis should emit a StasisStart event for Alice's channel.

Bob dials the same Stasis application.

Stasis should emit a StasisStart for Bob's channel.

The AMI bridge action is used to bridge Alice and Bob.

Stasis should emit a StasisEnd for Alice and Bob.

Bob hangs up.

Alice should not re-enter Stasis.

Both channels in Different Stasis applications
----------------------------------------------

Alice dials Stasis application A

Stasis should emit a StasisStart event for Alice's channel, application A.

Bob dials Stasis application B.

Stasis should emit a StasisStart for Bob's channel, application B.

The AMI bridge action is used to bridge Alice and Bob.

Stasis should emit a StasisEnd for Alice, application A

Stasis should emit a StasisEnd for Bob, application B

Bob hangs up.

Alice should not re-enter Stasis.

One channel in Stasis application, One channel in non-Stasis Bridge
-------------------------------------------------------------------

Alice dials a Stasis application.

Stasis should emit a StasisStart event for Alice's channel.

Bob dials an extension that results in a Dial to Carol.

Carol answers the call from Bob.

When Carol and Bob are bridged, the AMI bridge action is used to bridge Alice and Bob.

Stasis should emit a StasisEnd for Alice.

Bob hangs up.

Alice should not re-enter Stasis.

One channel in Stasis application, One channel in non-Stasis application
------------------------------------------------------------------------

Alice dials a Stasis application.

Stasis should emit a StasisStart event for Alice's application.

### AMI Bridge Action

Bob dials the Echo application.

The AMI Bridge action is used to bridge Alice and Bob.

Stasis should emit a StasisEnd for Alice.

Bob hangs up.

Alice should not re-enter Stasis.

### Bridge() Dialplan Application

Bob dials the Bridge dialplan application to be bridged to Alice.

Stasis should emit a StasisEnd for Alice.

Bob hangs up.

Alice should not re-enter Stasis.

### Bridge() Dialplan Application (x option)

Bob dials the Bridge dialplan application to be bridged to Alice.

Stasis should emit a StasisEnd for Alice.

Bob hangs up.

Alice should be hung up.

AMI Redirect
============

Channel in a Stasis application
-------------------------------

Alice dials a Stasis application.

Stasis should emit a StasisStart for Alice.

An AMI redirect is issued to move Alice to an extension that calls Echo()

Stasis should emit a StasisEnd for Alice.

Alice hangs up.

Channel in a Stasis bridge
--------------------------

Alice dials a Stasis application.

Stasis should emit a StasisStart for Alice.

The Stasis application adds Alice to a bridge.

An AMI redirect is issued to move Alice to an extension that calls Echo()

Stasis should emit a StasisEnd for Alice.

Alice hangs up.

Destroy the Stasis bridge.

Current Status
==============



| Test | Issue | TestSuite Test |
| --- | --- | --- |
| 1.1 Attended: Non-Stasis Application to Stasis Bridge |  | tests/rest\_api/external\_interaction/attended\_transfer/non\_stasis\_app\_to\_stasis\_bridge |
| 1.2 Attended: Non-Stasis Bridge to Stasis Bridge |  | tests/rest\_api/external\_interaction/attended\_transfer/non\_stasis\_bridge\_to\_stasis\_bridge |
| 1.3 Attended: Non-Stasis Bridge to Stasis Application |  | tests/rest\_api/external\_interaction/attended\_transfer/stasis\_bridge\_to\_stasis\_app |
| 1.4 Attended: Stasis Bridge to Non-Stasis Application |  | tests/rest\_api/external\_interaction/attended\_transfer/stasis\_bridge\_to\_non\_stasis\_app |
| 1.5 Attended: Stasis Bridge to Non-Stasis Bridge |  |  |
| 1.6 Attended: Stasis Bridge to Stasis Bridge in same Stasis application |  | tests/rest\_api/external\_interaction/attended\_transfer/stasis\_bridge\_to\_stasis\_bridge/same\_stasis\_app |
| 1.7 Attended: Stasis Bridge to Stasis Bridge in Different Stasis application |  | tests/rest\_api/external\_interaction/attended\_transfer/stasis\_bridge\_to\_stasis\_bridge/different\_stasis\_app |
| 1.8 Blind: Stasis Bridge to Non-Stasis application |  | tests/rest\_api/bridges/blind\_transfer/stasis\_bridge\_to\_non\_stasis\_app |
| 1.9 Blind: Stasis Bridge to same Stasis application |  | tests/rest\_api/external\_interaction/blind\_transfer/stasis\_bridge\_to\_same\_stasis\_app |
| 1.10 Blind: Stasis Bridge to different Stasis application |  | tests/rest\_api/external\_interaction/blind\_transfer/stasis\_bridge\_to\_different\_stasis\_app |
| 2.1 One channel in Stasis Bridge, One channel in non-Stasis application – 2.1.1 AMI Bridge Action |  | tests/rest\_api/external\_interaction/ami\_bridge/stasis\_bridge/non\_stasis\_app |
| 2.1 One channel in Stasis Bridge, One channel in non-Stasis application – 2.1.2 Bridge() Dialplan Application |  | tests/rest\_api/external\_interaction/bridge\_app/stasis\_bridge |
| 2.1 One channel in Stasis Bridge, One channel in non-Stasis application – 2.1.3 Bridge() Dialplan Application (x option) |  | tests/rest\_api/external\_interaction/bridge\_app/x\_option/stasis\_bridge |
| 2.2 One channel in Stasis Bridge, One channel in non-Stasis Bridge |  | tests/rest\_api/external\_interaction/ami\_bridge/stasis\_bridge/non\_stasis\_bridge |
| 2.3 One channel in Stasis Bridge, One channel in Same Stasis application |  | tests/rest\_api/external\_interaction/ami\_bridge/stasis\_bridge/same\_stasis\_app |
| 2.4 One channel in Stasis Bridge, One channel in Different Stasis application |  | tests/rest\_api/external\_interaction/ami\_bridge/stasis\_bridge/different\_stasis\_app |
| 2.5 Both channels in Stasis Bridge, Same Stasis Application |  | tests/rest\_api/external\_interaction/ami\_bridge/stasis\_bridge/two\_channel\_same\_stasis\_app |
| 2.6 Both channels in Stasis Bridge, Different Stasis Application |  | tests/rest\_api/external\_interaction/ami\_bridge/stasis\_bridge/two\_channel\_different\_stasis\_app |
| 2.7 Both channels in Same Stasis application |  | tests/rest\_api/external\_interaction/ami\_bridge/stasis\_app/two\_channel\_same\_stasis\_app |
| 2.8 Both channels in Different Stasis applications |  | tests/rest\_api/external\_interaction/ami\_bridge/stasis\_app/two\_channel\_different\_stasis\_app |
| 2.9 One channel in Stasis application, One channel in non-Stasis Bridge |  |  |
| 2.10 One channel in Stasis application, One channel in non-Stasis application – 2.10.1 AMI Bridge Action |  | tests/rest\_api/external\_interaction/ami\_bridge/stasis\_app/non\_stasis\_app |
| 2.10 One channel in Stasis application, One channel in non-Stasis application – 2.10.2 Bridge() Dialplan Application |  |  |
| 2.10 One channel in Stasis application, One channel in non-Stasis application – 2.10.3 Bridge() Dialplan Application (x option) |  |  |
| 3 AMI Redirect – 3.1 Channel in a Stasis application |  | tests/rest\_api/external\_interaction/ami\_redirect/stasis\_app |
| 3 AMI Redirect – 3.2 Channel in a Stasis bridge |  | tests/rest\_api/external\_interaction/ami\_redirect/stasis\_bridge |

