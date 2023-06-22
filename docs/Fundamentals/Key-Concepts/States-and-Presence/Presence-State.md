---
title: Presence State
pageid: 21463121
---

Overview
========

Asterisk 11 has been outfitted with support for presence states. An easy way to understand this is to compare presence state support to the device state support Asterisk has always had. Like with device state support, Asterisk has a core API so that modules can register themselves as presence state providers, alert others to changes in presence state, and query the presence state of others. The difference between the device and presence state concepts is made clear by understanding the subject of state for each concept.

* Device state reflects the current **state of a physical device** connected to Asterisk
* Presence state reflects the current **state of the user** of the device

For example, a **device** may currently be `not in use` but the **person** is `away`. This can be a critical detail when determining the availability of the **person**.

While the architectures of presence state and device state support in Asterisk are similar, there are some key differences between the two.

* Asterisk cannot infer presence state changes the same way it can device state changes. For instance, when a SIP endpoint is on a call, Asterisk can infer that the device is being used and report the device state as `in use`. Asterisk cannot infer whether a user of such a device does not wish to be disturbed or would rather chat, though. Thus, all presence state changes have to be manually enacted.
* Asterisk does not take presence into consideration when determining availability of a device. For instance, members of a queue whose device state is `busy` will not be called; however, if that member's device is `not in use` but his presence is `away` then Asterisk will still attempt to call the queue member.
* Asterisk cannot aggregate multiple presence states into a single combined state. Multiple device states can be listed in an extension's hint priority to have a combined state reported. Presence state support in Asterisk lacks this concept.
On this PagePresence States
===============

* `not_set`: No presence state has been set for this entity.
* `unavailable`: This entity is present but currently not available for communications.
* `available`: This entity is available for communication.
* `away`: This entity is not present and is unable to communicate.
* `xa`: This entity is not present and is not expected to return for a while.
* `chat`: This entity is available to communicate but would rather use instant messaging than speak.
* `dnd`: This entity does not wish to be disturbed.

Subtype and Message
===================

In addition to the basic presence states provided, presence also has the concept of a **subtype** and a **message**.

The subtype is a brief method of describing the nature of the state. For instance, a subtype for the `away` status might be "at home".

The message is a longer explanation of the current presence state. Using the same `away` example from before, the message may be "Sick with the flu. Out until the 18th".

`func_presencestate` And The `CustomPresence` Provider
======================================================

The only provider of presence state in Asterisk 11 is the `CustomPresence` provider. This provider is supplied by the `func_presencestate.so` module, which grants access to the `PRESENCE_STATE` dialplan function. The documentation for `PRESENCE_STATE` can be found [here](/Asterisk-11-Function_PRESENCE_STATE). `CustomPresence` is device-agnostic within the core and can be a handy way to set and query presence from [dialplan](/Asterisk-11-Function_PRESENCE_STATE), or APIs such as the [AMI](/Asterisk-11-ManagerAction_PresenceState).

A simple use case for `CustomPresence` in dialplan is demonstrated below.




---

  
  


```

[default]
exten => 2000,1,Answer()
same => n,Set(CURRENT\_PRESENCE=${PRESENCE\_STATE(CustomPresence:Bob,value)})
same => n,GotoIf($[${CURRENT\_PRESENCE}=available]?set\_unavailable:set\_available)
same => n(set\_available),Set(PRESENCE\_STATE(CustomPresence:Bob)=available,,)
same => n,Goto(finished)
same => n(set\_unavailable),Set(PRESENCE\_STATE(CustomPresence:Bob)=unavailable,,)
same => n(finished),Playback(queue-thankyou)
same => n,Hangup

exten => 2001,1,GotoIf($[${PRESENCE\_STATE(CustomPresence:Bob,value)}!=available]?voicemail)
same => n,Dial(SIP/Bob)
same => n(voicemail)VoiceMail(Bob@default)


```


With this dialplan, a user can dial `2000@default` to toggle Bob's presence between `available` and `unavailable`. When a user attempts to call Bob using `2001@default`, if Bob's presence is currently not `available` then the call will go directly to voicemail.




!!! note 
    One thing to keep in mind with the `PRESENCE_STATE` dialplan function is that, like with `DEVICE_STATE`, state may be queried from any presence provider, but `PRESENCE_STATE` is only capable of setting presence state for the `CustomPresence` presence state provider.

      
[//]: # (end-note)



Configuring Presence Subscription with Hints
============================================

As is mentioned in the phone support section, at the time of writing this will only work with a Digium phone.

Like with device state, presence state is associated to a dialplan extension with a hint. Presence state hints come after device state in the hint extension and are separated by a comma (`,`). As an example:




---

  
  


```

[default]
exten => 2000,hint,SIP/2000,CustomPresence:2000
exten => 2000,1,Dial(SIP/2000)
same => n,Hangup()


```


Or alternatively, you could define the presence state provider without a device.




---

  
  


```

exten => 2000,hint,,CustomPresence:2000


```


The **first** example would allow for someone subscribing to the extension state of `2000@default` to be notified of device state changes for device `SIP/2000` as well as presence state changes for the presence provider `CustomPresence:2000`.

The **second** example would allow for the subscriber to receive notification of state changes for only the presence provider CustomPresence:2000.

The `CustomPresence` presence state provider will be discussed further on this page.

Also like with device state, there is an [Asterisk Manager Interface](/Asterisk-Manager-Interface--AMI-) command for querying presence state. Documentation for the AMI `PresenceState` command can be found [here](/Asterisk-11-ManagerAction_PresenceState).

### Example Presence Notification

When a SIP device is subscribed to a hint you have configured in Asterisk and that hint references a presence state provider, then upon change of that state Asterisk will generate a notification. That notification will take the form of a SIP NOTIFY including XML content. In the expanding panel below I've included an example of a presence notification sent to a Digium phone. This particular presence notification happened when we changed presence state for CustomPresence:6002 via the CLI command 'presencestate change'.

Click here to see the NOTIFY example


---

  
  


```

myserver\*CLI> presencestate change CustomPresence:6002 UNAVAILABLE
Changing 6002 to UNAVAILABLE
set\_destination: Parsing <sip:6002@10.24.18.138:5060;ob> for address/port to send to
set\_destination: set destination to 10.24.18.138:5060
Reliably Transmitting (no NAT) to 10.24.18.138:5060:
NOTIFY sip:6002@10.24.18.138:5060;ob SIP/2.0
Via: SIP/2.0/UDP 10.24.18.124:5060;branch=z9hG4bK68008251;rport
Max-Forwards: 70
From: sip:6002@10.24.18.124;tag=as722c69ec
To: "Bob" <sip:6002@10.24.18.124>;tag=4DpRZfRIlaKU9iQcaME2APx85TgFOEN7
Contact: <sip:6002@10.24.18.124:5060>
Call-ID: JVoQfeZe1cWTdPI5aTWkRpdqkjs8zmME
CSeq: 104 NOTIFY
User-Agent: Asterisk PBX SVN-branch-12-r413487
Subscription-State: active
Event: presence
Content-Type: application/pidf+xml
Content-Length: 602

<?xml version="1.0" encoding="ISO-8859-1"?>
<presence xmlns="urn:ietf:params:xml:ns:pidf" 
xmlns:pp="urn:ietf:params:xml:ns:pidf:person"
xmlns:es="urn:ietf:params:xml:ns:pidf:rpid:status:rpid-status"
xmlns:ep="urn:ietf:params:xml:ns:pidf:rpid:rpid-person"
entity="sip:6002@10.24.18.124">
<pp:person><status>
</status></pp:person>
<note>Ready</note>
<tuple id="6002">
<contact priority="1">sip:6002@10.24.18.124</contact>
<status><basic>open</basic></status>
</tuple>
<tuple id="digium-presence">
<status>
<digium\_presence type="unavailable" subtype=""></digium\_presence>
</status>
</tuple>
</presence>

---
 == Extension Changed 6002[from-internal] new state Idle for Notify User 6002 

<--- SIP read from UDP:10.24.18.138:5060 --->
SIP/2.0 200 OK
Via: SIP/2.0/UDP 10.24.18.124:5060;rport=5060;received=10.24.18.124;branch=z9hG4bK68008251
Call-ID: JVoQfeZe1cWTdPI5aTWkRpdqkjs8zmME
From: <sip:6002@10.24.18.124>;tag=as722c69ec
To: "Bob" <sip:6002@10.24.18.124>;tag=4DpRZfRIlaKU9iQcaME2APx85TgFOEN7
CSeq: 104 NOTIFY
Contact: "Bob" <sip:6002@10.24.18.138:5060;ob>
Allow: PRACK, INVITE, ACK, BYE, CANCEL, UPDATE, SUBSCRIBE, NOTIFY, REFER, MESSAGE, OPTIONS
Supported: replaces, 100rel, timer, norefersub
Content-Length: 0

<------------->



```


Phone Support for Presence State via SIP presence notifications
===============================================================

At the time of writing, only Digium phones have built-in support for interpreting Asterisk's Presence State notifications (as opposed to SIP presence notifications for extension/device state). The CustomPresence provider itself is device-agnostic and support for other devices could be added in. Or devices themselves (soft-phone or hardphone) could be modified to interpret the XML send out in the Presence State notification.

Digium Phones
-------------

[This Video](http://www.youtube.com/watch?v=yMuGMGl4Ww0) provides more insight on how presence can be set and viewed on Digium phones.

When using Digium phones with the [Digium Phone Module for Asterisk](http://downloads.digium.com/pub/telephony/res_digium_phone/), you can set hints in Asterisk so that when one Digium phone's presence is updated, other Digium phones can be notified of the presence change. The DPMA automatically creates provisions such that when a Digium Phone updates its presence, `CustomPresence:<line name>` is updated, where `<line name>` is the value set for the `line=` option in a `type=phone` category. Using the example dialplan from the Overview section, Digium phones that are subscribed to `2000@default` will automatically be updated about line 2000's presence whenever line 2000's presence changes.




!!! tip 
    Digium phones support only the available, away, dnd, xa, and chat states. The unavailable and not\_set states are not supported.

      
[//]: # (end-tip)



