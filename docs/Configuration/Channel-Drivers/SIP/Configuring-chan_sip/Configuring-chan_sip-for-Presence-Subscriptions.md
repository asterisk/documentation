---
title: Configuring chan_sip for Presence Subscriptions
pageid: 29392926
---

Overview
========

This page is a rough guide to get you configuring chan\_sip and Asterisk to accept subscriptions for presence (in this case, [Extension State](/Extension-State-and-Hints)) and notify the subscribers of state changes.

Requirements
============

You should understand the basics of

* [Device State](/Device-State) and [Extension State and Hints](/Extension-State-and-Hints)
* Configuring SIP peers in sip.conf

General Process
===============

Overview
--------

It is best to consider this configuration in the context of a very simplified use case. It should illustrate the overall concept, as well as the ability for Extension State to aggregate Device States.

The case is that our administrator wants the user device of SIP/Alice to display the presence of Bob. Bob has two devices, SIP/Bob-mobile and SIP/Bob-desk. He could be on either device at any one time, so we want to map them both to the same Hint. That way, when Alice subscribes to the Hint, she'll get the aggregated Extension State of Bob's devices. That means if either of Bobs phones are busy, then the extension state will be busy. Then Alice knows that Bob is busy without having to have a separate light for each of Bob's phones.

Figure 1 should illustrate the overall relationships of the different elements involved.

Then following down the page you can find detail on configuring the three major elements, SIP configuration options, hints in dialplan, and configuring a phone to subscribe.

Configure SIP options
---------------------

Since this is not a guide on configuring SIP peers, we'll show a very simple **sip.conf**  with only enough configuration to point out where you might set specific [chan\_sip State and Presence Options](/chan_sip-State-and-Presence-Options) .




---

  
  


```

[general]
callcounter=yes

[Alice]
type=friend
subscribecontext=default
allowsubscribe=yes

[Bob-mobile]
type=friend
busylevel=1

[Bob-desk]
type=friend
busylevel=1

```



---


We are setting one option in the general section, and then a few options across the three SIP peers involved.

**callcounter** and **busylevel** are the most essential options. **callcounter** needs to be enabled for chan\_sip to provide accurate device. **busylevel**=1 says we want the device states of those peers to show busy if they have at least one call in progress. The **subscribecontext** option tells Asterisk which dialplan context to look for the hint. **allowsubscribe** says that we will allow subscriptions for that peer. It is really set to yes by default, but we are defining it here to demonstrate that you could allow and disallow subscriptions on a per-peer basis if you wanted.

Figure 1![](ExtensionAndDeviceState.png) 

This diagram is purposefully simplified to only show the relationships between the  


Configure Hints
---------------

Hints are configured in Asterisk [dialplan](/Dialplan) (extensions.conf). This is where you map [Device State](/Device-State) identifiers or [Presence State](/Presence-State) identifiers to a hint, which will then be subscribed to by one or more SIP User Agents.

For our example we need to define a hint mapping 6001 to Bob's two devices.




---

  
  


```

[default]
exten = 6001,hint,SIP/Bob-mobile&SIP/Bob-desk

```



---


Defining the hint is pretty straightforward and follows the syntax discussed in the [Extension State and Hints](/Extension-State-and-Hints) section.

Notice that we put it in the context we set in **subscribecontext** in sip.conf earlier. Otherwise we would need to make sure it is in the same context that the SIP peer uses (defined with "context").

If you have restarted Asterisk to load the hints, then you can check to make sure they are configured with "core show hints"




---

  
  


```

\*CLI> core show hints
 -= Registered Asterisk Dial Plan Hints =-
 6001@default : SIP/Bob-mobile&SIP/B State:Unavailable Watchers 0

```



---


You'll see the state changes to Idle or something else if you have your sip.conf configured properly and the two SIP devices are at least available.

Configure Subscriber
--------------------

You should configure your SIP User Agent (soft-phone, hard-phone, another phone application like Asterisk) to subscribe to the hint. In this case that is SIP/Alice and we want her phone to subscribe to 6001.

The process will be different for every phone, and keep in mind that some phones may not support Asterisk's state notification. With most phones it'll be a matter of adding a "contact" to a contact list, buddy list, or address book and then making sure that SIP presence is enabled in the options.

If you want to submit a guide for a specific phone, feel free to comment on this page or submit it to the [Asterisk issue tracker](/Asterisk-Issue-Guidelines).

Operation
---------

Typically as soon as you add the contact or subscription on the phone then it will attempt to SUBSCRIBE to Asterisk.

If you haven't done so, restart Asterisk and then restart the SIP User Agent client doing the subscribing.

The flow of SIP messaging can differ based on configuration, but typically looks like this for a peer that requires authentication:




---

  
  


```

SIP/Alice Asterisk
----------------------------------------
SUBSCRIBE --->
 <--- 401 Unauthorized
SUBSCRIBE(w/ Auth) --->
 <--- 200 OK
 <--- NOTIFY
200 OK --->

```



---


In the expanding frame below is a SIP trace of a successful subscription for reference. You could see this on your own system by running "sip set debug on" and then watching for the subscription. You might have to restart your phone again or re-add a contact to see it.

Click to see the subscription trace...


---

  
  


```

<--- SIP read from UDP:10.24.17.254:37509 --->
SUBSCRIBE sip:6001@10.24.18.124;transport=UDP SIP/2.0
Via: SIP/2.0/UDP 10.24.17.254:37509;branch=z9hG4bK-d8754z-e5ecfde1f337b690-1---d8754z-
Max-Forwards: 70
Contact: <sip:Alice@10.24.17.254:37509;transport=UDP>
To: <sip:6001@10.24.18.124;transport=UDP>
From: <sip:Alice@10.24.18.124;transport=UDP>;tag=f51e9632
Call-ID: ZjE2ZDAwYThiOTA2MzYxOWEwNTEwMjc1ZGIxNTk3NDU.
CSeq: 1 SUBSCRIBE
Expires: 1800
Accept: application/pidf+xml
Allow: INVITE, ACK, CANCEL, BYE, NOTIFY, REFER, MESSAGE, OPTIONS, INFO, SUBSCRIBE
Supported: replaces, norefersub, extended-refer, timer, X-cisco-serviceuri
User-Agent: Z 3.2.21357 r21103
Event: presence
Allow-Events: presence, kpml
Content-Length: 0

<------------->
--- (16 headers 0 lines) ---
Sending to 10.24.17.254:37509 (no NAT)
Creating new subscription
Sending to 10.24.17.254:37509 (no NAT)
list\_route: route/path hop: <sip:Alice@10.24.17.254:37509;transport=UDP>
Found peer 'Alice' for 'Alice' from 10.24.17.254:37509

<--- Transmitting (no NAT) to 10.24.17.254:37509 --->
SIP/2.0 401 Unauthorized
Via: SIP/2.0/UDP 10.24.17.254:37509;branch=z9hG4bK-d8754z-e5ecfde1f337b690-1---d8754z-;received=10.24.17.254
From: <sip:Alice@10.24.18.124;transport=UDP>;tag=f51e9632
To: <sip:6001@10.24.18.124;transport=UDP>;tag=as46a6e039
Call-ID: ZjE2ZDAwYThiOTA2MzYxOWEwNTEwMjc1ZGIxNTk3NDU.
CSeq: 1 SUBSCRIBE
Server: Asterisk PBX SVN-branch-12-r413487
Allow: INVITE, ACK, CANCEL, OPTIONS, BYE, REFER, SUBSCRIBE, NOTIFY, INFO, PUBLISH, MESSAGE
Supported: replaces, timer
WWW-Authenticate: Digest algorithm=MD5, realm="asterisk", nonce="522456f4"
Content-Length: 0


<------------>
Scheduling destruction of SIP dialog 'ZjE2ZDAwYThiOTA2MzYxOWEwNTEwMjc1ZGIxNTk3NDU.' in 32000 ms (Method: SUBSCRIBE)

<--- SIP read from UDP:10.24.17.254:37509 --->
SUBSCRIBE sip:6001@10.24.18.124;transport=UDP SIP/2.0
Via: SIP/2.0/UDP 10.24.17.254:37509;branch=z9hG4bK-d8754z-c6908de6f0126edf-1---d8754z-
Max-Forwards: 70
Contact: <sip:Alice@10.24.17.254:37509;transport=UDP>
To: <sip:6001@10.24.18.124;transport=UDP>
From: <sip:Alice@10.24.18.124;transport=UDP>;tag=f51e9632
Call-ID: ZjE2ZDAwYThiOTA2MzYxOWEwNTEwMjc1ZGIxNTk3NDU.
CSeq: 2 SUBSCRIBE
Expires: 1800
Accept: application/pidf+xml
Allow: INVITE, ACK, CANCEL, BYE, NOTIFY, REFER, MESSAGE, OPTIONS, INFO, SUBSCRIBE
Supported: replaces, norefersub, extended-refer, timer, X-cisco-serviceuri
User-Agent: Z 3.2.21357 r21103
Authorization: Digest username="Alice",realm="asterisk",nonce="522456f4",uri="sip:6001@10.24.18.124;transport=UDP",response="6d66dcad8c176aa3ef7baec7680d2445",algorithm=MD5
Event: presence
Allow-Events: presence, kpml
Content-Length: 0

<------------->
--- (17 headers 0 lines) ---
Creating new subscription
Sending to 10.24.17.254:37509 (no NAT)
Found peer 'Alice' for 'Alice' from 10.24.17.254:37509
Looking for 6001 in default (domain 10.24.18.124)
Scheduling destruction of SIP dialog 'ZjE2ZDAwYThiOTA2MzYxOWEwNTEwMjc1ZGIxNTk3NDU.' in 1810000 ms (Method: SUBSCRIBE)

<--- Transmitting (no NAT) to 10.24.17.254:37509 --->
SIP/2.0 200 OK
Via: SIP/2.0/UDP 10.24.17.254:37509;branch=z9hG4bK-d8754z-c6908de6f0126edf-1---d8754z-;received=10.24.17.254
From: <sip:Alice@10.24.18.124;transport=UDP>;tag=f51e9632
To: <sip:6001@10.24.18.124;transport=UDP>;tag=as46a6e039
Call-ID: ZjE2ZDAwYThiOTA2MzYxOWEwNTEwMjc1ZGIxNTk3NDU.
CSeq: 2 SUBSCRIBE
Server: Asterisk PBX SVN-branch-12-r413487
Allow: INVITE, ACK, CANCEL, OPTIONS, BYE, REFER, SUBSCRIBE, NOTIFY, INFO, PUBLISH, MESSAGE
Supported: replaces, timer
Expires: 1800
Contact: <sip:6001@10.24.18.124:5060>;expires=1800
Content-Length: 0


<------------>
set\_destination: Parsing <sip:Alice@10.24.17.254:37509;transport=UDP> for address/port to send to
set\_destination: set destination to 10.24.17.254:37509
Reliably Transmitting (no NAT) to 10.24.17.254:37509:
NOTIFY sip:Alice@10.24.17.254:37509;transport=UDP SIP/2.0
Via: SIP/2.0/UDP 10.24.18.124:5060;branch=z9hG4bK14aacddc
Max-Forwards: 70
From: <sip:6001@10.24.18.124;transport=UDP>;tag=as46a6e039
To: <sip:Alice@10.24.18.124;transport=UDP>;tag=f51e9632
Contact: <sip:6001@10.24.18.124:5060>
Call-ID: ZjE2ZDAwYThiOTA2MzYxOWEwNTEwMjc1ZGIxNTk3NDU.
CSeq: 102 NOTIFY
User-Agent: Asterisk PBX SVN-branch-12-r413487
Subscription-State: active
Event: presence
Content-Type: application/pidf+xml
Content-Length: 530

<?xml version="1.0" encoding="ISO-8859-1"?>
<presence xmlns="urn:ietf:params:xml:ns:pidf" 
xmlns:pp="urn:ietf:params:xml:ns:pidf:person"
xmlns:es="urn:ietf:params:xml:ns:pidf:rpid:status:rpid-status"
xmlns:ep="urn:ietf:params:xml:ns:pidf:rpid:rpid-person"
entity="sip:Alice@10.24.18.124">
<pp:person><status>
<ep:activities><ep:away/></ep:activities>
</status></pp:person>
<note>Unavailable</note>
<tuple id="6001">
<contact priority="1">sip:6001@10.24.18.124</contact>
<status><basic>closed</basic></status>
</tuple>
</presence>

---

<--- SIP read from UDP:10.24.17.254:37509 --->
SIP/2.0 200 OK
Via: SIP/2.0/UDP 10.24.18.124:5060;branch=z9hG4bK14aacddc
Contact: <sip:Alice@10.24.17.254:37509;transport=UDP>
To: <sip:Alice@10.24.18.124;transport=UDP>;tag=f51e9632
From: <sip:6001@10.24.18.124;transport=UDP>;tag=as46a6e039
Call-ID: ZjE2ZDAwYThiOTA2MzYxOWEwNTEwMjc1ZGIxNTk3NDU.
CSeq: 102 NOTIFY
User-Agent: Z 3.2.21357 r21103
Content-Length: 0

<------------->
--- (9 headers 0 lines) ---





```



---


Once the subscription has taken place, there is a command to list them. "sip show subscriptions"




---

  
  


```

\*CLI> sip show subscriptions
Peer User Call ID Extension Last state Type Mailbox Expiry
10.24.17.254 Alice ZjE2ZDAwYThiOTA 6001@default Unavailable pidf+xml <none> 001800
1 active SIP subscription

```



---


From this point onward, Asterisk should send out a SIP NOTIFY to the Alice peer whenever state changes for any of the devices mapped to the hint 6001. Alice's phone should then reflect that state on its display.

 

