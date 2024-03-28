---
title: res_pjsip Remote Attended Transfers
pageid: 31096903
---

What is a remote SIP transfer?
==============================

Let's imagine a scenario where Alice places a call to Bob, and then Bob performs an attended transfer to Carol. In this scenario, Alice is registered to Asterisk instance A (asterisk_a.com), and Bob is registered to Server B (server_b.com), a non-Asterisk PBX. The key to this scenario is that Asterisk A has been explicitly configured to be able to call Bob directly, despite the fact that Bob does not register to Asterisk A.

Initially, Alice places a call to Bob through Alice's Asterisk instance:

![](Full-call.png)

The arrows indicate the direction of the initial call. The Call-ID, from-tag, and to-tag will become important later.

Now, Bob wants to perform an attended transfer to Carol, so he places a call to Carol:

![](Alice-to-Bob-to-Carol.png)

As you can see, Bob has simultaneous calls through two separate servers. Now when Bob performs the attended transfer, what happens? Bob will send a SIP REFER request to either Asterisk A or Server B to get the two SIP servers in contact with each other. Most phones will send the REFER to Asterisk A since it is the original leg of the call, so that is what we will do in our scenario. The REFER request has a Refer-To header that specifies details of the transfer. The Refer-To header for this particular transfer looks like the following:

```
Refer-To: <sip:carol@server_b.com?Replaces=ABCDE%3Bto-tag%3DBtoBobfrom-tag%3DBobtoB>

```

That's a bit verbose. So let's break it down a little bit. First, there is a SIP URI:

```
sip:carol@server_b.com

```

Next, there is a Replaces URI header. There are some URL-escaped character sequences in there. If we decode them, we get the following:

```
Replaces: ABCDE;to-tag=BtoBob;from-tag=BobtoB

```

If we break down the parts of this, what the Replaces section tells us is that the REFER request is saying that the SIP dialog with Call-ID "ABCDE", to-tag "BtoBob" and from-tag "BobtoB" needs to be replaced by the party (or parties) that Bob is talking to.

Asterisk has built into it a bit of an optimization to avoid unnecessary SIP traffic by looking up the dialog referred to by the Replaces header. If the dialog is found in the Asterisk system, then Asterisk simply performs a local attended transfer. This involves internal operations such as moving a channel from one bridge to another, or creating a local channel to link two bridges together.

However, in this case, the dialog referred to by Bob's Replaces header is not on Asterisk A. It is on Server B. So Asterisk A cannot perform a local attended transfer. This is where a remote attended transfer is required.

From a SIP point of view
========================

Remote attended transfers are the type of attended transfers referred to in SIP specifications, such as [RFC 5589 section 7](https://tools.ietf.org/html/rfc5589#section-7). When a SIP user agent receives a REFER request, the user agent is supposed to send an INVITE to the URI in the Refer-To header to start a new call with the user agent at that URI. The INVITE should have a Replaces header that has the same contents as the Replaces URI header from the REFER request. This tells the user agent that receives the INVITE to replace the referenced dialog with this new call instead.

In the scenario above, when Asterisk A receives the REFER request from Bob, Asterisk A should respond by sending an INVITE to `sip:carol@server_b.com` and add

```
Replaces: ABCDE;to-tag=BtoBob;from-tag=BobtoB

```

When Server B receives this INVITE, it will essentially swap this new call in for the call referenced by the Replaces header. By doing this, the final picture looks something like the following:

![](Complete-transfer.png)

A new dialog with Call-ID ZYXWV has replaced the previous dialog with Call-ID ABCDE. The previously-illustrated dialog between Bob and Asterisk A with Call-ID 12345 is gone because Bob's phone ended that dialog once the transfer was completed.

How Asterisk handles this
=========================

Asterisk will rarely ever directly place outbound calls without going through the dialplan. When Asterisk A receives the REFER request from Bob, Asterisk does not immediately send an INVITE with Replaces header to Server B. Instead, Asterisk A looks for a specifically-named extension called "external_replaces". Asterisk searches for this extension in the context specified by the `TRANSFER_CONTEXT` channel variable on Bob's channel. If `TRANSFER_CONTEXT` is not specified, then Asterisk searches for the extension in Bob's endpoint's context setting. Once in the dialplan, it is the job of the dialplan writer to determine whether to complete the transfer or not.

In the external_replaces extension, you will have access to the following channel variables:

* `SIPTRANSFER`: This variable is set to "yes" upon entering the `external_replaces` extension, and indicates that a SIP transfer is happening. This is only useful if, for whatever reason, you are using the `external_replaces` extension for additional purposes than a SIP remote attended transfer.
* `SIPREFERRINGCONTEXT`: This is the dialplan context in which the `external_replaces` extension was found. This may be useful if your `external_replaces` extension calls into subroutines or jumps to other contexts.
* `SIPREFERTOHDR`: This is the SIP URI in the Refer-To header in the REFER request sent by the transferring party.

The big reason why Asterisk calls into the dialplan instead of automatically sending an INVITE to the Refer-To URI is for security purposes. If Asterisk automatically sent an INVITE out without going through the dialplan, there are chances that transfers could be used to place calls to unwanted destinations that could, for instance, charge you a lot of money for the call.

Writing your `external_replaces` extension
==========================================

Now that the theory has been presented, you'll need to write your `external_replaces` extension. One option you have is to not write an `external_replaces` extension at all. This will prevent any remote attended transfers from succeeding.

If you do want to write an `external_replaces` extension, the first thing you want to do is determine if you want to perform the remote attended transfer.  `SIPREFERTOHDR`, and values provided by the `CHANNEL()` dialplan function can help you to decide if you want to allow the transfer. For instance, you might use `CHANNEL(endpoint)` to see which PJSIP endpoint is performing the transfer, and you can inspect `SIPREFERTOHDR` to determine if the transfer is destined for a trusted domain.




!!! note 
    Asterisk dialplan contains functions for manipulating strings. A function [Asterisk 13 Function_PJSIP_PARSE_URI](/Latest_API/API_Documentation/Dialplan_Functions/PJSIP_PARSE_URI) exists for parsing a URI within the dialplan.

      
[//]: # (end-note)



If you decide not to perform the transfer, the simplest thing to do is to call the `Hangup()` application.




!!! note 
    Calling `Hangup()` in this situation can have different effects depending on what type of phone Bob is using. Asterisk updates the phone with a notification that the attended transfer failed. It is up to the phone to decide if it wants to try to reinvite itself back into the original conversation with Alice or simply hang up.

      
[//]: # (end-note)



If you decide to perform the transfer, the most straightforward way to do this is with the `Dial()` application. Here is an example of how one might complete the transfer

```
exten => external_replaces,1,NoOp()
 same => n,Dial(PJSIP/default_outgoing/${SIPREFERTOHDR})

```

Let's examine that `Dial()` more closely. First, we're dialing using PJSIP, which is pretty obvious. Next, we have the endpoint name. The endpoint name could be any configured endpoint you want to use to make this call. Remember that endpoint settings are things such as what codecs to use, what user name to place in the from header, etc. By default, if you just dial `PJSIP/some_endpoint`, Asterisk looks at some_endpoint's configured `aors` to determine what location to send the outgoing call to. However, you can override this default behavior and specify a URI to send the call to instead. This is what is being done in this `Dial()` statement. We're dialing using settings for an endpoint called "default_outgoing", presumably used as a default endpoint for outgoing calls. We're sending the call out to the URI specified by `SIPREFERTOHDR` though. Using the scenario on this page, the `Dial()` command would route the call to `sip:carol@server_b`.

This will create automatically place the *Replaces*Header in the INVITE.

Accepting INVITEs of Remote Attended Transfers
==============================================

In the above example lets say Server B is also running Asterisk and you want to accept the attended transfer you've just placed to it from your `external_replaces` extension as above (or perhaps you've another SIP device sending a transfer this way to Asterisk).

When Server B's pjsip receives the INVITE, lets say, continuing from the `Dial()` in the above example, to `sip:carol@server_b`, it'll first check that the extension exists before it checks the Replaces header. This means that you need to ensure that this extension (carol) exists in the context associated with the endpoint of Server A, otherwise the call will simply be rejected, regardless of if the call referenced in the Replaces header matches an active call. In reality if all works as needed, this extension in the dialplan will never actually be hit. Assuming that the extension exists, pjsip will now check if the call referenced in the Replaces header exists and is in a valid state. Assuming a valid existing call can be matched then this new INVITE will be accepted and simply take over that call. It'll never actually hit the extension in the dialplan, at least not initially. Asterisk will hangup the call references (in this example, the call from Bob to Server B), and then Carol's call will be bridged to the new call, that being the call to Server A (which is in turn bridged to Alice on Server A). Re-INVITEs will be sent as required to ensure that the SDP all gets sent to the right place.

If a valid call can't be found matching the Replaces header, then the call will hit the extension in the dialplan (carol) and proceed like a normal INVITE. You could handle this by allow a new call to be placed to the extension, although this may be confusing for users and likely means something has gone wrong. In the example, Carol would still have an active call, and then start getting a new call through. An alternative is to send calls in the `external_replaces` extension `Dial` command to a specific destination on Server B, for example "replaces", where you could simply hangup or play a message notifying the user that something's gone wrong.

Avoiding Remote Attended Transfers
==================================

In Asterisk, remote attended transfers are sometimes necessary, but avoiding them is typically a good idea. The biggest reason is the security concerns of allowing users to make calls to untrusted domains.

The easiest but most severe way to prevent remote attended transfers is to set `allow_transfer = no` for all endpoints. The problem with doing this is that it also prevents local attended transfers and blind transfers.

A second way has been discussed already, and that is not to write an `external_replaces` extension. This prevents any attempted remote attended transfers from succeeding, but it does not help to prevent the remote attended transfer from happening in the first place.

Another way is to configure your Asterisk server to only call phones that are directly registered to it and trusted SIP servers. In the scenario we have been inspecting, the remote attended transfer could have been avoided by having Asterisk A call Bob through Server B instead of dialing Bob directly. By receiving the initial call through Server B, Bob will send his REFER request to Server B, who being aware of all necessary dialogs, may be able to perform a local attended transfer (assuming it can do the same optimization as Asterisk). Configuring Asterisk this way is not necessarily guaranteed to prevent all remote attended transfer attempts, but it will help to lessen them.

