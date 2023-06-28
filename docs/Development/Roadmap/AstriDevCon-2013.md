---
title: AstriDevCon 2013
pageid: 26478393
---

Overview
========

AstriDevCon 2013 took place on October 7th and 8th during [AstriCon](http://www.asterisk.org/community/astricon-user-conference) in Atlanta, GA. The event was sponsored by [Bluehost](http://www.bluehost.com/), who provided not only food for the attendees but also a fantastic blade server loaded with Asterisk Virtual Machines for plenty of hands on hacking with Asterisk 12. A huge thanks once again to Bluehost for sponsoring this event!

![](bluehost_main_logo.png)

 

This was the largest AstriDevCon to date and was spread over two days to encompass discussion of all of the changes in Asterisk 12 as well as planning for Asterisk 13. A huge thanks to everyone who participated!

 

Participants
------------



| Participant | Organization | Country |
| --- | --- | --- |
| Bryan Walters | SchmoozeCom/FreePBX | US |
| Andrew Nagy | SchmoozeCom/FreePBX | US |
| Derek Peloquin | SchmoozeCom/FreePBX | US |
| Jason Parker | SchmoozeCom/FreePBX | US |
| Philippe Lindheimer | SchmoozeCom/FreePBX | US |
| Dan Jenkins | HolidayExtras | UK |
| Matt Palmer | HolidayExtras | UK |
| Nir Simionovich | GreenFieldTech | IL |
| Klaus Darilion | IPcom | AT |
| Sean McCord | CyCore Systems | US |
| Marco Signorini | QueueMetrics/Loway | IT |
| Lorenzo Emilitri | QueueMetrics/Loway | IT |
| Alistair Cunningham | Integrics | UK |
| Steve Davies | Connection Telecom | ZA |
| Michael Walton | Far South Net | ZA |
| Jakub Klausa | SS7 Technologies | PL |
| Steve Murphy | ParseTree | US |
| Torrey Searle | VoxBone | BE |
| Nitesh Bansal | VoxBone | BE |
| Justin Fennell | Intorrent | US |
| Tzafrir Cohen | Xorcom | IL |
| Corey McFadden | Voneto | US |
| Clod Patry | TelcoBridges | CA |
| Max Schroeder | Starface | DE |
| Paul Belanger | PolyBeacon | CA |
| Corey Edwards | Endurance International Group | US |
| Jared Smith | Bluehost | US |
| Leif Madsen | ThinkingPhone Networks | US/CA |
| Ward Mundy | PBX in A Flash | US |
| Ben Klang | Mojo Lingo/Adhearsion | US |
| Luca Pradovera | Mojo Lingo/Adhearsion | IT |
| Olle Johansson | Edvina | SE |
| Antti Yrjola | AY Consulting Tmi | FI |
| Matt Riddell | VentureVoIP | NZ |
| John Lodden | Michigan Network Services | US |
| Ron Arts | Intorrent | US |
| Alan Graham | Thinking Phone Networks | US |
| Ryan Navaroli | Digium | US |
| Matt Jordan | Digium | US |
| Kevin Harwell | Digium | US |
| Jonathan Rose | Digium | US |
| Scott Griepentrog | Digium | US |
| Mark Michelson | Digium | US |
| Sean Pimental | Digium | US |
| Joshua Colp | Digium | US/CA |
| Steve Sokol | Digium | US |
| Malcolm Davenport | Digium | US |
| Mark Spencer | Digium | US |
| Russ Meyerriecks | Digium | US |
| Shaun Ruffell | Digium | US |




!!! note 
    If your name is not on this list, please let someone know in #asterisk-dev so we can add you to this list!

      
[//]: # (end-note)



Day One: Asterisk 12 Development Discussion
===========================================

Day one consisted of an in depth discussion of the features in Asterisk 12, as well as some hacking sessions with the new features in Asterisk 12. Slides used to facilitate discussion are available at the link below:

* [Asterisk 12 - In Depth.odp](Asterisk-12-In-Depth.odp)




!!! note 
    It's probably worth noting that the slides were used only to help discussion and don't contain a lot of explanation. For more information on the features discussed on those slides, please see the relevant sections under [Asterisk 12 Projects](/Asterisk-12-Projects).

      
[//]: # (end-note)



Some questions and comments that came up during the discussion:

* Was PJPROJECT removed from Asterisk 12?
	+ Yes, PJPROJECT was completely removed from Asterisk 12. The only way to use PJPROJECT is to dynamically link it using the shared object libraries.
* Does PJPROJECT have a testsuite to test for RFC compliance?
	+ Yes, PJPROJECT itself has numerous tests that check for RFC compliance, amongst many other things.
* Packaging PJPROJECT. Has anyone besides Tzafrir and Debian managed to package it while still following the distro's guidelines/rules?
	+ Jared: no. This also impacts Asterisk - RHEL may not package or distribute Asterisk due to PJPROJECT having third party libraries
		- Matt: even though we actually removed PJPROJECT from Asterisk, and RHEL distributes Asterisk 11 with it?
			* Jared: yes
	+ A discussion ensued about what it would take to package PJPROJECT. In general, the consensus was that for it to be included in the distros, the third party library folder would have to be removed
		- Note that Tzafrir already removed the folder from PJPROJECT and is distributing it with Debian without it. It should be possible for other packagers to make the same modifications.
* Are there license implications for PJSIP? PJSIP is licensed under the GPLv2, but Teluu has a dual license, similar to Digium/Asterisk. Does purchasing a commercial license of Asterisk come with a commercial license of PJSIP?
	+ **Action: Matt Jordan to provide answer**
* Implementation questions with PJSIP:
	+ Are we interfacing with lowest level of PJSIP stack?
		- Pretty much. Asterisk interfaces with the C API of PJSIP, and does not make use of PJSUA or other higher level libraries.
	+ Are we using PJMedia?
		- Asterisk does make use of PJMedia's SDP parser, but not for any actual media handling. RTP handling is still done via `res_rtp_asterisk`.
* Can we trigger MWI with ARI?
	+ ARI currently lacks the ability to raise MWI events, as well as device state. Since both of these are things that can be subscribed to, it may make sense to combine their functionality under a single resource ("blinky lights"?). This functionality is on the short list of things to do, as it would allow ARI to replace `app_voicemail`. **Action: Matt Jordan to get an issue made and a proposal out to asterisk-dev**
* Sorcery is a new data abstraction layer that works with configuration and run-time data, or potentially any arbitrary data. Can any module query an object stored in any other module?
	+ Yes, with some caveats. A module querying for an object in Sorcery must know someting about the object, i.e., it must have the definition of the struct for the object to query for it.
* Can you do a similar abstraction for DNS?
	+ Not today. This would be a rather challenging feature to add, as DNS is supported by PJSIP and not Asterisk in the new SIP stack, and Asterisk's existing DNS support is "quirky" - integrating Sorcery into either would be quite the challenge.
* Does PJSIP support SIP SRV record lookup?
	+ PJSIP has full RFC 3263 support.
* Subscriptions to the state of an AoR. Does Asterisk generate state per contact on the AoR, or per AoR?
	+ Currently Asterisk and the PJSIP stack in Asterisk will generate an aggregated state, but we could expose more detail if needed later on. In particular, however, the Asterisk core itself doesn't have a good way to manipulate multiple states behind a device, so this would require some heavy lifting in the device state/extension state core to be fully exploited.
* Can Endpoints have multiple auths or registrations?
	+ Yes. **Action: Mark Michelson to provide a wiki page or update an existing wiki page with those scenarios**
* Since registrations are no longer defined as global "objects" or lines in a `conf` file, what triggers an outbound registration?
	+ The existing configuration of a registration type section is what triggers a registration upon Asterisk entering run-time.
* How is documentation for new features handled?
	+ The Config framework requires config documentation for your new PJSIP features or for any module that uses it (or Sorcery, by extension). Failure to provide documentation will result in the module not loading. Documentation is available in the CLI, but is also dumped to the wiki.
* SDES, DTLS - are multiple ciphers supported?
	+ Asterisk supports tag lengths of 32 and 80. However, it will only offer a single cipher in an outbound INVITE request, based either on what the inbound INVITE request offered of what Asterisk is configured with.
* Qualify in PJSIP, should work with outbound proxy?
	+ Yes, outbound OPTIONS requests should respect the outbound proxy settings.
* Questions on whether or not anyone uses features that did not make it into Asterisk 12's PJSIP stack (yet):
	+ Real-Time Text :  no one in audience
	+ CCSS: no one in audience
	+ AoC:  one person
	+ SNOM ext state additions: no one in audience
* Asterisk 12 allows for new features to be added after release, subject to some constraints. See [Software Configuration Management Policies](/Development/Policies-and-Procedures/Development/Policies-and-Procedures/Software-Configuration-Management-Policies) for more information.
* Is Bridge information and other aspects of its configuration exposed through Sorcery?
	+ At this point in time, information about bridges is not exposed through Sorcery. In general, a bridge is created and configured through other interfaces, and state conveyed through events. Since this is a cached object in Stasis, there are possible ways in which its state could be conveyed out to Sorcery.
* How does bridging key into the DSP subsystem?
	+ It uses the same APIs as channels.
* Is chan_sip still supported?
	+ Yes, but its future depends on what happens with chan_pjsip in the next year. Our goal is to some day obsolete chan_sip if possible; however, we fully expect many people to continue to use chan_sip for some time.
* Is it possible to have Stasis pub/sub distributed across servers?
	+ At this time, Stasis is an internal message bus only. Distribution of state across systems is still provided by interfaces built on top of Stasis, such as res_xmpp or res_corosync. It would be possible however to extend that state across systems, but a lot of thought would have to be given on how to use channel, bridge, and endpoint state in external systems.
* Can core show channels show state of stuff after it dies?
	+ No. The cache maintaining state of dead things would be a security issue - this would result in a slow leak of memory. Today, the cache purges itself when a call hangs up (channels), or when a bridge is destroyed.
* Is it possible for external systems to use an API to inject new messages on the Stasis message bus?
	+ Stasis is an internal message bus, but you could write wrapper over stasis to expose what you want to AMI or other API.
* Anyone using chan_agent? silence (except JSmith).  





!!! info ""
    chan_agent is dead in Asterisk 12, replaced by [Asterisk 12 Application_AgentRequest](/Asterisk-12-Application_AgentRequest) and [Asterisk 12 Application_AgentLogin](/Asterisk-12-Application_AgentLogin). No one seemed to mind.

      
[//]: # (end-info)

* Anyone still using MeetMe?
	+ 3 or 4 in attendance admitted to using MeetMe.
* Is there still a need to add functionality to Queue for features like Skills-based routing?
	+ Probably not. In general, you could probably use some combination of AGI/Dialplan and agent pool. In order to effectively use Agent pools to do skills based routing without baked in logic, you'd want an interception routine that could control whether or not an agent is dialed.
	+ In general, business logic shouldn't be internal to Asterisk. Any solution for skills based routing or similar functionality should allow the user to define their logic outside of Asterisk.
* CDR discussion. In general, we all admitted that CDRs may still need a bit of work, but you should have enough information to construct what occurs during a call, including various unique IDs for CDR records for tracking or building a tree
	+ Who uses CEL to build CDR ? ~5 in attendance
* Origination of calls (AMI): is there any reason to add something to Originate that would create a bridge and connect an outbound call automatically to it?
	+ Originate uses dialplan extension or application, rather than a bridge. This still should be possible, given a bridge to drop the originated call into. Alternatively, originating to an extension could accomplish this task if a dialplan application exists that adds the channel to a bridge.
* Discussion of ARI, a new interface in Asterisk 12. ARI is not a replacement for AMI or AGI. ARI is meant as a way to replace dialplan applications with externally controlled applications - that is, "write your own app_queue"
	+ Is it possible to manipulate channel variables regardless of the state the channel is in?
	+ How about user events?
		- No, we should add that capabilities. **Action to Matt Jordan to file an issue to add this functionality**.
	+ How about logging messages back to Asterisk?
		- No, we should add that capability as well. **Action to Matt Jordan to file an issue to add this functionality.**
	+ How about various dial options, indications, and DTMF?
		- These should be added as well, but some thought should probably be given to how they are represented. **Action to Matt Jordan (or anyone, really) to have more conversation on these point on the -dev list. (Note: jcolp probably already has a patch for indications and DTMF)**
	+ How does AMI compare vs ARI
		- AMI -> controlling calls in the context of dialplan
		- ARI -> create a very targeted application, like a dialplan application. Think of ARI as a way to write VoiceMail, Queue, or ConfBridge, while AMI controls calls outside of those applications.

Day One wrapped up with hands on labs using the server provided by BlueHost and Jared Smith. A few observations from those labs:

1. PJPROJECT can still be tricky to install. The more effort we can put into getting good packages made for distros as well as making the build and install process easier, the better.
	1. Common issues: installation in lib instead of lib64, various third party conflicts, pkg-config not looking in correct location
2. ARI is neat, but having some wrapper libraries that manage the WebSocket connection would be nice

  


Day Two: Asterisk 12 Future and Asterisk 13 Discussion
======================================================

The morning consisted of further labs and hack sessions on Asterisk 12. The afternoon consisted of a discussion regarding future development in Asterisk 12, as well as features that would be destined for the next LTS release, Asterisk 13.

Agenda
------

* Policy in general/Release policy
* Expanding the ARI / rest api
* PJSIP / chan_sip45
* Media negotiation adaptive stuff magic dynamic stuff
	+ Off load media handling
* Clustering / distributed environments
	+ Distributed conferencing
* Opus
    * Kill app_queue!!!!
    * Asteri18n - mailing list exists!
    * Video!!!
    * RTP / improvements
    * Security / named ACLs mark II
    * Dynamic configuration framework / push
    * Review last year's list
    * The future of Asterisk

    Release policy
    --------------

    * Asterisk 12 release policy will be different than other releases
    	+ New features will be included after release, subject to the constraints in [Software Configuration Management Policies](/Development/Policies-and-Procedures/Development/Policies-and-Procedures/Software-Configuration-Management-Policies)
    * Release policy: do we allow new feature changes in Asterisk 13?
    	+ First, as it is with Asterisk 11, standalone modules are always okay. If they are included in a release branch, they can be disabled by default, which means existing installations are insulated from the changes. There should not be changes in core.
    	+ Do we need an approval policy for new features? For example, there are often very minor features (new device states, new AMI events, new ARI events, etc.) that would benefit the larger asterisk community, but are currently automatically rejected. These features have a very low risk of causing an issue.
    		- Jared: other projects have done this and had it be very successful
    		- **Action to Matt Jordan to look into a policy and start a discussion on asterisk-dev**
    * Should we release the next major version as 13? Should it be 14 or something else? Asterisk MineSweeper 2.0? Asterisk 8+5. Marco: Asterisk XP
    	+ The overall consensus in the room was in favor of 13. As we still have time for further discussion on this matter, we should bring it up again in a month or two on asterisk-dev.
    	+ **Action: revisit this decision in a month or two on asterisk-dev to solicit a wider opinion**

    Expanding ARI/Restful API
    -------------------------

    * Version numbering of API needs to be handled
    	+ Current is 0.0.1. David Lee is currently working on a versioning scheme.
    	+ **Action: propose a versioning scheme.** David Lee [did reply in an e-mail to the -dev list](http://lists.digium.com/pipermail/asterisk-dev/2013-October/063003.html) with a draft proposal linked here: <https://wiki.asterisk.org/wiki/x/WwCUAQ>
    * Suggestion: Client can indicate "expected version" and server will adapt WITHIN REASON
    	+ There was a long discussion about this proposal. The idea is that if an event is added and the version number incremented, then a client connecting supporting an earlier version number won't receive those events. Due to how messages on the Stasis bus are constructed for consumers, this is not out of the realm of possibility in both AMI and ARI, but careful thought would have to be applied - and expectations set on how far the scope of this can be extended.
    * Implementation notes to client developers may need to be published:
    	+ Expect new events
    	+ Use the version number of the API in combination with Asterisk version (Maybe not, but remember AMI)
    	+ Explain the need for and use of ARI as compared with AGI, AMI, ExtIVR etc
    * Feature requests for ARI
    	+ Propably thousands of features missing
    	+ Issue: How do we hand control of a channel back to the dialplan / or to specific app
    		- Currently, the channel is sent back to the dialplan, but there is not a way to send it directly to an application. This would require some careful thought, as the releasing back to the dialplan guarantees that something can still execute the channel - sending it directly to an application would almost have to guarantee that the channel is immediately destroyed when the application terminates.
    	+ Issue: Queue-related stuff missing - members, queue status,
    		- Much of this is higher level application logic that would be provided by someone implementing a replacement for app_queue
    		- Question: do we need to have a RESTful interface that replaces AMI?
    			* Answer: that would be highly desired (Jared, Dan, etc.)
    				+ Need to discuss what functionality should be carried over from AMI and put behind a REST interface; some might not make sense. **Action - have a discussion on the asterisk-dev list about replacing AMI with a REST interface**
    	+ Issue: Call states
    		- Need device state resource. **Action - have a discussion on the asterisk-dev list about this**
    	+ Issue: User events
    		- Carried over from the previous day; action already taken
    	+ Issue: Generating DTMF
    		- Carried over from the previous day; action already taken
    	+ Suggestion: Expand ARI to handle existing apps in Asterisk
    		- Can the community create open source replacements of Queue, VoiceMail, and others? If so, where should it live?
    			* Consensus seemed to rest on GitHub
    	+ How do we manage feature requests for ARI?
    		- Wiki page with feature requests / brainstorms / hot items for ARI. **Action - create said wiki page for both ARI features as well as other features requested by the community**
    	+ How do we migrate more apps to ARI?
    		- Carefully!
    	+ Issue: Issue log items for all log channels from ARI apps
    		- Carried over from previous day; action already taken
    	+ Issue: Resources on the server / files - sandbox issues
    		- In general, ARI should protect the server from malicious requests. Exposing System() application like functionality should be discouraged, due to known permission elevation issues with AMI and the dialplan.
    	+ Issue: Dial() options that are missing from ARI
    		- Play digits
    		- Ignore forwards
    		- Fake ringing
    		- Play music instead of ringing
    		
    		
    		
    		
    		---
    		
    		**Note:**  Should we have a "Dial" operation that does all of this in ARI? Discussion now ongoing on the asterisk-app-dev list: <http://lists.digium.com/pipermail/asterisk-app-dev/2013-October/000002.html>
    		
    		  
    		
    		
    		
    		---
    	+ ARI options for Digium commercial modules
    		- Matt Jordan: probably not, or at least not right away. Digium commercial modules typically only expose inspection level commands (how many licenses do I have, etc.) - ARI is more about application control. If we end up exposing a REST interface that provides system inspection, then we may want more of this in our commercial modules
    	+ Issue: A bridge between ARI and AMI
    		- That is, is there a way to integrate AMI and ARI applications easily? This may rest heavily on the client libraries developed.
    	+ SDK will be released on github - python and javascript
    		- Digium working on the initial client library implementations that are auto-generated from the resources. **Update:**Paul Belanger working on a Python implementation as well.

    CHAN_PJSIP
    -----------

    * Number one issue: Get PJSIP installed
    	+ Debian packages being built
    	+ Work with/discuss options with other package maintainers
    	+ Other than ripping out the third party library folder, what else can we do to make the installation easier?
    		- Auto-detection of third party libraries to aid configure script
    * PJSIP support of the "SIP/" prefix
    	+ Configurable switch - should we allow people to map SIP to PJSIP?
    		- Pros: easier to switch between dialplan
    		- Cons: confusion as to what you're running; chan_sip to chan_pjsip nomenclature doesn't have a one to one correlation
    	+ Not really just dialing (which has its own issues) - things like device state, out of call messaging are also affected
    * Ability to dial any SIP URI is important - YES!!!
    	+ **Action: create an issue to round out this functionality and/or provide sufficient documentation on how it should be configured**
    * SIP Outbound proxy / Predefined route set
    * AMI and CLI commands needed
    	+ CLI commands being worked by George Joseph - see <https://github.com/asterisk/asterisk/issues/jira/browse/ASTERISK-22610>
    	+ AMI commands being worked by Kevin Harwell - see <https://github.com/asterisk/asterisk/issues/jira/browse/ASTERISK-22609>
    * Integration with CHANNEL() function
    	+ **Action: create an issue for this functionality**
    * Ability to dial without entity in configuration
    	+ Set codecs and preferred codecs, DTMF mode, security properties
    	+ All of the settings for an endpoint
    	+ Question: should this really be allowed? In general, one can create an endpoint that acts as the outbound entity to dial, and send it SIP URIs and other options. Do we really need a default, or should we just tell people how to configure this?
    * Change properties of objects from API's and dialplan
    	+ This would be a function that would allow a channel to override the settings inherited from its endpoint.
    	+ **Action: discuss this on the asterisk-dev list, and identify an initial feature set for the function**
    * How much of backwards compatibility is required?
    * Focus/prism on Security
    * No Call Completion, AOC, SNOM extensions - needed in 12
    * SUBSCRIBE/notify/PUBLISH STUFF
    * How do we handle versioining of the PJPROJECT fork?
    	+ Patches are being pushed up to Teluu, but right now there is no version for PJPROJECT. Do we need a tag on the github repo so people know what to base it against in the meantime?

    Media negotiation
    -----------------

    * Steve invites to bar-bof. Media negotiation is rather complex, and how it should be handled is usually a matter of opinion based on specific scenarios and requirements. For this to go forward, there should be requirements, use cases, and other proposals first discussed on the asterisk-dev list.
    	+ Draft call scenarios
    	+ Draft requirements
    	+ Draft solutions
    * Continue discussion on mailing list

    Asteri18n - localization
    ------------------------

    Steve Murphy presenting. "gettext for saying stuff". Executive summary:

    * Change all the "SAY" routines to pluggable modules
    * The translator can not code, a solution needs to be translator-compatible
    * The logic is now in c-code which is not very translator-friendly
    * The logic needs to be included in the sound-file set
    * Proposal for a new Asterisk-independent config language called "SayScript"
    * "The fundamental unit of translation is the sentence" - context is needed
    * A language pack will have script file, language prompts, sayscript logic
    * As a conclusion: the proposal has strong merit but needs to be discussed further on the asterisk-dev list, as Tzafrir had some questions and concerns about its general approach. **Action: Steve Murphy to distribute proposal on the asterisk-dev mailing list**

    ### Opus

    * Asterisk 12 includes formats for pass-through of Opus and VP8
    * There are patches on github.com/meetecho for Codec_opus
    * mp3/ilbc
    	+ mp3: use newer implementations
    	+ ilbc: remove embedded source, use newer implementation from Google. **Action: create an issue for versions of Asterisk to look for a library and use it if available; otherwise use embedded source. Remove embedded source in trunk.**
    * licensing - Digium investigating licensing concerns with IPRs against Opus.
    	+ Current status: still working with/waiting on Xiph.
    	+ transcoding

     

    Clustering/distributed asterisk
    -------------------------------

    * No "clean way" to distribute states between asterisk servers.
    	+ Stasis is an internal message bus. Replacing it with something that supports distributed pub/sub is theoretically possible, as Stasis is an opaque implementation and does not inspect the contents of the messages distributed on it; however, this would be quite a large project
    	+ Bigger question: what are the use cases for distributing state?
    		- Full call fail over is a much larger task than just channel / channel_pvt distribution. You actually have to do something with the state once you have it.
    		- What use case is there for bridge/channel state outside of Asterisk that requires something like redis and that can't be built with AMI/ARI? Need more requirements/use cases.
    * Bar-bof Paul Belanger

    Kill app_queue - ARI apps in Asterisk
    --------------------------------------

    * There should be a replacement delivered with Asterisk, but probably initially on github
    	+ In Asterisk might just be something that pulls from github
    	+ Many folks interested in creating a Queue replacement - Paul, Dan, Leif, Jared
    * Licensing of ARI applications. **Action to Matt Jordan - clarify ARI licensing in the same fashion as AGI/AMI.**
    * How to find ARI's / Repository
    	+ Ideally, we would have something like pip or some other package manager that would allow someone to search, install ARI applications easily
    	+ Has to be language agnostic
    	+ Could just be a wrapper around language specific functions
    	+ **Action: discuss more on asterisk-dev list**

    Security
    --------

    * Fail2ban inside Asterisk
    	+ Security event framework already exists, just need to propagate security events through interfaces (currently only a log file)
    	+ Named ACLs - if these can be created and applied externally, then security events can be used to auto-ban anything coming into Asterisk
    * Security in a PRISM era
    	+ Secure audio, secure signalling
    	+ 256 key length for AES encryption
    	+ Upgrade to new LibSRTP on github (OpenSSL)
    		- Since Asterisk dynamically links with libSRTP, unclear right now what needs to be done. Possibly another point of discussion on asterisk-dev
    	+ Key lifetime, key rotation, key re-negotiation
    * Generating certificates at install time
    * Review TLS implementation; improve

    Future of Asterisk
    ------------------

    Two themes emerged from people's comments on what the future of Asterisk is:

    1. Asterisk should be a communications engine, and not provide the business logic. ARI is a step in the right direction and needs to be expanded to fully realize that.
    2. PJSIP is great, but needs to be refined before it can be a full replacement for chan_sip

    Random quotes
    =============

    "Asterisk is Asterisk"

    Obligatory Pictures
    ===================

![](astridevcon.jpg)

     

    James Body's awesome 360 panorama picture (taken from a self-rotating smart phone! We live in the future!):

![](10310580255_d4c3778f0a_o.jpg)

    Slides
    ======

[Asterisk 12 - In Depth](Asterisk-12-In-Depth.odp)

     

     

