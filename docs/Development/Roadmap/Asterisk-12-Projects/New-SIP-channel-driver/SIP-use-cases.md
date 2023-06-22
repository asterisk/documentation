---
title: SIP use cases
pageid: 21464262
---

 

The following are use cases for a new SIP channel driver. These are written at a very high level, so details such as what transport is used, what codecs are used, how endpoints are configured, whether NAT is involved do not factor in. These details will be important when translating the use cases into test scenarios, however.

Media sessions
==============

Basic media sessions
--------------------

### One-way incoming call

* Alice picks up her SIP phone and dials an extension.
* Alice hears a prompt telling her that her phone system has been consumed by weasels.
* Alice hangs up, confused.

### One-way outgoing call

* An administrator presses a button on a website to call Bob.
* Bob's phone rings.
* Bob answers his phone.
* Bob hears a pre-recorded plea from a politician to cast a vote for him in the upcoming election.
* Bob hangs up, angry.

### Two-way call

* Alice picks up her SIP phone and dials Bob's extension.
* Bob's phone begins ringing; Alice hears ringing in her handset's speaker.
* Bob's phone's display indicates an incoming call from Alice.
* Alice's phone's display indicates the call is directed to Bob.
* Bob answers his phone.
* Audio flows bidirectionally between Bob and Alice.
* Alice hangs up.

### Originated two-way call

* A script places an outgoing call to Bob.
* Bob's phone rings.
* Bob's phone's display indicates an incoming call from some caller ID.
* Bob answers his phone.
* The script now places an outgoing call to Carol.
* Carol answers the call.
* Carol's phone's display indicates he is connected with Bob.
* Bob's phone's display indicates he is connected with Carol.
* Audio flows bidirectionally between Bob and Carol.
* Bob hangs up.

### Canceled call

* Alice picks up her SIP phone and dials Bob's extension.
* Bob's phone begins ringing; Alice hears ringing in her handset's speaker.
* Bob's phone's display indicates an incoming call from Alice.
* Alice's phone's display indicates the call is going to Bob.
* Alice hangs up while Bob's phone is still ringing.
* Bob's phone stops ringing.

### Video call

* Alice tells her laptop's SIP soft phone to place a call to Bob.
* Bob's laptop's SIP soft phone makes a horrible racket indicating there's an incoming call.
* Bob's laptop's SIP soft phone indicates the an incoming call from Alice.
* Bob answers his phone.
* Audio and Video flow bidirectionally between Alice and Bob.
* Alice hangs up.

### IVR navigation

* Alice picks up her SIP phone and dials an extension.
* An IVR greets her, telling her to press 1 to redirect the call to Bob or 2 to hang up the call.
* Alice presses 2.
* The call is ended.

### Conference call

* Alice picks up her SIP phone and dials an extension to join a conference call.
* Alice's phone's display indicates she is connected to the conference bridge.
* Bob picks up his SIP phone and dials an extension to join a conference call.
* Bob's phone's display indicates he is connected to the conference bridge.
* Carol picks up her SIP phone and dials an extension to join a conference call.
* Carol's phone's display indicates she is connected to the conference bridge.
* Audio flows between all three endpoints.
* Alice hangs up.
* Audio flows bidirectionally between Bob and Carol.
* Bob hangs up.
* Carol hangs up.

Transfers/redirections
----------------------

### Call forward

* Alice picks up her SIP phone and dials Bob's extension.
* Bob's phone indicates that the call should be forwarded to Carol's extension.
* Carol's phone begins ringing; Alice hears ringing in her handset's speaker.
* Alice's SIP phone should display Carol as the target of the call.
* Carol answers her phone.
* Audio flows bidirectionally between Alice and Bob.
* Alice hangs up.




!!! note 
    Transfer use cases below are centered around Bob transferring Alice to Carol. Use cases also should include Alice transferring Bob to Carol, but for the sake of brevity, these are omitted.

      
[//]: # (end-note)



### Local attended transfer: success

* Alice picks up her SIP phone and dials Bob's extension.
* Bob's phone begins ringing; Alice hears ringing in her handset's speaker.
* Bob's phone's display indicates an incoming call from Alice.
* Alice's phone's display indicates the call is directed to Bob.
* Bob answers his phone.
* Audio flows bidirectionally between Alice and Bob.
* Bob presses the attended transfer key on his SIP phone.
* Bob hears dialtone.
* Alice hears music on hold.
* Bob dials Carol's extension.
* Carol's phone begins ringing; Bob hears ringing in his handset's speaker.
* Carol's phone's display indicates an incoming call from Bob.
* Bob's phone's display indicates the call is directed to Carol.
* Carol answers her phone.
* Audio flows bidirectionally between Bob and Carol.
* Bob hangs up.
* Carol's phone's display shows that she is connected with Alice.
* Alice's phone's display shows that she is connected with Carol.
* Alice stops hearing music on hold.
* Audio flows bidirectionally between Alice and Carol.
* Alice hangs up.

### Local attended transfer: busy transfer target

* Alice picks up her SIP phone and dials Bob's extension.
* Bob's phone begins ringing; Alice hears ringing in her handset's speaker.
* Bob's phone's display indicates an incoming call from Alice.
* Alice's phone's display indicates the call is directed to Bob.
* Bob answers his phone.
* Audio flows bidirectionally between Alice and Bob.
* Bob presses the attended transfer key on his SIP phone.
* Bob hears dialtone.
* Alice hears music on hold.
* Bob dials Carol's extension; Carol is currently on another call.
* Bob hears a busy signal.
* Bob presses a button to reconnect him with Alice (maybe attended transfer button. May be line key).
* Alice stops hearing music on hold.
* Audio flows bidirectionally between Alice and Bob.
* Alice hangs up.

### Local attended transfer: transfer target does not answer

* Alice picks up her SIP phone and dials Bob's extension.
* Bob's phone begins ringing; Alice hears ringing in her handset's speaker.
* Bob's phone's display indicates an incoming call from Alice.
* Alice's phone's display indicates the call is directed to Bob.
* Bob answers his phone.
* Audio flows bidirectionally between Alice and Bob.
* Bob presses the attended transfer key on his SIP phone.
* Bob hears dialtone.
* Alice hears music on hold.
* Bob dials Carol's extension.
* Carol's phone begins ringing; Bob hears ringing in his handset's speaker.
* Carol's phone's display indicates an incoming call from Bob.
* Bob's phone's display indicates the call is directed to Carol.
* Carol does not answer her phone for several seconds.
* The call times out, resulting in Bob hearing a fast busy.
* Bob presses a button to reconnect with Alice.
* Bob's phone's display indicates the call is connected to Alice.
* Alice stops hearing music on hold.
* Audio flows bidirectionally between Bob and Alice.
* Alice hangs up.

### Local attended transfer: nonexistent transfer target

* Alice picks up her SIP phone and dials Bob's extension.
* Bob's phone begins ringing; Alice hears ringing in her handset's speaker.
* Bob's phone's display indicates an incoming call from Alice.
* Alice's phone's display indicates the call is directed to Bob.
* Bob answers his phone.
* Audio flows bidirectionally between Alice and Bob.
* Bob presses the attended transfer key on his SIP phone.
* Bob hears dialtone.
* Alice hears music on hold.
* Bob misdials Carol's extension.
* Bob hears a busy signal.
* Bob presses a button to reconnect him with Alice.
* Alice stops hearing music on hold.
* Audio flows bidirectionally between Alice and Bob.
* Alice hangs up.

### Local attended transfer: transferee hangup

* Alice picks up her SIP phone and dials Bob's extension.
* Bob's phone begins ringing; Alice hears ringing in her handset's speaker.
* Bob's phone's display indicates an incoming call from Alice.
* Alice's phone's display indicates the call is directed to Bob.
* Bob answers his phone.
* Audio flows bidirectionally between Alice and Carol.
* Bob presses the attended transfer key on his SIP phone.
* Bob hears dialtone.
* Alice hears music on hold.
* Bob dials Carol's extension.
* Carol's phone begins ringing; Bob hears ringing in his handset's speaker.
* Carol's phone's display indicates an incoming call from Bob.
* Bob's phone's display indicates the call is directed to Carol.
* Carol answers her phone.
* Audio flows bidirectionally between Bob and Carol.
* Alice hangs up.
* Bob hangs up.
* All calls are disconnected.

### Local blind transfer: success

* Alice picks up her SIP phone and dials Bob's extension.
* Bob's phone begins ringing; Alice hears ringing in her handset's speaker.
* Bob's phone's display indicates an incoming call from Alice.
* Alice's phone's display indicates the call is directed to Bob.
* Bob answers his phone.
* Audio flows bidirectionally between Alice and Bob.
* Bob presses the blind transfer key on his SIP phone.
* Bob hears dialtone.
* Alice hears music on hold.
* Bob dials Carol's extension.
* Bob's phone is disconnected from the call.
* Carol's phone begins ringing; Alice hears ringing in her handset's speaker.
* Carol's phone's display indicates an incoming call from Alice.
* Alice's phone's display indicates the call is directed to Carol.
* Carol answers her phone.
* Audio flows bidirectionally between Alice and Carol.
* Alice hangs up.

### Local blind transfer: Busy transfer target




!!! note 
    The behavior described here is highly dependent on the phone used by Bob. Some phones may react to a failed blind transfer by attempting to revive the initial call, while others may unconditionally end their call on a blind transfer no matter the outcome.

    Also note that the scenario described below will not work in current Asterisk because chan\_sip "fakes" the sip-frag NOTIFY to Bob saying the call to Carol succeeded before Asterisk actually knows the outcome of the call. Alice and Bob will not be reconnected when Carol is found to be busy.

      
[//]: # (end-note)



* Alice picks up her SIP phone and dials Bob's extension.
* Bob's phone begins ringing; Alice hears ringing in her handset's speaker.
* Bob's phone's display indicates an incoming call from Alice.
* Alice's phone's display indicates the call is directed to Bob.
* Bob answers his phone.
* Audio flows bidirectionally between Alice and Bob.
* Bob presses the blind transfer key on his SIP phone.
* Bob hears dialtone.
* Alice hears music on hold.
* Bob dials Carol's extension; Carol is currently on another call.
* Bob's phone is disconnected from the call.
* Bob's phone begins to ring.
* Bob picks up the ringing phone.
* Alice stops hearing music on hold.
* Audio flows bidirectionally between Alice and Bob.
* Alice hangs up.

### Local blind transfer: Nonexistent transfer target




!!! note 
    The behavior described here is highly dependent on the phone used by Bob. Some phones may react to a failed blind transfer by attempting to revive the initial call, while others may unconditionally end their call on a blind transfer no matter the outcome.

    Note that unlike the previous scenario, this one actually should work in Asterisk's current chan\_sip.

      
[//]: # (end-note)



* Alice picks up her SIP phone and dials Bob's extension.
* Bob's phone begins ringing; Alice hears ringing in her handset's speaker.
* Bob's phone's display indicates an incoming call from Alice.
* Alice's phone's display indicates the call is directed to Bob.
* Bob answers his phone.
* Audio flows bidirectionally between Alice and Bob.
* Bob presses the blind transfer key on his SIP phone.
* Bob hears dialtone.
* Alice hears music on hold.
* Bob misdials Carol's extension.
* Bob's phone is disconnected from the call.
* Bob's phone begins to ring.
* Bob picks up the ringing phone.
* Alice stops hearing music on hold.
* Audio flows bidirectionally between Alice and Bob.
* Alice hangs up.

### Local blind transfer: Transfer target does not answer




!!! note 
    The behavior described here is dependent on the dialplan in use for calling Carol. If Carol's extension goes to Voicemail or is in some other way "answered", then the call will be deemed as successful even though a human did not respond to the call. If the dialplan signals congestion or some other such signal after the call times out, then the call will be deemed a failure. For this scenario, we assume the latter scenario: if Carol does not answer within a specified time frame, a congestion indication is sent.

    The behavior described here is highly dependent on the phone used by Bob. Some phones may react to a failed blind transfer by attempting to revive the initial call, while others may unconditionally end their call on a blind transfer no matter the outcome.

    Also note that the scenario described below will not work in current Asterisk because chan\_sip "fakes" the sip-frag NOTIFY to Bob saying the call to Carol succeeded before Asterisk actually knows the outcome of the call. Alice and Bob will not be reconnected when Carol does not answer.

      
[//]: # (end-note)



* Alice picks up her SIP phone and dials Bob's extension.
* Bob's phone begins ringing; Alice hears ringing in her handset's speaker.
* Bob's phone's display indicates an incoming call from Alice.
* Alice's phone's display indicates the call is directed to Bob.
* Bob answers his phone.
* Audio flows bidirectionally between Alice and Bob.
* Bob presses the blind transfer key on his SIP phone.
* Bob hears dialtone.
* Alice hears music on hold.
* Bob dials Carol's extension.
* Bob's phone is disconnected from the call.
* Carol's phone begins to ring; Alice hears ringing in her handset's speaker.
* Carol's phone's display indicates an incoming call from Alice.
* Alice's phone's display indicates the call is directed to Carol.
* Carol does not answer the call.
* Bob's phone begins to ring.
* Bob's phone indicates it is being reconnected to Alice.
* Alice's phone indicates it is being reconnected to Bob.
* Bob picks up the ringing phone.
* Audio flows bidirectionally between Alice and Bob.
* Alice hangs up.

### Local blind transfer: transferee hangup

* Alice picks up her SIP phone and dials Bob's extension.
* Bob's phone begins ringing; Alice hears ringing in her handset's speaker.
* Bob's phone's display indicates an incoming call from Alice.
* Alice's phone's display indicates the call is directed to Bob.
* Bob answers his phone.
* Audio flows bidirectionally between Alice and Carol.
* Bob presses the blind transfer key on his SIP phone.
* Bob hears dialtone.
* Alice hears music on hold.
* Bob dials Carol's extension.
* Bob's phone is disconnected from the call.
* Carol's phone begins ringing; Alice hears ringing in her handset's speaker.
* Carol's phone's display indicates an incoming call from Alice.
* Alice's phone's display indicates the call is directed to Carol.
* Alice hangs up.
* Carol's phone stops ringing.




!!! note 
    The following tests refer to a concept called a "blond" transfer. This is the process by which a transferer uses the attended transfer key on his phone to perform a blind transfer. In other words, the transferer presses the attended transfer key, dials the appropriate extension, and then immediately hangs up when the destination begins ringing. Since the process involves hanging up once the far end begins ringing, it means that there are no scenarios to check such as "transfer target busy" or "transfer target nonexistent".

      
[//]: # (end-note)



### Local blond transfer: success

* Alice picks up her SIP phone and dials Bob's extension.
* Bob's phone begins ringing; Alice hears ringing in her handset's speaker.
* Bob's phone's display indicates an incoming call from Alice.
* Alice's phone's display indicates the call is directed to Bob.
* Bob answers his phone.
* Audio flows bidirectionally between Alice and Bob.
* Bob presses the attended transfer key on his SIP phone.
* Bob hears dialtone.
* Alice hears music on hold.
* Bob dials Carol's extension.
* Carol's phone begins ringing; Bob hears ringing in his handset's speaker.
* Carol's phone's display indicates an incoming call from Bob.
* Bob's phone's display indicates the call is directed to Carol.
* Bob hangs up his phone.
* Alice hears ringing in her handset's speaker.
* Carol's phone's display indicates an incoming call from Alice.
* Alice's phone's display indicates the call is directed to Carol.
* Carol answers her phone.
* Audio flows bidirectionally between Alice and Carol.
* Alice hangs up.

### Local blond transfer: transfer target does not answer

* Alice picks up her SIP phone and dials Bob's extension.
* Bob's phone begins ringing; Alice hears ringing in her handset's speaker.
* Bob's phone's display indicates an incoming call from Alice.
* Alice's phone's display indicates the call is directed to Bob.
* Bob answers his phone.
* Audio flows bidirectionally between Alice and Bob.
* Bob presses the attended transfer key on his SIP phone.
* Bob hears dialtone.
* Alice hears music on hold.
* Bob dials Carol's extension.
* Carol's phone begins ringing; Bob hears ringing in his handset's speaker.
* Carol's phone's display indicates an incoming call from Bob.
* Bob's phone's display indicates the call is directed to Carol.
* Bob hangs up his phone.
* Alice hears ringing in her handset's speaker.
* Carol's phone's display indicates an incoming call from Alice.
* Alice's phone's display indicates the call is directed to Carol.
* Carol does not answer the call.
* Alice hears a fast busy tone.
* Alice hangs up.

### Local blond transfer: transferee hangup

* Alice picks up her SIP phone and dials Bob's extension.
* Bob's phone begins ringing; Alice hears ringing in her handset's speaker.
* Bob's phone's display indicates an incoming call from Alice.
* Alice's phone's display indicates the call is directed to Bob.
* Bob answers his phone.
* Audio flows bidirectionally between Alice and Bob.
* Bob presses the attended transfer key on his SIP phone.
* Bob hears dialtone.
* Alice hears music on hold.
* Bob dials Carol's extension.
* Carol's phone begins ringing; Bob hears ringing in his handset's speaker.
* Carol's phone's display indicates an incoming call from Bob.
* Bob's phone's display indicates the call is directed to Carol.
* Bob hangs up his phone.
* Alice hears ringing in her handset's speaker.
* Carol's phone's display indicates an incoming call from Alice.
* Alice's phone's display indicates the call is directed to Carol.
* Alice hangs up.
* Carol's phone stops ringing.

### Remote attended transfer: success




!!! note 
    In this scenarios, Alice and Bob are users of a remote system, and Carol is a user of the local Asterisk system. We only care about the experience for Carol in this situation, so details are glossed over regarding Bob and Alice's experience.

      
[//]: # (end-note)



* Alice and Bob are connected on a call on a remote system
* Bob presses the attended transfer key on his SIP phone.
* Bob dials Carol's extension.
* Carol's phone begins ringing.
* Carol's display indicates an incoming call from Bob.
* Carol answers the call.
* Audio flows bidirectionally between Bob and Carol.
* Bob hangs up.
* Carol's display indicates she is connected to Alice.
* Audio flows bidirectionally between Alice and Carol.
* Alice hangs up.

FAX
---

### Pass-through

* Alice sends a FAX to Bob on her T.38-capable FAX machine.
* The server relays this FAX to Bob.
* Bob receives the FAX on his T.38-capable FAX machine.

### Origination

* Alice presses a button on her computer to remotely send a FAX to Bob.
* The server sends this FAX to Bob.
* Bob receives the FAX on his T.38-capable FAX machine.

### Termination

* Alice sends a FAX to Bob on her T.38-capable FAX machine.
* The server receives the FAX.
* The server notifies Bob that a FAX has been received for him.
* Bob prints the contents of the FAX on a local printer.




!!! note 
    I have not included a "gateway" FAX scenario because from the user perspective, it is the same as pass-through.

      
[//]: # (end-note)



Registrations
=============




!!! note 
    The following scenarios were created under the assumption that the new chan\_sip will, like the current chan\_sip, initially only support a single contact URI per address of record. If multiple contacts are allowed per AoR, then there are several further use cases that could be listed.

      
[//]: # (end-note)



### Initial registration

* Alice plugs her new SIP phone into the network.
* The SIP phone registers its location with the server with a specified expiration.
* Bob places a call to Alice.
* The server is able to locate Alice's phone and call her.

### Re-registration

* Alice plugs her new SIP phone into the network.
* The SIP phone registers its location with the server with a specified expiration.
* When the expiration is reached, Alice's phone should refresh the registration.
* Bob places a call to Alice.
* The server is able to locate Alice's phone and call her.

### Registration timeout

* Alice plugs her new SIP phone into the network.
* The SIP phone registers its location with the server with a specified expiration.
* Alice removes her SIP phone from the network.
* The expiration time from the original registration is reached.
* Bob places a call to Alice.
* The server is unable to locate Alice's phone to call her.
* Bob hears a fast busy tone.

### Unregistration

* Alice plugs her new SIP phone into the network.
* The SIP phone registers its location with the server with a specified expiration.
* Alice performs a software shutdown on her phone.
* The phone unregisters its location with the server.
* Bob places a call to Alice.
* The server is unable to locate Alice's phone to call her.
* Bob hears a fast busy tone.

Subscriptions
=============




!!! note 
    The tests described below exercise features that the current Asterisk chan\_sip has. It may be worthwhile to pursue more options in the new chan\_sip, especially as it pertains to PUBLISH support.

      
[//]: # (end-note)



Message Waiting
---------------

### Message Waiting Notification

* Alice receives a voicemail.
* Alice's phone's indicator light glows.
* Alice listens to the voicemail and deletes it.
* Alice's phone's indicator light stops glowing.

Presence
--------

### Presence Notification

* Alice adds Bob as a contact on her phone.
* Bob receives an incoming call.
* Bob's phone starts ringing.
* A light on Alice's phone flashes.
* Bob answers the call.
* The light on Alice's phone glows solid.
* Bob finishes his call.
* The light on Alice's phone stops glowing.

### Dialog-info Notification

* Alice adds Bob as a contact on her phone.
* Bob receives an incoming call from Carol.
* Bob's phone starts ringing.
* A light on Alice's phone flashes.
* Alice presses a button on her phone to see information about the call and sees that the call is to Bob from Carol.
* Bob answers the call.
* The light on Alice's phone glows solid.
* Bob finishes his call.
* The light on Alice's phone stops glowing.

### Call pickup

* Alice adds Bob as a contact on her phone.
* Bob receives an incoming call from Carol.
* Bob's phone starts ringing.
* A light on Alice's phone flashes.
* Alice presses a button to retrieve the call.
* Carol's phone's display indicates Alice answered the call.
* Alice's phone's display indicates she is connected to Carol.
* Audio flows bidirectionally between Alice and Carol.
* Alice hangs up.

Call Completion
---------------




!!! note 
    The following scenarios exercise CCBS, but CCNR is just as applicable.

      
[//]: # (end-note)



### CCBS: Normal

* Alice calls Bob's extension.
* Bob is busy.
* Alice presses a button on her phone to request call completion.
* Bob ends his current call.
* Alice's phone rings.
* Alice answers the ringing phone.
* Bob's phone rings.
* Bob answers the ringing phone.
* Audio flows bidirectionally between Alice and Bob.
* Alice hangs up.

### CCBS: Timeout

* Alice calls Bob's extension.
* Bob is busy.
* Alice presses a button on her phone to request call completion with a specified expiration.
* Bob stays on his call longer than the expiration.
* Bob ends his call.
* Nothing more happens.

### CCBS: Caller busy

* Alice calls Bob's extension.
* Bob is busy.
* Alice presses a button on her phone to request call completion.
* Alice receives a call from Carol.
* Alice answers the call and speaks with Carol.
* Bob ends his current call.
* Alice ends her call with Carol.
* Alice's phone rings.
* Alice answers the ringing phone.
* Bob's phone rings.
* Bob answers the ringing phone.
* Audio flows bidirectionally between Alice and Bob.
* Alice hangs up.

Messaging
=========

### Passthrough

* Alice sends Bob a message from her SIP instant messenger client.
* The message passes through the server to Bob.
* Bob receives the message on his SIP instant messenger client.

### Origination

* Alice leaves a voicemail for Bob.
* The server sends an instant message to Bob's SIP instant messenger client telling him he has a new voicemail from Alice.

### Termination

* Alice sends Bob a message from her SIP instant messenger client.
* The server receives the message.
* The server sends the contents of the message to Alice's e-mail address.
