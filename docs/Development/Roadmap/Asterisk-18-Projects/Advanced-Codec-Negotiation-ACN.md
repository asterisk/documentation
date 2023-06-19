---
title: Advanced Codec Negotiation (ACN)
pageid: 44369519
---

This is an Asterisk 18 proposal for the refactor of end-to-end codec negotiation.
---------------------------------------------------------------------------------

### Here's a link to the latest information on ACN:

[AstriDevCon 2020 Advanced Codec Negotiation Presentation](AstriDevCon-2020-Advanced-Codec-Negotiation.pdf)

 

Within a basic call scenario using Asterisk, where Alice calls Bob, and Bob answers, there are at least four distinct points in the process where it is advantageous to allow user control over the preferred codec order and selection:

1. After receiving an incoming offer
2. Before sending an outgoing offer
3. After receiving an outgoing offer's answer
4. Before sending an answer to an incoming offer

At each position Asterisk creates a joint list of codecs for use. A joint list being the intersection of a given "remote", and "local" set of codecs ordered by a preference defined using a configuration option. A "local" set is a list of codecs intrinsic at, not given to, a particular point. "local" lists are instantiated either from configuration definitions (i.e. *allow=*), or from the in-memory joint list created during one of the earlier stages. Here is a basic diagram of Alice calling Bob that illustrates where those control points exist in the call process:

In order to allow user control of codec order at those positions Asterisk defines the following PJSIP endpoint options:

![](Alice-calls-Bob.png)

1.***incoming\_call\_offer\_pref***

After receiving an incoming offer create a list of preferred codecs between those received in the SDP offered by Alice, and Alice's endpoint configuration. This list will consist of only those codecs found in both.

Allowed values:

local - Order by Alice's endpoint configuration *allow* line (default)

local\_single - Order by Alice's endpoint configuration *allow* line, but the list will only contain the first, or 'top' item

remote - Order by what is received in the SDP offered by Alice

remote\_single - Order by what is received in the SDP offered by Alice, but the list will only contain the first, or 'top' item

2.***outgoing\_call\_offer\_pref***

Before sending an outgoing offer create a list of preferred codecs to be sent. This list will consist of codecs specified by Bob's endpoint configuration, but may be ordered, or limited by an optional "remote" list of codecs given by a "caller" (e.g. Alice's joint list of codecs created after receiving an offer).

Allowed values:

local - Order by, and include all codecs specified by Bob's endpoint configuration *allow* line

local\_limit - Order by Bob's endpoint configuration *allow* line, but the list will only contain those items found in both Bob's configuration, and any optionally given by the remote

local\_single - Order by Bob's endpoint configuration *allow* line, but the list will only contain the first, or 'top' item

remote - Order by what is optionally given by a "caller". Note, the resulting list will contain those codecs specified by Bob's configuration, which are not found also in the given remote list, as least preferred. Meaning they will be at the end, or bottom of the list (default)

remote\_limit - Order by what is optionally given by a "caller", but the list will only contain those items found in both Bob's configuration, and those optionally given by the remote.

remote\_single - Order by what is optionally given by a "caller", but the list will only contain the first, or 'top' item

3.***outgoing\_call\_answer\_pref***

After receiving an outgoing offer's answer create a list of codecs between those received in the SDP answer from Bob, and the joint list previously used when sending the offer.

Allowed values:

local - Order by the list used for the previously sent offer (default)

local\_single - Order by the list used for the previously sent offer, but the list will only contain the first, or 'top' item

remote - Order by what is received in the SDP answer from Bob.

remote\_single - Order by what is received in the SDP answer from Bob, but the list will only contain the first, or 'top' item

4.***incoming\_call\_answer\_pref***

Before sending an answer to an incoming offer create a list of codecs to be sent to Alice. This list will consist of codecs from the joint list originally created after receiving the initial offer, but may be ordered, or limited by an optional "remote" list of codecs given by a "callee" (e.g. Bob's joint list of codecs created after receiving his answer).

Allowed values:

local - Order by, and include all codecs specified by the list of codecs created after receiving the initial offer from Alice (default)

local\_limit - Order by the list of codecs created after receiving the initial offer from Alice, but the list will only contain those items found in both the local list, and any optionally given by the remote

local\_single - Order by the list of codecs created after receiving the initial offer from Alice, but the list will only contain the first, or 'top' item.

remote - Order by what is optionally given by a "callee". Note, the resulting list will contain those codecs specified by the local list, which are not found also in the given remote list, as least preferred. Meaning they will be at the end, or bottom of the list

remote\_limit - Order by what is optionally given by a "callee", but list will contain only those items found in both the local list, and those optionally given by the remote

remote\_single - Order by what is optionally given by a "callee", but the list will only contain the first, or 'top' item

Note that, which options are specified at each step not only affects the codec preference order at that step, but also potentially influences the order of subsequent steps. As well, there are also other options that work in conjunction with the above that may further limit codec choice, and transcoding as well as cause Asterisk to potentially renegotiate with an endpoint. These options are:

***preferred\_codec\_only***

Offer or respond with the single most preferred codec instead of sending the list of all joint codecs. This limits the codec choice to exactly what is preferred. Enabling this option may increase the likelihood of transcoding, renegotiation, or both. This option currently exists, and while it is essentially replaced by the options above it should be kept and maintained for backward compatibility. Also if this option is specified then *incoming\_call\_offer\_pref* is not allowed to be, and vice versa.

Allowed values: yes or no (default)

***asymmetric\_rtp\_codec***

Allow the sending and receiving codec to differ, and not be automatically matched.

Allowed values: yes or no (default)

***transcode***

Specify whether or not an endpoint allows transcoding when participating in a call. If so in what capacity.

Allowed values:

yes - Allow transcoding based on default "call" setup (default).

no - Never allow transcoding. Setting this could cause some calls to not get setup.

always - Always transcode even if both sides negotiate the same codec(s).

avoid - Allow transcoding, but try to avoid it unless there is no alternative. This is done during the initial negotiation process where the most preferred codec that is the same between endpoints is chosen.

renegotiate - Attempt to renegotiate endpoints in order to avoid transcoding. However, transcode if necessary.

Dialplan
========

Each of the new negotiation options will also have an associated Asterisk dialplan function that will allow for overriding of those list within the dialplan:

1. PJSIP\_INCOMING\_CALL\_OFFER - Dialplan function to set, and override the incoming negotiated codecs
2. PJSIP\_OUTGOING\_CALL\_OFFER  - Dialplan function to set, and override the outgoing negotiated codecs
3. PJSIP\_OUTGOING\_CALL\_ANSWER  - Dialplan function to set, and override the received negotiated codecs
4. PJSIP\_INCOMING\_CALL\_ANSWER  - Dialplan function to set, and override the codecs sent in an answer

While technically these functions could be set prior to dialing, it would be ideal to implement interception routines to facilitate setting these values at the appropriate points. As well a read only variable will be added that someone can use to get the list of codecs given by the remote device/phone:

PJSIP\_MEDIA\_REMOTE - read only variable that contains the list of codecs given to Asterisk by the remote device (from an offer or answer).

Scenarios
=========

Now that there is an understanding of what each option does, and how they are suppose to work it should be possible to enumerate every joint list at a given point, and the final expected state of Asterisk for a specified configuration. The following will be used for the basic codec configuration across all scenarios:

Alice

* + Device supported, and preferred codec list order: ***g726, g722, alaw, ulaw***
	+ Asterisk endpoint configuration supported, and preferred codec list order: ***g722, ulaw, alaw***

Bob

* Device supported, and preferred codec list order: **u*law, alaw, g726***
* Asterisk endpoint configuration supported, and preferred codec list order: ***alaw, ulaw, ***opus, g722******

Here's an example sequence using "local" configuration values:

![](Negotiation.png)

 

As you can see at point **1.** the list of codecs is the intersection of those codecs given by Alice's phone, and those specified in her configuration. The list is ordered by Alice's configuration because *local* was specified for the *incoming\_call\_offer\_pref*, and here "local" means use Alice's configuration. This list is then passed across the bridge to be used as the "remote" list in the outgoing offer to Bob. However, Bob's *outgoing\_call\_offer\_pref* is also set to *local*. Again in this instance it means order the resulting list that will be used in the outgoing offer by Bob's configuration. So to get the list at point **2.** Asterisk uses those codecs from his configuration, and orders it by that configuration. The list at point **2.** is then sent to Bob's phone.

Bob's phone will then take that list, and compare it to its supported list of codecs. In most, if not all, cases Bob's phone will probably either return an intersection between it's supported codecs, and the list of codecs given to it in the offer ordered by what was offered, or it'll return the single most preferred codec from the offer that it supports. However, for the above example Bob's phone responds with a list of codecs containing the intersection between the device supported codecs, and the offered ones, ordered by the phone's preference.

Now, position **3.'s** list is the intersection of those codecs given by Bob's phone, and those used in the original offer to Bob (i.e. the list from position **2.**). Bob's configuration specifies *outgoing\_call\_answer\_pref=local*, so this means to order by the "local" list (again the list from position **2.**). This list is passed back across the bridge to be used when forming an answer to Alice. Alice has specified to use the "local" codec list for preference ordering. The "local" list in this case is the codec list created in position **1.** So, the list at position **4.** contains the codecs from and ordered by **1.** This list is then sent to Alice.

Below is a list of tables (click to expand) containing the various combinations of "joint" lists for a given configuration at the specified points. Each spot in a numbered column will contain the option value used, and the resulting "joint" list that is created between a given local and remote list at that position.

 

A. incoming\_sdp\_receive\_prefs=local

| 1. Alice's incoming\_call\_offer\_pref | 2. Bob's outgoing\_call\_offer\_pref | 3. Bob's outgoing\_call\_answer\_pref | 4. Alice's incoming\_call\_answer\_pref |
| --- | --- | --- | --- |
| localg722, ulaw, alaw  | localalaw, ulaw, opus, g722 | localalaw, ulaw | localg722, ulaw, alaw |
| local\_limitulaw, alaw |
| local\_singleg722 |
| remotealaw, ulaw, g722 |
| remote\_limitalaw, ulaw |
| remote\_singlealaw |
| local\_singlealaw | localg722, ulaw, alaw |
| local\_limitalaw |
| local\_singleg722 |
| remotealaw, g722, ulaw |
| remote\_limitalaw |
| remote\_singlealaw |
| remoteulaw, alaw | localg722, ulaw, alaw |
| local\_limitulaw, alaw |
| local\_singleg722 |
| remoteulaw, alaw, g722 |
| remote\_limitulaw, alaw |
| remote\_singleulaw |
| remote\_singleulaw | localg722, ulaw, alaw |
| local\_limitulaw |
| local\_singleg722 |
| remoteulaw, g722, alaw |
| remote\_limitulaw |
| remote\_singleulaw |
| local\_limitalaw, ulaw, g722 | localalaw, ulaw | localg722, ulaw, alaw |
| local\_limitulaw, alaw |
| local\_singleg722 |
| remotealaw, ulaw, g722 |
| remote\_limitalaw, ulaw |
| remote\_singlealaw |
| local\_singlealaw | localg722, ulaw, alaw |
| local\_limitalaw |
| local\_singleg722 |
| remotealaw, g722, ulaw |
| remote\_limitalaw |
| remote\_singlealaw |
| remoteulaw, alaw | localg722, ulaw, alaw |
| local\_limitulaw, alaw |
| local\_singleg722 |
| remoteulaw, alaw, g722 |
| remote\_limitulaw, alaw |
| remote\_singleulaw |
| remote\_singleulaw | localg722, ulaw, alaw |
| local\_limitulaw |
| local\_singleg722 |
| remoteulaw, g722, alaw |
| remote\_limitulaw |
| remote\_singleulaw |
| local\_singlealaw | localalaw | localg722, ulaw, alaw |
| local\_limitalaw |
| local\_singleg722 |
| remotealaw, g722, ulaw |
| remote\_limitalaw |
| remote\_singlealaw |
| local\_singlealaw | localg722, ulaw, alaw |
| local\_limitalaw |
| local\_singleg722 |
| remotealaw, g722, ulaw |
| remote\_limitalaw |
| remote\_singlealaw |
| remotealaw | localg722, ulaw, alaw |
| local\_limitalaw |
| local\_singleg722 |
| remotealaw, g722, ulaw |
| remote\_limitalaw |
| remote\_singlealaw |
| remote\_singlealaw | localg722, ulaw, alaw |
| local\_limitalaw |
| local\_singleg722 |
| remotealaw, g722, ulaw |
| remote\_limitalaw |
| remote\_singlealaw |
| remoteg722, ulaw, alaw, opus | localulaw, alaw | localg722, ulaw, alaw |
| local\_limitulaw, alaw |
| local\_singleg722 |
| remoteulaw, alaw, g722 |
| remote\_limitulaw, alaw |
| remote\_singleulaw |
| local\_singleulaw | localg722, ulaw, alaw |
| local\_limitulaw |
| local\_singleg722 |
| remoteulaw, g722, alaw |
| remote\_limitulaw |
| remote\_singleulaw |
| remoteulaw, alaw | localg722, ulaw, alaw |
| local\_limitulaw, alaw |
| local\_singleg722 |
| remoteulaw, alaw, g722 |
| remote\_limitulaw, alaw |
| remote\_singleulaw |
| remote\_singleulaw | localg722, ulaw, alaw |
| local\_limitulaw |
| local\_singleg722 |
| remoteulaw, alaw, g722 |
| remote\_limitulaw |
| remote\_singleulaw |
| remote\_limitg722, ulaw, alaw | localulaw, alaw | localg722, ulaw, alaw |
| local\_limitulaw, alaw |
| local\_singleg722 |
| remoteulaw, alaw, g722 |
| remote\_limitulaw, alaw |
| remote\_singleulaw |
| local\_singleulaw | localg722, ulaw, alaw |
| local\_limitulaw |
| local\_singleg722 |
| remoteulaw, g722, alaw |
| remote\_limitulaw |
| remote\_singleulaw |
| remoteulaw, alaw | localg722, ulaw, alaw |
| local\_limitulaw, alaw |
| local\_singleg722 |
| remoteulaw, alaw, g722 |
| remote\_limitulaw, alaw |
| remote\_singleulaw |
| remote\_singleulaw | localg722, ulaw, alaw |
| local\_limitulaw |
| local\_singleg722 |
| remoteulaw, g722, alaw |
| remote\_limitulaw |
| remote\_singleulaw |
| remote\_singleg722 | local488 | local488 |
| local\_limit488 |
| local\_single488 |
| remote488 |
| remote\_limit488 |
| remote\_single488 |
| local\_single488 | local488 |
| local\_limit488 |
| local\_single488 |
| remote488 |
| remote\_limit488 |
| remote\_single488 |
| remote488 | local488 |
| local\_limit488 |
| local\_single488 |
| remote488 |
| remote\_limit488 |
| remote\_single488 |
| remote\_single488 | local488 |
| local\_limit488 |
| local\_single488 |
| remote488 |
| remote\_limit488 |
| remote\_single488 |

B. incoming\_sdp\_receive\_prefs=remote

| 1. Alice's incoming\_call\_offer\_pref | 2. Bob's outgoing\_call\_offer\_pref | 3. Bob's outgoing\_call\_answer\_pref | 4. Alice's incoming\_call\_answer\_pref |
| --- | --- | --- | --- |
| remoteg722, alaw, ulaw | localalaw, ulaw, opus, g722 | localalaw, ulaw | localg722, alaw, ulaw |
| local\_limitalaw, ulaw |
| local\_singleg722 |
| remotealaw, ulaw, g722 |
| remote\_limitalaw, ulaw |
| remote\_singlealaw |
| local\_singlealaw | localg722, alaw, ulaw |
| local\_limitalaw |
| local\_singleg722 |
| remotealaw, g722, ulaw |
| remote\_limitalaw |
| remote\_singlealaw |
| remoteulaw, alaw | localg722, alaw, ulaw |
| local\_limitalaw, ulaw |
| local\_singleg722 |
| remoteulaw, alaw, g722 |
| remote\_limitulaw, alaw |
| remote\_singleulaw |
| remote\_singleulaw | localg722, alaw, ulaw |
| local\_limitulaw |
| local\_singleg722 |
| remoteulaw, g722, alaw |
| remote\_limitulaw |
| remote\_singleulaw |
| local\_limitalaw, ulaw, g722 | localalaw, ulaw | localg722, alaw, ulaw |
| local\_limitalaw, ulaw |
| local\_singleg722 |
| remotealaw, ulaw, g722 |
| remote\_limitalaw, ulaw |
| remote\_singlealaw |
| local\_singlealaw | localg722, alaw, ulaw |
| local\_limitalaw |
| local\_singleg722 |
| remotealaw, g722, ulaw |
| remote\_limitalaw |
| remote\_singlealaw |
| remoteulaw, alaw | localg722, alaw, ulaw |
| local\_limitalaw, ulaw |
| local\_singleg722 |
| remoteulaw, alaw, g722 |
| remote\_limitulaw, alaw |
| remote\_singleulaw |
| remote\_singleulaw | localg722, alaw, ulaw |
| local\_limitulaw |
| local\_singleg722 |
| remoteulaw, g722, alaw |
| remote\_limitulaw |
| remote\_singleulaw |
| local\_singlealaw | localalaw | localg722, alaw, ulaw |
| local\_limitalaw |
| local\_singleg722 |
| remotealaw, g722, ulaw |
| remote\_limitalaw |
| remote\_singlealaw |
| local\_singlealaw | localg722, alaw, ulaw |
| local\_limitalaw |
| local\_singleg722 |
| remotealaw, g722, ulaw |
| remote\_limitalaw |
| remote\_singlealaw |
| remotealaw | localg722, alaw, ulaw |
| local\_limitalaw |
| local\_singleg722 |
| remotealaw, g722, ulaw |
| remote\_limitalaw |
| remote\_singlealaw |
| remote\_singlealaw | localg722, alaw, ulaw |
| local\_limitalaw |
| local\_singleg722 |
| remotealaw, g722, ulaw |
| remote\_limitalaw |
| remote\_singlealaw |
| remoteg722, alaw, ulaw, opus | localalaw, ulaw | localg722, alaw, ulaw |
| local\_limitalaw, ulaw |
| local\_singleg722 |
| remotealaw, ulaw, g722 |
| remote\_limitalaw, ulaw |
| remote\_singlealaw |
| local\_singlealaw | localg722, alaw, ulaw |
| local\_limitalaw |
| local\_singleg722 |
| remotealaw, g722, ulaw |
| remote\_limitalaw |
| remote\_singlealaw |
| remoteulaw, alaw | localg722, alaw, ulaw |
| local\_limitalaw, ulaw |
| local\_singleg722 |
| remoteulaw, alaw, g722 |
| remote\_limitulaw, alaw |
| remote\_singleulaw |
| remote\_singleulaw | localg722, alaw, ulaw |
| local\_limitulaw |
| local\_singleg722 |
| remoteulaw, g722, alaw |
| remote\_limitulaw |
| remote\_singleulaw |
| remote\_limitg722, alaw, ulaw | localalaw, ulaw | localg722, alaw, ulaw |
| local\_limitalaw, ulaw |
| local\_singleg722 |
| remotealaw, ulaw, g722 |
| remote\_limitalaw, ulaw |
| remote\_singlealaw |
| local\_singlealaw | localg722, alaw, ulaw |
| local\_limitalaw |
| local\_singleg722 |
| remotealaw, g722, ulaw |
| remote\_limitalaw |
| remote\_singlealaw |
| remoteulaw, alaw | localg722, alaw, ulaw |
| local\_limitalaw, ulaw |
| local\_singleg722 |
| remoteulaw, alaw, g722 |
| remote\_limitulaw, alaw |
| remote\_singleulaw |
| remote\_singleulaw | localg722, alaw, ulaw |
| local\_limitulaw |
| local\_singleg722 |
| remoteulaw, g722, alaw |
| remote\_limitulaw |
| remote\_singleulaw |
| remote\_singleg722 | local488 | local488 |
| local\_limit488 |
| local\_single488 |
| remote488 |
| remote\_limit488 |
| remote\_single488 |
| local\_single488 | local488 |
| local\_limit488 |
| local\_single488 |
| remote488 |
| remote\_limit488 |
| remote\_single488 |
| remote488 | local488 |
| local\_limit488 |
| local\_single488 |
| remote488 |
| remote\_limit488 |
| remote\_single488 |
| remote\_single488 | local488 |
| local\_limit488 |
| local\_single488 |
| remote488 |
| remote\_limit488 |
| remote\_single488 |

 

 

