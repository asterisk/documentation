---
title: PJSIP Large Messages
pageid: 29395994
---

The problem
===========

### In Asterisk

RLS support in Asterisk has the potential to generate very large messages. RFC 4662 mandates that when sending a NOTIFY due to the reception of a SUBSCRIBE request, the notification must convey the full state of the resource list. A sample NOTIFY that reports the state of 15 resources for PIDF presence (with Digium presence enabled) is 11585 bytes and looks like the following:




---

  
  


```

NOTIFY sip:sipp@127.0.0.1:5061 SIP/2.0
Via: SIP/2.0/ ;rport;branch=z9hG4bKPj76511715-2855-416d-9383-a77aa05d8fd2
From: "sut" <sip:service@127.0.0.1>;tag=d1970eb0-8526-4e54-bc2a-2caf3486b605
To: "sipp" <sip:sipp@127.0.0.1>;tag=15511SIPpTag001
Contact: <sip:127.0.0.1:5060;transport=TCP>
Call-ID: 1-15511@127.0.0.1
CSeq: 4429 NOTIFY
Event: presence
Subscription-State: active;expires=3599
Allow-Events: message-summary, presence, dialog, refer
Require: eventlist
Content-Type: multipart/related;type="application/rlmi+xml";boundary=eqjjy
Content-Length: 11012


--eqjjy
Content-ID: <lspgs@127.0.0.1>
Content-Type: application/rlmi+xml
Content-Length: 2582

<?xml version="1.0" encoding="UTF-8"?>
<list xmlns="urn:ietf:params:xml:ns:rlmi" uri="sip:blah@127.0.0.1:5060;transport=TCP" version="0" fullState="true">
 <name>blah</name>
 <resource uri="sip:200@127.0.0.1:5060;transport=TCP">
 <name>200</name>
 <instance id="sbopg" state="active" cid="zrjfo@127.0.0.1" />
 </resource>
 <resource uri="sip:201@127.0.0.1:5060;transport=TCP">
 <name>201</name>
 <instance id="wldqx" state="active" cid="dglal@127.0.0.1" />
 </resource>
 <resource uri="sip:202@127.0.0.1:5060;transport=TCP">
 <name>202</name>
 <instance id="esqqz" state="active" cid="turwl@127.0.0.1" />
 </resource>
 <resource uri="sip:203@127.0.0.1:5060;transport=TCP">
 <name>203</name>
 <instance id="yadgi" state="active" cid="helxg@127.0.0.1" />
 </resource>
 <resource uri="sip:204@127.0.0.1:5060;transport=TCP">
 <name>204</name>
 <instance id="olbnq" state="active" cid="unzlc@127.0.0.1" />
 </resource>
 <resource uri="sip:205@127.0.0.1:5060;transport=TCP">
 <name>205</name>
 <instance id="mbedq" state="active" cid="tqcdz@127.0.0.1" />
 </resource>
 <resource uri="sip:206@127.0.0.1:5060;transport=TCP">
 <name>206</name>
 <instance id="wmbco" state="active" cid="ritjc@127.0.0.1" />
 </resource>
 <resource uri="sip:207@127.0.0.1:5060;transport=TCP">
 <name>207</name>
 <instance id="hrlwa" state="active" cid="xvpsg@127.0.0.1" />
 </resource>
 <resource uri="sip:208@127.0.0.1:5060;transport=TCP">
 <name>208</name>
 <instance id="bkkwb" state="active" cid="emqle@127.0.0.1" />
 </resource>
 <resource uri="sip:209@127.0.0.1:5060;transport=TCP">
 <name>209</name>
 <instance id="sbamt" state="active" cid="lrxvt@127.0.0.1" />
 </resource>
 <resource uri="sip:210@127.0.0.1:5060;transport=TCP">
 <name>210</name>
 <instance id="etmvo" state="active" cid="lcguj@127.0.0.1" />
 </resource>
 <resource uri="sip:211@127.0.0.1:5060;transport=TCP">
 <name>211</name>
 <instance id="ugxhn" state="active" cid="eljtp@127.0.0.1" />
 </resource>
 <resource uri="sip:212@127.0.0.1:5060;transport=TCP">
 <name>212</name>
 <instance id="etpej" state="active" cid="yfjqc@127.0.0.1" />
 </resource>
 <resource uri="sip:213@127.0.0.1:5060;transport=TCP">
 <name>213</name>
 <instance id="hpnha" state="active" cid="yezdm@127.0.0.1" />
 </resource>
 <resource uri="sip:214@127.0.0.1:5060;transport=TCP">
 <name>214</name>
 <instance id="lfsgn" state="active" cid="dlqib@127.0.0.1" />
 </resource>
 <resource uri="sip:215@127.0.0.1:5060;transport=TCP">
 <name>215</name>
 <instance id="wdncz" state="active" cid="mxntz@127.0.0.1" />
 </resource>
</list>

--eqjjy
Content-ID: <zrjfo@127.0.0.1>
Content-Type: application/pidf+xml
Content-Length: 449

<?xml version="1.0" encoding="UTF-8"?>
<presence entity="sip:200@127.0.0.1:5060;transport=TCP" xmlns="urn:ietf:params:xml:ns:pidf">
 <note>Ready</note>
 <tuple id="200">
 <status>
 <basic>open</basic>
 </status>
 <contact priority="1">&quot;sipp&quot; &lt;sip:sipp@127.0.0.1&gt;</contact>
 </tuple>
 <tuple id="digium-presence">
 <status>
 <digium_presence type="away" subtype="dogs">fats</digium_presence>
 </status>
 </tuple>
</presence>

--eqjjy
Content-ID: <dglal@127.0.0.1>
Content-Type: application/pidf+xml
Content-Length: 407

<?xml version="1.0" encoding="UTF-8"?>
<presence entity="sip:201@127.0.0.1:5060;transport=TCP" xmlns="urn:ietf:params:xml:ns:pidf">
 <note>Ready</note>
 <tuple id="201">
 <status>
 <basic>open</basic>
 </status>
 <contact priority="1">&quot;sipp&quot; &lt;sip:sipp@127.0.0.1&gt;</contact>
 </tuple>
 <tuple id="digium-presence">
 <status>
 <digium_presence type />
 </status>
 </tuple>
</presence>

--eqjjy
Content-ID: <turwl@127.0.0.1>
Content-Type: application/pidf+xml
Content-Length: 415

<?xml version="1.0" encoding="UTF-8"?>
<presence entity="sip:202@127.0.0.1:5060;transport=TCP" xmlns="urn:ietf:params:xml:ns:pidf">
 <note>Unavailable</note>
 <tuple id="202">
 <status>
 <basic>closed</basic>
 </status>
 <contact priority="1">&quot;sipp&quot; &lt;sip:sipp@127.0.0.1&gt;</contact>
 </tuple>
 <tuple id="digium-presence">
 <status>
 <digium_presence type />
 </status>
 </tuple>
</presence>

--eqjjy
Content-ID: <helxg@127.0.0.1>
Content-Type: application/pidf+xml
Content-Length: 415

<?xml version="1.0" encoding="UTF-8"?>
<presence entity="sip:203@127.0.0.1:5060;transport=TCP" xmlns="urn:ietf:params:xml:ns:pidf">
 <note>Unavailable</note>
 <tuple id="203">
 <status>
 <basic>closed</basic>
 </status>
 <contact priority="1">&quot;sipp&quot; &lt;sip:sipp@127.0.0.1&gt;</contact>
 </tuple>
 <tuple id="digium-presence">
 <status>
 <digium_presence type />
 </status>
 </tuple>
</presence>

--eqjjy
Content-ID: <unzlc@127.0.0.1>
Content-Type: application/pidf+xml
Content-Length: 415

<?xml version="1.0" encoding="UTF-8"?>
<presence entity="sip:204@127.0.0.1:5060;transport=TCP" xmlns="urn:ietf:params:xml:ns:pidf">
 <note>Unavailable</note>
 <tuple id="204">
 <status>
 <basic>closed</basic>
 </status>
 <contact priority="1">&quot;sipp&quot; &lt;sip:sipp@127.0.0.1&gt;</contact>
 </tuple>
 <tuple id="digium-presence">
 <status>
 <digium_presence type />
 </status>
 </tuple>
</presence>

--eqjjy
Content-ID: <tqcdz@127.0.0.1>
Content-Type: application/pidf+xml
Content-Length: 415

<?xml version="1.0" encoding="UTF-8"?>
<presence entity="sip:205@127.0.0.1:5060;transport=TCP" xmlns="urn:ietf:params:xml:ns:pidf">
 <note>Unavailable</note>
 <tuple id="205">
 <status>
 <basic>closed</basic>
 </status>
 <contact priority="1">&quot;sipp&quot; &lt;sip:sipp@127.0.0.1&gt;</contact>
 </tuple>
 <tuple id="digium-presence">
 <status>
 <digium_presence type />
 </status>
 </tuple>
</presence>

--eqjjy
Content-ID: <ritjc@127.0.0.1>
Content-Type: application/pidf+xml
Content-Length: 415

<?xml version="1.0" encoding="UTF-8"?>
<presence entity="sip:206@127.0.0.1:5060;transport=TCP" xmlns="urn:ietf:params:xml:ns:pidf">
 <note>Unavailable</note>
 <tuple id="206">
 <status>
 <basic>closed</basic>
 </status>
 <contact priority="1">&quot;sipp&quot; &lt;sip:sipp@127.0.0.1&gt;</contact>
 </tuple>
 <tuple id="digium-presence">
 <status>
 <digium_presence type />
 </status>
 </tuple>
</presence>

--eqjjy
Content-ID: <xvpsg@127.0.0.1>
Content-Type: application/pidf+xml
Content-Length: 415

<?xml version="1.0" encoding="UTF-8"?>
<presence entity="sip:207@127.0.0.1:5060;transport=TCP" xmlns="urn:ietf:params:xml:ns:pidf">
 <note>Unavailable</note>
 <tuple id="207">
 <status>
 <basic>closed</basic>
 </status>
 <contact priority="1">&quot;sipp&quot; &lt;sip:sipp@127.0.0.1&gt;</contact>
 </tuple>
 <tuple id="digium-presence">
 <status>
 <digium_presence type />
 </status>
 </tuple>
</presence>

--eqjjy
Content-ID: <emqle@127.0.0.1>
Content-Type: application/pidf+xml
Content-Length: 415

<?xml version="1.0" encoding="UTF-8"?>
<presence entity="sip:208@127.0.0.1:5060;transport=TCP" xmlns="urn:ietf:params:xml:ns:pidf">
 <note>Unavailable</note>
 <tuple id="208">
 <status>
 <basic>closed</basic>
 </status>
 <contact priority="1">&quot;sipp&quot; &lt;sip:sipp@127.0.0.1&gt;</contact>
 </tuple>
 <tuple id="digium-presence">
 <status>
 <digium_presence type />
 </status>
 </tuple>
</presence>

--eqjjy
Content-ID: <lrxvt@127.0.0.1>
Content-Type: application/pidf+xml
Content-Length: 415

<?xml version="1.0" encoding="UTF-8"?>
<presence entity="sip:209@127.0.0.1:5060;transport=TCP" xmlns="urn:ietf:params:xml:ns:pidf">
 <note>Unavailable</note>
 <tuple id="209">
 <status>
 <basic>closed</basic>
 </status>
 <contact priority="1">&quot;sipp&quot; &lt;sip:sipp@127.0.0.1&gt;</contact>
 </tuple>
 <tuple id="digium-presence">
 <status>
 <digium_presence type />
 </status>
 </tuple>
</presence>

--eqjjy
Content-ID: <lcguj@127.0.0.1>
Content-Type: application/pidf+xml
Content-Length: 415

<?xml version="1.0" encoding="UTF-8"?>
<presence entity="sip:210@127.0.0.1:5060;transport=TCP" xmlns="urn:ietf:params:xml:ns:pidf">
 <note>Unavailable</note>
 <tuple id="210">
 <status>
 <basic>closed</basic>
 </status>
 <contact priority="1">&quot;sipp&quot; &lt;sip:sipp@127.0.0.1&gt;</contact>
 </tuple>
 <tuple id="digium-presence">
 <status>
 <digium_presence type />
 </status>
 </tuple>
</presence>

--eqjjy
Content-ID: <eljtp@127.0.0.1>
Content-Type: application/pidf+xml
Content-Length: 415

<?xml version="1.0" encoding="UTF-8"?>
<presence entity="sip:211@127.0.0.1:5060;transport=TCP" xmlns="urn:ietf:params:xml:ns:pidf">
 <note>Unavailable</note>
 <tuple id="211">
 <status>
 <basic>closed</basic>
 </status>
 <contact priority="1">&quot;sipp&quot; &lt;sip:sipp@127.0.0.1&gt;</contact>
 </tuple>
 <tuple id="digium-presence">
 <status>
 <digium_presence type />
 </status>
 </tuple>
</presence>

--eqjjy
Content-ID: <yfjqc@127.0.0.1>
Content-Type: application/pidf+xml
Content-Length: 415

<?xml version="1.0" encoding="UTF-8"?>
<presence entity="sip:212@127.0.0.1:5060;transport=TCP" xmlns="urn:ietf:params:xml:ns:pidf">
 <note>Unavailable</note>
 <tuple id="212">
 <status>
 <basic>closed</basic>
 </status>
 <contact priority="1">&quot;sipp&quot; &lt;sip:sipp@127.0.0.1&gt;</contact>
 </tuple>
 <tuple id="digium-presence">
 <status>
 <digium_presence type />
 </status>
 </tuple>
</presence>

--eqjjy
Content-ID: <yezdm@127.0.0.1>
Content-Type: application/pidf+xml
Content-Length: 415

<?xml version="1.0" encoding="UTF-8"?>
<presence entity="sip:213@127.0.0.1:5060;transport=TCP" xmlns="urn:ietf:params:xml:ns:pidf">
 <note>Unavailable</note>
 <tuple id="213">
 <status>
 <basic>closed</basic>
 </status>
 <contact priority="1">&quot;sipp&quot; &lt;sip:sipp@127.0.0.1&gt;</contact>
 </tuple>
 <tuple id="digium-presence">
 <status>
 <digium_presence type />
 </status>
 </tuple>
</presence>

--eqjjy
Content-ID: <dlqib@127.0.0.1>
Content-Type: application/pidf+xml
Content-Length: 415

<?xml version="1.0" encoding="UTF-8"?>
<presence entity="sip:214@127.0.0.1:5060;transport=TCP" xmlns="urn:ietf:params:xml:ns:pidf">
 <note>Unavailable</note>
 <tuple id="214">
 <status>
 <basic>closed</basic>
 </status>
 <contact priority="1">&quot;sipp&quot; &lt;sip:sipp@127.0.0.1&gt;</contact>
 </tuple>
 <tuple id="digium-presence">
 <status>
 <digium_presence type />
 </status>
 </tuple>
</presence>

--eqjjy
Content-ID: <mxntz@127.0.0.1>
Content-Type: application/pidf+xml
Content-Length: 415

<?xml version="1.0" encoding="UTF-8"?>
<presence entity="sip:215@127.0.0.1:5060;transport=TCP" xmlns="urn:ietf:params:xml:ns:pidf">
 <note>Unavailable</note>
 <tuple id="215">
 <status>
 <basic>closed</basic>
 </status>
 <contact priority="1">&quot;sipp&quot; &lt;sip:sipp@127.0.0.1&gt;</contact>
 </tuple>
 <tuple id="digium-presence">
 <status>
 <digium_presence type />
 </status>
 </tuple>
</presence>

--eqjjy--

```


On subsequent NOTIFYs that are caused by a single resource's state change, a partial state notification can be sent that is much smaller. 

### In PJSIP

When working with PJSIP, we manipulate a structure called `pjsip_tx_data` which contains data relating to the request or response that we intend to send. When the time comes to send the request, we use a high-level method to send a request within the subscription's dialog. Several layers down, PJSIP calls a (public) function called `pjsip_tx_data_encode()` which takes the `pjsip_tx_data` structure and creates a SIP request/response based on its data. This function allocates a buffer on the `pjsip_tx_data` that is sized at `PJSIP_MAX_PKT_LEN`, a constant that is defined at PJSIP's compilation time. By default, `PJSIP_MAX_PKT_LEN` is 4000, but it can be overridden by defining a different value in pjlib/include/pj/config_site.h. After allocating the buffer, the `pjsip_msg_print()` is used to attempt to write the request/response to the buffer. If the buffer is too small, then the encoding operation fails, causing the higher-level operation of sending the request/response to fail as well. As can be seen based on the NOTIFY above, 11585 > 4000, so we are unable to send a full state RLS NOTIFY.

Possible Solutions
==================

### In PJSIP

##### Make `PJSIP_MAX_PKT_LEN` a default value for an option that can be set/altered at runtime

Having `PJSIP_MAX_PKT_LEN` as a compile-time option doesn't really make a whole lot of sense, to be quite honest. It would be much more useful if `PJSIP_MAX_PKT_LEN` were to be redefined as `PJSIP_DEFAULT_PKT_LEN`, but allowing the default and maximum packet lengths to be configurable per `pjsip_tx_data` structure.

Analysis:

This option is the least invasive option for PJSIP. Even though it involves a change to PJSIP, the majority of the work is actually left to Asterisk to perform. This option is backwards-compatible with the current behavior of PJSIP as well, so we don't have to worry about breaking others with this idea.

This opens Asterisk up to do some interesting things as well: 

1. Asterisk could perform its own backoff algorithm to determine the necessary size for the message buffer.
2. Asterisk could cache the required size of the message buffer on the subscription structure so that subsequent notifications will likely not require multiple attempts to reach the correct size.
3. Asterisk could use a smaller default than 4000 for non-RLS message types and others that are typically much smaller than 4000 bytes.

The downside to this method is that while it is possible, it becomes difficult (though not impossible) to try to use different allocation strategies for different transports.

##### Use a backoff allocation algorithm in `pjsip_tx_data_encode()`

Currently, `pjsip_tx_data_encode()` performs a single allocation of `PJSIP_MAX_PKT_LEN` bytes, attempts to write to that buffer, and fails if the message is too long to fit in the buffer. A more lenient algorithm would be one where it first attempts to allocate a reasonably-sized buffer, then if that buffer is too small for the message, re-attempt with double the buffer size. Rinse and repeat until some ultimate maximum (possibly 65535 since that is the [maximum UDP packet size RFC 3261 specifies](http://tools.ietf.org/html/rfc3261#section-18.1.1)).

Analysis:

This places the burden of an allocation algorithm onto `pjsip_tx_data_encode()`, which means that the algorithm likely falls into a "try to please all and end up pleasing no one" category. Unlike in the first proposed fix, it is difficult for an appropriate message size to be cached across similar operations since the allocation happens at such a low level. In addition, since a single algorithm has to play nicely with all transport types, it means that everyone is forced to follow the rules of the least flexible transport. This means that all transports are limited to the maximum packet size of a UDP SIP packet.

Overall, I think this would be easy to implement, but it would be lacking compared to the first proposed fix in its ability to be flexible and satisfy anyone's needs.

##### Ignore `PJSIP_MAX_PKT_LEN` for streaming protocols

As mentioned in the previous section, RFC 3261 specifies that the maximum packet size for UDP is 65535 bytes. However, no such upper limit is mandated for streaming protocols such as TCP. A solution to this issue may be to use a different buffer allocation strategy for each transport. Transports could provide a callback to encode the `pjsip_tx_data` rather than having a single universal algorithm to do it. This way, the transports that have RFC-mandated limits on packet size can enforce them, while other transports can grow as needed to accommodate the message.

Analysis:

This does a better job of overcoming the inflexibility of the second proposed solution, but it also lacks the ability to cache proper allocation size. This proposal requires the most extensive changes to PJSIP, making it the least attractive of the proposed changes to PJSIP.

### In Asterisk

##### Change RLS full state notifications to not include resource instances

While RFC 4662 states that full state notifications must be sent when sending a NOTIFY in response to a SUBSCRIBE, it is somewhat ambiguous about whether a full state notification actually has to have instance data for each of the resources. Evidence on the sip-implementors mailing list suggests that it has been advised of people to send only the names and URIs of resources when sending a full state notification and then sending the actual instances of the resources in subsequent partial state notifications.

Analysis:

This is difficult. Like, really difficult. For lists that contain leaf resources, this actually isn't so bad. We can send a full state notification that lists the resources. Then we can send partial state notifications with 3-4 resources at a time afterward. It wouldn't be super easy to do, but it also wouldn't be super difficult. For lists that contain sublists, this becomes much more cumbersome to get correct, and for lists that contain a mix of sublists and leaf resources, it becomes difficulter still.

In addition, we have to be prepared to resize bodies in case sending a partial state notification with 3-4 resources still goes past the maximum packet size. We also have to face the fact that someone could have some monster list could exceed the max packet size with a full state notification that doesn't have instances of resources included. We also would have to rewrite a bunch of testsuite tests to change expectations of what is included in NOTIFYs and how many NOTIFYs will be sent by Asterisk.

Overall, this plan is likely to be much more difficult to enact than any of the proposed changes to PJSIP, and it's still not even 100% foolproof. This is likely to cause many tears during the attempt to get it to work properly.

##### Perform some hackery so that Asterisk provides its own definition of `pjsip_tx_data_encode()`

Since we're dealing with software here and the real problem lies with the function `pjsip_tx_data_encode()` it may be possible to have Asterisk jack into the PJSIP library binary in such a way that it redirects calls to `pjsip_tx_data_encode()` into a function call of its own, thus overriding the behavior with one of the ideas listed in the "In PJSIP" section above.

Analysis:

Honestly, I included this idea for comic effect. If I actually did this, I should be fired from Digium and blacklisted from any professional programming jobs from here on.

##### Forego PJSIP's high-level functions for sending messages in favor of some home-brewed code

There's nothing saying we have to use the high level functions PJSIP gives us if they give us trouble. PJSIP exposes lots of low-level stuff that we can use to our advantage to send requests out instead. This way, we can get around some of the built-in behavior that happens.

Analysis:

This is a terrible idea because PJSIP takes care of just **so** much under the hood for us, and trying to re-implement everything just because of one small problem with packet size is like trying to rebuild your house from scratch because one of your closets is a little too small. We're not doing this.

### In Distros

##### Suggest that distributions define `PJSIP_MAX_PKT_LEN` to be higher than the current default

Pretty much what it says on the tin. We could find the maintainers of the PJSIP packages for major distributions and request that they set `PJSIP_MAX_PKT_LEN` to a higher value than the default when creating their packages. For those Asterisk users that compile PJSIP from source themselves, we can provide them with instructions on how to change `PJSIP_MAX_PKT_LEN` themselves before compiling PJSIP.

Analysis:

Yeah, good luck with that.

### In the SIP protocol

##### Devise a "chunked" transfer encoding method for SIP similar to HTTP 1.1

I'm not even going to bother writing this one out.

Conclusion
==========

My suggestion is to move forward with the first idea from the "In PJSIP" section. This is minimally invasive to PJSIP, and I suspect that the Teluu would be more willing to accept such a change over the other proposed changes to PJSIP. It also gives Asterisk and other users of PJSIP lots of flexibility to react to errors due to large messages. The other ideas from the "In PJSIP" section would be better than any of the other ideas on this page. After that, the top idea from the "In Asterisk" section would be the next best idea, but it ranks **way** below any of the "In PJSIP" ideas. After that, none of the other ideas are actually workable, but I felt the need to list them simply because they exist as possibilities.

 

Edit September 4, 2014
======================

I actually have devised a new strategy that requires no PJSIP change and that I have borne out in tests to work properly. I figured out that I can pre-allocate the `pjsip_tx_data` buffer to be whatever size I want, thereby bypassing the restriction of `PJSIP_MAX_PKT_LEN`. What I can do is to perform a backoff algorithm of memory allocations and once I have a suitably-sized buffer, I set the `pjsip_tx_data` to use that buffer. In experiments, I have found that I can send very large PJSIP messages with no issue, and with no changes to PJSIP. I now have revised my recommendation to go with this method, as it requires no PJSIP changes, and isn't nearly as ugly as the rest of the Asterisk-only changes.

