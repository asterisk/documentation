---
title: PJSIP Advanced Codec Negotiation
pageid: 44795874
---

Preface
=======

This document is by no means complete and neither is the software as of July 15, 2020.  There are still lots of things to implement and/or test.

* Direct Media
* 100rel/early media
* Re-invites
* Fax
* Multi-stream
* Deferred SDP
* ARI channel operations
* Interoperability with other channel drivers
* Dialplan function
* etc.

We're still working on it.

Introduction
============

With the release of Asterisk 18 comes a new Advanced Codec Negotiation process.  Not only does this create new configuration opportunities but also completely refactors the negotiation process itself.  The result is an easier to understand negotiation process that's implemented in far less code.  The PJSIP channel driver is currently the only one to adopt the new process but it other drivers could be altered to use it in the future.  They would have to adopt the Streams interface however.

Architecture
============

When thinking about the negotiation process, we're really talking about negotiating stream topologies between two entities.   For every channel, there's a topology that contains one or more streams that describe the media.   The negotiation process actually happens on a stream-by-stream basis but we're going to use the "simple audio call" as an example.  The topology would only contain one "audio" stream but that stream could, of course, allow multiple codecs. 

Since Asterisk is a Back-2-Back User Agent, there is virtually no scenario (even with Direct Media) where the calling and called parties negotiate directly with each other.  We have 2 channels and the Asterisk Core involved.  With that in mind,  if Alice calls Bob, Alice negotiates with Alice's channel driver, Alice's channel driver negotiates with Bob's channel driver via the Core, then Bob's channel driver negotiates with Bob. Given this, there are 4 control points where we can alter the behavior of the negotiation process...

* After we've received Alice's SDP offer but before the driver has sent the offer to the core. (**incoming\_offer**)
* After the core has sent the offer to Bob's channel but before we've sent an SDP offer to Bob.  (**outgoing\_offer**)
* After we've received Bob's SDP answer but before we've sent it to the core. (**incoming\_answer**)
* After the core has sent the answer to Alice's channel but before we've sent an SDP answer to Alice. (**outgoing\_answer**)

In all of those cases, we have 2 topologies we can bounce against each other,   a "pending" one and a "configured" one, and there multiple selection and filtering operations we can perform on them. The result is a "**resolved**" topology.  The resolution process is controlled by 4 parameters...

* **prefer**: Which of the stream's codec list do we prefer?  The "pending" one or the "configured" one?
	+ **incoming\_offer:** This one is pretty obvious.  "pending" is the topology created by parsing Alice's SDP offer and "configured" is the one created from Alice's endpoint allowed codecs list.
	+ **outgoing\_offer:**This one is somewhat obvious.  "pending" is the result of Alice's incoming\_offer resolution that was received from the core and "configured" is the one created from Bob's endpoint allowed codecs list.
	+ **incoming\_answer**: This one is less obvious.  "pending" is the result of parsing Bob's SDP answer and "configured" is what we ultimately sent to Bob in the offer.
	+ **outgoing\_answer**: This one is also less obvious.  "pending" is the result of Bob's incoming\_answer resolution and "configured" is the result of Alice's incoming\_offer resolution.So what does "prefer" actually mean?  Read on...
* **operation**: Now that we know which topology we prefer, what operation do we want to perform on them?
	+ **union**: We combine the codecs from both topologies by starting with the preferred list, then adding to the end the codecs in the non-preferred list that weren't already in the preferred list.  Basically, we're preserving the order of the preferred topology.
	+ **intersect**: We start with the preferred list again, but we throw out any codecs that aren't in both lists.  This keeps only common codecs while preserving the preferred list's order.
	+ **only\_preferred**: We just use the preferred list and toss the non-preferred list completely.
	+ **only\_nonpreferred**: We just use the non-preferred list and toss the preferred list completely.
* **keep**: Now that we have a filtered and sorted list, what do we keep from it?
	+ **all**: Keep them all.
	+ **first**: Only pass through the first codec in the resulting list.
* **transcode**: Finally, do we allow transcoding or not?
	+ **allow**: Allow the call to proceed even if the resulting list has no codecs in it.
	+ **prevent**: Do NOT allow the call to proceed if the resulting list has no codecs in it.

Configuration
=============

The 4 control points and their parameters are all configured on PJSIP endpoints.  The control point parameters are named...

* **codec\_prefs\_incoming\_offer**
* **codec\_prefs\_outgoing\_offer**
* **codec\_prefs\_incoming\_answer**
* **codec\_prefs\_outgoing\_answer**

The parameters are specified as **`<name>:<value>`** pairs separated by commas (whitespace is ignored).  Here's an example, including an **allow** statement,  showing the defaults for each control point...




```bash title="Codec Negotiation preference Defaults  " linenums="1"
allow = !all,g722,ulaw
codec\_prefs\_incoming\_offer = prefer: pending, operation: union, keep: all, transcode: allow
codec\_prefs\_outgoing\_offer = prefer: pending, operation: intersect, keep: all, transcode: allow
codec\_prefs\_outgoing\_offer = prefer: pending, operation: union, keep: all, transcode: allow
codec\_prefs\_outgoing\_offer = prefer: pending, operation: union, keep: all, transcode: allow

```


You'll notice that the defaults always prefer the "pending" topology so in our example, what Alice sends in her SDP offer sets the stage.

Examples
========

Really Simple
-------------

Let's start with a basic call where both Alice and Bob are configured with their default settings and both with an "allow" parameter set to "!all,ulaw,g722".

* Alice's Offer -> Asterisk -> Bob
* + Alice sends an INVITE with an SDP offer containing ulaw and g722 in that order.
	+ Alice's channel resolves that topology with her endpoint's configured codecs and incoming\_offer preferences.
	+ Alice's channel then sends the call to the core along with the resolved topology.
	+ The core invokes the dialplan which creates Bob's outgoing channel and forwards the resolved topology to it.
	+ Bob's channel now resolves the topology that came from the core (pending) with his own endpoint's configured codecs and outgoing\_offer preferences.
	+ Based on that, Bob's channel creates an outgoing INVITE with an SDP offer containing ulaw,g722 in that order.
* Bob's Answer -> Asterisk -> Alice
	+ Bob responds with an SDP answer containing only ulaw.
	+ Bob's channel resolves the incoming answer topology (pending) with the topology it sent to Bob (configured) which has ulaw,g722 and Bob's incoming\_answer preferences.  
	Since the operation is union, the resolved topology contains only ulaw.
	+ Bob's channel driver passes the resolved topology back to the core as it indicates the call being answered.
	+ The core passes the resolved topology back to Alice's channel as it tells it Bob has answered.
	+ Alice's channel resolves the topology from the core (pending), with the topology it originally sent to the core (configured) which had ulaw,g722 and Alice's outgoing\_answer preferences.  
	 Again, since the operation is union, the resolved topology contains only ulaw.
	+ Alice's channel then sends the SDP answer back to Alice with just ulaw.

In this call, Alice set the tone for the call.

A Change in the Order
---------------------

We know that both Alice's and Bob's phones can support g722 but their phones always list ulaw first.  So, how do we get them to use g722? Let's make some config changes...

* We start by changing Alice's incoming offer preferences to prefer the configured topology instead of the pending one.  
`codec_prefs_incoming_offer = prefer: configured, operation: union, keep: all, transcode: allow`
* We then set Alice's codecs to g722,ulaw  
`allow = !all,g722,ulaw`

Now let's make the call...

* Alice's Offer -> Asterisk -> Bob
	+ Alice sends an INVITE with an SDP offer containing ulaw and g722 in that order.
	+ Alice's channel resolves that topology (pending) with her endpoint's configured codecs (g722,ulaw) and incoming\_offer preferences.  
	Since we prefer configured, and the operation is union, the first stage result is now g722,ulaw.

The rest of the call flows as before except that g722,ulaw is the pending topology.  There could be one "gotcha" though.  [RFC3264](https://tools.ietf.org/html/rfc3264) states that a user agent that receives an offer **SHOULD** not change the order of the codecs when it creates its answer.  It doesn't say MUST not change the order.  So it's possible, although highly unlikely, that Bob might respond to g722,ulaw with ulaw,g722.   If this is the case, you can force Bob to use g722 setting his outgoing\_offer keep parameter to **first**.  This way we'll only send him g722.  Of course if he doesn't support g722, then  you shouldn't have configured it on his endpoint in the first place. 

Transcoding
-----------

This is where it gets tricky...

* Let's say Alice's endpoint is configured with only alaw as the codec but she sends only ulaw,g722.  If the resolved topology is empty, as it would be if the operation was union, the call is immediately terminated with a 488 Not Acceptable Here.  It doesn't matter what her transcode parameter is set to because, at this point,  we don't even know what the outgoing channel is.
* Now let's assume that Alice's endpoint had ulaw,g722.  Since her endpoint also had ulaw,g722, we sent that to the core.  Bob's endpoint however, had only alaw AND his operation was union.  This would result in an empty resolved topology.  In order for transcoding to be considered, both Alice's incoming\_offer transcode parameter and Bob's outgoing\_offer transcode parameter MUST be set to allow.   If either is "prevent", the call is terminated.  If they're both allow, we'll send an offer to Bob with alaw as the codec.
* If Bob responds with no codecs, then the call is terminated.  Again though, you probably shouldn't have configured Bob's endpoint with an unsupported codec.  Otherwise, the resolved topology (alaw) is passed back to the core.
* Alice's channel gets the topology from the core (pending) and resolves it against what it sent to the core (configured) and her endpoint's outgoing\_answer preferences.  If the resulting topology is empty, as it would be in this case, the outgoing\_answer transcode parameter is checked.  If it's allow, the channel will use the topology it originally sent to the core to construct the outgoing answer and just ignore the resolved topology.  If the transcode parameter was prevent (which was probably a misconfiguration), the call is terminated.

Behind the Scenes Implementation
================================

The old implementation had codec negotiation was scattered though chan\_pjsip, res\_pjsip\_session and res\_pjsip\_sdp\_rtp.   ACN attempts to consolidate all codec negotiation in chan\_pjsip but there are still remnants in the other modules that will need to be refactored out.  A good example is the "set\_caps" function in res\_pjsip\_sdp\_rtp.  It gets called on both incoming answers and outgoing answers but we don't actually want it to run for outgoing answers as it attempts to set the caps to what was on the original incoming offer.  That's not good.  Everything works as intended but it's useless code.  Another issue is that many of the functions in the res\_pjsip modules get reused and have no idea of the context they run in.  For instance, apply\_negotiated\_sdp runs for both incoming and outgoing answers (that's how set\_caps gets run twice).  Anyway...

* Alice Offer -> Asterisk ->Bob:
	+ **incoming\_offer**:  This gets handled in chan\_pjsip:chan\_pjsip\_incoming\_request() before the channel is actually created.   That function is called by session via the handle\_incoming\_request supplement.  The function resolves the topology created from Alice's offer with Alice's endpoint 's incoming\_offer parameters and endpoint codecs.  Assuming there active streams left in the resolved topology, the function resets the pending topology on the session to be the resolved topology and calls chan\_pjsip\_new which sets the topology on the channel along with the native format caps and read and write formats.  NOTE: We don't set the rtp instance codecs here but we should.  If the resolution fails, we terminate with a 488.
	+ Eventually we work our way through to app\_dial:dial\_exec\_full which creates Bob's outgoing channel with ast\_request\_with\_stream\_topology() passing in Alice's channel topology.
	+ **outgoing\_offer**:  ast\_request\_with\_stream\_topology() calls chan\_pjsip\_request\_with\_stream\_topology().  This then resolves the request topology (pending) with Bob's endpoint's outgoing\_offer parameters and Bob's endpoint's endpoint codecs.   Assuming there are active streams left in the topology, the function calls chan\_pjsip\_new() which sets Bob's channel topology, native format caps and read/write formats.  Same note as above, we should set the rtp instance codecs here but we don't yet.     If the resolved topology, including applying transcoding options, didn't have any active streams left, we return a cause of AST\_CAUSE\_FAILURE to app\_dial and bail which causes a 503 to be sent to Alice.
	+ dial\_exec\_full ultimately calls chan\_pjsip\_call() whose call() task calls ast\_sip\_session\_create\_invite() then ast\_sip\_session\_send)request().
* Bob Answer -> Asterisk -> Alice
	+ **incoming\_answer**:  When Bob sends a 200OK, pjproject calls our session\_inv\_on\_media\_update() callback which then calls res\_pjsip\_session:handle\_negotiated\_sdp().  That sets the active topology to that received from Bob.  Eventually pjproject signals a transaction state change based on receiving the 200 which triggers the session handle\_incoming\_response supplements, one of which is chan\_pjsip\_incoming\_response\_after\_media().  That resolves the active topology that came from Bob, with the topology we sent Bob using Bob's endpoint's incoming\_answer preferences.  The function then calls ast\_queue\_control\_data with an AST\_CONTROL\_ANSWER frame type and the resolved topology as the data.
	+ app\_dial:wait\_for\_answer() receives the ANSWER frame and places the topology into the bridge config structure.  That gets passed to features:ast\_bridge\_call() and down to pre\_bridge\_setup() which calls ast\_raw\_answer\_with\_stream\_topology().  That in turn calls chan\_pjsip\_answer\_with\_stream\_topology on Alice's channel.
	+ outgoing\_answer: chan\_pjsip\_answer\_with\_stream\_topology's answer task does the final resolution using Bob's active topology, Alice's pending topology that was originally sent to the core, and Alice's endpoint's outgoing\_answer parameters.

 

 

 

\* Direct media \* 100rel/early media \* Re-invites \* Fax \* Multi-stream \* Deferred SDP \* ARI channel operations \* Operation with other channel technologies

