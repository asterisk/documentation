---
title: AstriDevCon 2012
pageid: 21463921
---




Introduction
============

AstriDevCon 2012 was held on Monday, October 22nd. It was held on the day prior to AstriCon at the same location. A group of active development community members met and discussed a number of topics.

Much thanks to Jared Smith and BlueHost for sponsoring the event!

Participants
============




!!! note 
    Unfortunately, my list of developers present got eaten by the cleaning crew (through no fault of their own, that's what I get for leaving it behind in a stack of scribbled papers!) If I miss your name and/or company on here, let me know and I'll be sure to correct the list below. – Matt

      
[//]: # (end-note)



Developers/Contributors Present
-------------------------------

* David Duffett: Digium
* Rusty Newton: Digium
* Matt Jordan: Digium
* Paul Belanger: PolyBeacon
* Leif Madsen: CoreDial
* Jared Smith: BlueHost
* Nicolas Bouliane: Avencall
* Mark Murawski: Intellasoft
* Sylvain Bolly: Avencall
* Nir Simionovich: Greenfield Technologies
* Eric Klein: Greenfield Technologies
* David Faulk: Digium
* Max Schroeder: Starface
* Octavio Luna:
* Alec Davis: Black Diamond Technologies Ltd.
* Corey McFadden: Voneto
* Joshua Colp: Digium
* Shaun Ruffell: Digium
* Jason Parker: Digium
* Matthew Frederickson: Digium
* Malcolm Davenport: Digium
* Steve Sokol: Digium
* Michael Spiceland: Digium
* David Lee: Digium
* Kinsey Moore: Digium
* Mark Michelson: Digium
* Bryan Johns: Digium
* Sean McCord: Ulexus
* BJ Weschke: BTWTech
* Clod Patry: AMUG
* Tim Panton: Voxeo Labs
* James Body: Truphone

Developers Participating via #astridevcon
-----------------------------------------

* Tzafrir Cohen: Xorcom
* Ben Klang: Mojo Lingo/Adhearsion
* Ben Langfeld: Adhearsion

Agenda
======

After introductions, an agenda, consisting of topic areas and specific items, was developed and agreed upon. In order to ensure that all topics had some discussion, each of the major topics was limited to an agreed upon amount of time. The following broad areas were discussed:

* Policies (1 hour)
* Channel Drivers (2 hours)
* Core (1 hour)
* APIs (1 hour)
* Review of past work and existing work (1 hour)

Notes
=====

Please remember that these notes merely represent the items that were discussed, and, by themselves, do not constitute policies or project proposals.

Policies
--------

* Release Branches - what is an allowed patch in a release branch. Historically, we've had the policy that no new features should be allowed in release branches - should we revisit that decision? Pros and cons were discussed. The general consensus reached was that this should not be changed.
	+ We discovered that this policy was never written down in a clear, concise way. ~~**Action to take: We need to craft a written policy for no new features in Release Branches and make it available on the Asterisk wiki.**~~
		- We tried to find situations in which it might be possible to have a new feature included in a release branch. The only way it would be reasonable is if it did not, in any way, impact existing code. That would imply that the new feature would have to exist in a stand alone module, and be disabled by default.
* Git - should we moved to Git? There are a few reasons why a move to Git would be advantageous for the Asterisk project:
	1. Easier merge paths between branches (which will get more complicated with the EOL of Asterisk 10 in December)
	2. Potential process improvements that would allow verified code to be merged quicker into branches/trunk
	+ Asterisk is a large project to move to Git. It may be better to start with DAHDI (they really already use it extensively, and Subversion is a formality) or the Asterisk Test Suite (smaller project, one branch, fewer users)
	+ One of the complications of moving Asterisk to Git is menuselect. Since no other projects (we think) use menuselect at this time, we should move menuselect into Asterisk (barring any technical barriers that arise)
* Other Development Tools
	+ Review Board/Code Reviews
		- Someone asked "what allows a Ship It?" While there isn't a 'definition' for what constitutes acceptable code, there are some guidelines that reviewers should follow when performing a code review, as well as actions that submitters can take to help code receive a 'Ship It'. **Action to take: document a check-list for reviewers**. Some areas discussed included:
			* The higher the complexity, the more likely the need for automated testing or some other verification that the code is well tested. This can include several other items, that may be part of the same review or separate reviews:
				+ Unit Testing via the Asterisk Unit Test Framework
				+ Asterisk Test Suite tests
			* The code needs to satisfy requirements for merging:
				+ The code must follow the coding guidelines
				+ The code should be well documented, and - if the item is a new feature or alters existing behavior - it should have sufficient documentation. This includes:
					- New config options in the sample config
					- Doxygen comments
					- Wiki docs for usage (if a new feature)
		- In general, submitters should wait 24hr for others to review after receiving a 'Ship It'. Not everyone lives in the same time zone!
			* If, for whatever reason, the patch has some time constraint and has to be merged sooner than 24 hours later, it should receive at least 2 ship its. This may only cover a hypothetical scenario, and may not need to be part of any written guideline.
* Feature branches - may be nice to have a page on the wiki for 'team branches' of features not merged for a particular version. This will let the Asterisk Test Suite be pointed at the branch, make it known that its available, etc. **Action to take: make a space on the Asterisk wiki for the documentation of feature branches that are available**
* Testing
	+ We need to publicize (better) the tools available for use. These tools should be made for use by everyone contributing to the Asterisk project.
	+ Publicize what is tested - and at what level (unit, integration, system). Some automated mechanism that publishes the tests would be best, as that would prevent the documentation from getting out of sync with the tests. **Action taken: have the Unit Tests and Test Suite tests be documented on the Asterisk wiki**
	+ What is tested by Digium before a major release?
		- Asterisk testsuite
		- Manual tests (system level)
		- Testing is primarily core support level
		- Minimal (or none) testing of extended support level
* What do we feel would be needed at a policy level regarding a "phone home" Data Capture module?
	+ It must be "non evil", phone home
	+ It should contain no personal info
	+ It should tag a system by a unique ID, and you should know your own unique ID
	+ You should be able to query all gathered data
	+ It should be OPT OUT - easily turned off. We discussed OPT IN, but everyone agreed that OPT IN systems rarely get the kind of participation needed for them to be worthwhile.
	+ It must be well publicized, in a variety of ways:
		- It must publicize where data is sent, and allow the user to control where data is sent. Valid options could be:
			* Digium only
			* Somewhere else only (that is, if you have multiple systems, you can have it send data only to your own service)
			* Digium+somewhere else
		- You should be able to control what data is sent. Valid data that is sent could include:
			* Modules being used/versions
			* Calls processed
			* Registered endpoints
			* Technologies used
			* Uptime
		- Open data transfer message format (the message specification for what data is sent should be publicized)
		- Well documented message specification, i.e., should not require reverse engineering the module
		- A separate module should control the sending
		- CLI warning should be displayed **as the last message before the prompt** instructing the user that data is being sent, and how to turn it off.
* Project pages. All major projects should have a project page on the Asterisk wiki where people can go and learn what active projects are currently being worked on. The project pages are **not** a place for discussion, but rather a focal point for resources related to that project.
	+ This page should link to any major asterisk-dev list discussions.
	+ Announce on mailing list when a project is kicked off - provide links to wiki for more detail
	+ Page should include requirements, high level design, links to JIRA issues for tasking, links to code reviews, outstanding tasks, etc.
* Mailing list policies
	+ We currently require all mailing list discussions to be conducted only through the mailman server, i.e., you can't CC the mailing list. This can make it difficult if a particular mailing list is not one that you interact with on a constant basis. A proposal was made to not require mailing list discussions to be conducted only through mailman server.
	+ Counter-argument: the configuration would most likely need need tweaks for duplicate messages, and allowing conversations to CC a mailing list might mean that conversations fall off of the list easier (or never get put on it in the first place)
	+ **We didn't seem to come to a conclusion on this issue. If anyone feels like this needs more discussion, please start a policy discussion on the asterisk-dev list.**

Channel Drivers
---------------

* SIP Channel driver. It has issues. As of October of 2012, ~25% of the open issues in JIRA are against `chan_sip`. While that can be attributed to its usage, it can also be attributed to its design. A poll was taken of the attendees if anyone liked to maintain `chan_sip`; no one raised their hand.
	+ The current SIP channel driver has huge tracts of code (31000 in 1.8; 34000 lines in trunk (which means we aren't actively making it better))
		- The design has a lack of stack-based structuring. This makes means there is no transport layer; no transaction layer; no application layer; logic flows between all layers in the channel driver often on different code paths with little discernible logic as to why.
		- Bugfixes very often create more bugs, even with experienced Asterisk devs.
		- Unapproachable for new developers. This limits who can come in and contribute bug fixes, which is a very bad state for an open source project.
* Can we refactor the existing `chan_sip`? This was discussed a bit, but given the following, it was not an approach that received a lot of support:
	1. Many have tried, all have failed
	2. It increases the risk of the project failing - even if a new SIP channel driver were written that did not meet all objectives, the existing one would still provide functionality. If we refactor it, we lose that safety net.
* ~~**Project proposed: build a new parallel channel driver**~~
	+ What should the driver provide?
		- It must provide basic B2BUA capabilities
		- Registrar
		- Subscription
		- More (but not a proxy)? *It was noted that it does not have to provide the above capabilities either - if it is built in a modular fashion, portions (such as registrar) could be removed*
	+ Services provided should be built in separate modules for flexibility and ease of maintenance
	+ Use a GPL SIP stack - don't reinvent the wheel.
		- PJSIP, Sofia? Others? While we naturally leaned towards PJSIP, given Digium's experience with it on Asterisk SCF, this should first be discussed on the asterisk-dev list.
		- If possible, try to have someone full time on the stack library development team.
		- Pick a version of the stack for a branch of Asterisk. This will keep the stack in line with that version to prevent churn if the stack is upgraded in a release branch.
		- Testing. Will be a huge effort, as we have to guarantee interoperability as much as possible. Should develop specific test scenarios and build out tests against the current SIP channel driver and then run them against the new one.
			* Plan to do interop testing at SIPit when possible
			* ~~**Action taken: Build out a list of scenarios for SIP tests to be created in the Asterisk Test Suite to ensure that basic functionality works in a new SIP channel driver**~~
	+ Data Access Layer
		- We must support Legacy configs. Someone should be able to taken an existing `sip.conf` and use the new SIP channel driver. A new configuration schema can also be defined, and we can implement a mechanism of exporting the in-memory objects to create a new SIP config file.
	+ Need to agree upon a set of functionality to have implemented for Asterisk 12.
	+ The channel driver must provide layers of abstraction - modular in nature.
* New SCCP Channel driver
	+ SCCP being developed by Avencall team. Very interested in replacing the existing `chan_skinny`.
		- Asked to provide a team branch for Asterisk 1.8. Asterisk Test Suite can be pointed at the team branch.
		- Forward port to trunk
		- Double check feature parity with chan_skinny
		- Work with Damien Wedhorn (current maintainer of chan_skinny) to determine feature set
		- Find ways to integrate development processes with Asterisk. This includes testing, project pages, etc.
* chan_rtp - or find a way to expose creating a media stream without signalling
	+ RTP API exists and is implemented as a resource module.
	+ Expose RTP functionality without requiring signalling?
* `chan_agent`, or the future of it.
	+ Current implementation is buggy and prone to problems. Multiple folks have experienced memory corruptions with no resolution (yet).
	+ Should we get rid of it? You *technically* can do everything without it. However, its existence makes abstraction of the agent easy (doable without chan_agent, but hard).
	+ On that same note, can we replace app_queue with tiny pieces?
	+ We noted that we could have further discussion on this within APIs

Core
----

* Console logging, specifically, a defined formatting - kobaz has done some work on this and may be getting closer to being able to have it reviewed
* Scalability
	+ What is the ability to scale? What aspects does Asterisk struggle with?
		- RT
		- Should we use an API that provides federation?
		- Should we expose a UUID for an Asterisk instance from AMI or other interfaces?
			* Note: you can already expose the system name out of system.conf
		- Scalability would be helped by having multiple data storage backends for ASTDB (and not resident on the same machine)
		- Media storage as a resource
* Monolithic App breakup
	+ Queues
	+ VoiceMail
* CDRs (cannot kill with fire)
	+ Core problem with CDRs: what is a call? How do you define a call when there are multiple endpoints involved in a call? Currently, Asterisk does not defined this behavior and this makes CDRs in transfers (and other situations) difficult. CEL helps, but requires consumers to developer their own notion, which is a lot of work. One thing that came up here was the idea that a channel should have a UUID that survives masquerades; this at least would make the entire channel lifetime known. Deferred to API discussion, as modifying CDR behavior needs to reflect core changes.

APIs
----

* Manager
	+ Several known problems:
		- Tracking calls in transfer scenarios (or really, any masquerade - parking, etc.)
			* Calls boils down to channel tracking - Asterisk would have a difficult time defining a 'call'.
			* Need a UUID per channel that survives the masquerade process.
		- It was brought up that there is no specification for AMI (documenting actions/events is nice, but doesn't cover order of events or when events can occur). However, it was asked whether or not it is worth specifying a broken protocol or implementing a specified, consistent protocol with other proven implementations, which provides additional features (multi-tennancy, real security, federation, load balancing)? One example of this would be [RAYO](http://rayo.org/xep)
			* At the same time, is AMI deficient, or broken? If it is broken, is that a fault with AMI, or a fault with the core of Asterisk not providing consistent and predicable state to build an interface on top of? Even if we build out a new interface, the core problems will have to be resolved.
		- Events lack documentation (Asterisk 11 has added them, but they aren't complete yet)
			* One idea: register events. Make it so unregistered events never get sent out (configuration item)
				+ Prevent unregistered events from going out, log error
			* Add Accurate timestamping to events to reorder them or to build a transaction model on the client side
			* Add "Meta events" that can combine multiple events
			* Efficiency. Asterisk sends a lot of AMI events that you might not care about, and we only have coarse granularity to turn them off. A publish/subscribe model would alleviate a lot of this (interesting note: Dan Jenkins of Holiday Extras during his talk at AstriCon noted that they ran into performance problems with AMI, and ended up opening 6 simultaneous connections with various classes disabled, and then built a model of the system on top of that. That's awesome, but quite the workaround that shouldn't be necessary)
			* Documentation - more the better.
			* Channel lifetime needs to be known by anyone who builds a system on top of AMI. Again, this points back to masquerades.
* AsyncAGI
	+ No ability to rescue a channel dumped into AsyncAGI without a response.
	+ Global scope, races if multiple AMI users are listening to AsyncAGI. May need a way to tie a channel dumped into AsyncAGI with a specific AMI instance.
* Asynchronous media control. Not easily possible, as redirect actions sent to a channel in AsyncAGI can be 'buggy'. Should be able to pause, resume, stop, rewind, and otherwise have fine grained control over media being played to a channel.
	+ External Message Bus
		- Could be multi-cast
* Consistency of APIs. This is fairly poor, as there are lots of things you can't do in AMI that you can in dialplan, or things that you can't do in AGI that you can do in dialplan. Things that are available in one place should be available in all places, if it makes sense to do so. Certain operations (such as Originate) end up being implemented in multiple locations as well, when there should merely be ways of initiating a single operation.
	+ This discussion brought up breaking up coarse granular operations into finer grained operations. This included:
		- Bridge as an object to be manipulated.
		- Lightweight Dial (that is, something that only dials and does not bridge).
		- Break up Queues; VoiceMail. What functionality is really needed for these if you have fine grained control over bridging and dialing? More research needs to be done into what exactly **must** be provided by Asterisk. "Business logic" in both cases should not be hard coded.
* MSRP support. No current actions taken.
* Compliance/Regression tests with API consumers (such as Adhearsion) - this would be great to have automated in the Test Suite.
* SLA - Need to explore SLA using ConfBridge. This would remove the last set of functionality dependent on MeetMe/DAHDI.

Review
------

We discussed prior proposed projects, what was done for Asterisk 11, and what might make sense in Asterisk 12. The listing below is pulled from the AstriDevCon 2011 Projects; items committed are crossed out.




!!! note 
    If someone feels that some aspect of a project that was committed was not fully finished in Asterisk 11, please let me know and I'll make a note on the project. – Matt

      
[//]: # (end-note)



### [AstriDevCon 2011 Projects](/Development/Roadmap/AstriDevCon-2011)

##### (P0)

* SIP path support (Olle)
	+ (first generation of code exists, needs more work, simple patch, going to get it done, needs an extra field in astdb; helps when there are 2 or more load balancing proxies in front of asterisk, when you'd like the call to be able to get back to Asterisk; see <https://reviewboard.asterisk.org/r/991/>)
	+ <https://github.com/asterisk/asterisk/issues/view.php?id=18223>
	+ **Review 2011**: No change since 2010
* Group variables (Kobaz)
	+ (on review board, in progress)
	+ **Review 2011**: Code written and then re-written this year, tested in production for a year. Feels good code wise. Some suggestions on reviewboard and should be converted to ao2.
		- Goal to commit for Asterisk 11
		- <http://reviewboard.asterisk.org/r/464>
		- <https://github.com/asterisk/asterisk/issues/jira/browse/ASTERISK-15439>
* Pre-Dial (Kobaz) [Finished, Committed](/Finished--Committed)
	+ (I think it's done. Been in production for 12+months with no hiccups. Needs review!)
	+ **Review 2011**: Very happy with the way it is. Uploaded latest diff against trunk.
		- Goal to commit for Asterisk 11
		- <https://reviewboard.asterisk.org/r/1229/>
		- <https://github.com/asterisk/asterisk/issues/jira/browse/ASTERISK-19548>
* Hangup Handlers (Kobaz) [Finished, Committed](/Finished--Committed)
	+ (Needs to be updated to use the same gosub parse/exec as PreDial uses)
	+ **Review 2011**:
		- Goal to commit for Asterisk 11
		- <https://reviewboard.asterisk.org/r/1230>
* Distributed extension state using SIP (Olle)
	+ (resources in place, doing it, 1.4 done before Christmas, project pinana)
	+ **Review 2011**: No changes known. Idle.
* Manager event docs (Paul Belanger)
	+ **Review 2011**: Code was created and working, but did not pass code review. Talked about it again a couple of months ago, and some work done.
		- About a day or two to get the framework completed
		- Then just need to insert the documentation into the code and then it could be completed.
* Cross-platform documentation (Ben Klang)
	+ (caveats for using Asterisk on operating system xyz; pull a PDF of the Wiki documentation into the source, don't forget to include basic installation information, and do it all in .txt - Ben)
	+ **Review 2011**: Documentation updated for Solaris. Is on the wiki, and just needs to be put into a better location. Leif will help restructure part of the wiki to make the Linux and Solaris documentation (and other operating systems) a better format.
* Fix libs to optionally init OpenSSL (Digium)
	+ (or use existing tools; sort of a bug)
	+ **Review 2011**: Code on reviewboard, need to confirm that the code solves the problem, confirmed it doesn't cause harm
		- Testing required on multiple platforms and libraries
* Make ast_channel an opaque type (Digium)
	+ **Review 2011**: Large project and has not been started. Should not be on P0.

##### (P1)

* Who hung up? (there's a branch, shouldn't take too much time - Olle)
	+ **Review 2011**: Jason Parker thinks something like that may have been committed a few months ago by Jeffrey C. Ollie. Will need to review to see if anything has actually been done there.
		- Kobaz has a 2-3 line code change that simply adds events to Softhangup() and Hangup()
		- On a failed call, there is no access to the causecodes – would be powerful if we had access to it
			* Would need to develop some code that created a generic layer to convert between channel drivers (each does it different)
			* Need to investigate if there are any CEL events already created that will give some of that information
* [Codecs (SILK, OPUS), Media Negotiation](/Development/Roadmap/Asterisk-10-Projects/Media-Overhaul) (Digium)
	+ **Review 2011**: Every version of Asterisk had a fixed bitfield, and we needed to be conscious about adding new codecs (limited). Project was to remove that limitation. Reworked how media formats are represented in Asterisk. Integration of codecs like SILK and CELT. Helps with better support for video as well.
		- Framework in place
		- Need to now start using the framework to help add functionality to Asterisk
		- For Asterisk 11, would be nice to add re-invite support so that clients and re-negotiate resolutions (for video). End-to-end negotiation. Framework in place to do that, just need to add the functionality.
* RTCP (Olle)
	+ Pinefrog; Work to be done - Ported to trunk, added to CEL
	+ **Review 2011**: Idle
* Conferencing that supports a new magic media (Digium)
	+ **Review 2011**: Completed and in Asterisk 10. Updated ConfBridge() application which was pretty much re-written. Now supports high resolution codecs and voice activity video switching within ConfBridge().
	+ higher sampling rates
	+ **Review 2011**: Part of the codec negotiation framworks.

##### (P2)

* Async DNS (TCP DNS and use a good resolver)
	+ **Review 2011**: No change known.
* Named ACLs (deluxepine)
	+ **Review 2011**: Idle
* [SIP Security Events](/SIP-Security-Events)
	+ **Review 2011**: Additional work was updated and put into Asterisk 10. Only reported manager authentication events prior to Asterisk 10.
		- Prior to Asterisk 10 relaxed policy a bit and added chan_sip security events (only for inbound registration).
		- Additional work needed throughout Asterisk to add more events.
		- Added to Asterisk 10. Reference: <https://github.com/asterisk/asterisk/issues/jira/browse/ASTERISK-18264>
* Light weight means of holding NAT open in SIP (less complex than current qualify, Consider it done)
	+ **Review 2011**: No change.
* IPv6 for the restivus (IAX, Jabber/XMPP/Gtalk, Manager, etc.)
	+ **Review 2011**: No change.
* ConfBridge feature complete with MeetMe
	+ **Review 2011**: Not entirely true, but very close.
* Support sound file containers (matroska)
	+ **Review 2011**: Suggestion to have (media) files used by Asterisk not just headerless files, so you could actually do things properly, like storing G729 that contains silent suppression information.
		- No change in Asterisk, but has been getting worked on for Asterisk SCF. Very complicated. Matroska is just a framework. Once stable for Asterisk SCF, we can consider building it for Asterisk as well.
* RTMP client channel driver
	+ **Review 2011**: No change.

##### (P3)

* Unique identifier for filtering log data to a call
	+ (finishing what was already begun w/ Clod's project, CLI filtering; should take a look at what Stephan from Unlimitel.ca's created)
	+ **Review 2011**: Claude's patch was only for CLI filtering.
		- Discussion about in the logger.conf to change the configuration so that the 'core set verbose 5' (or debug, etc) that it does not affect all the configuration files when you just want to change the verbosity on the console. (<https://github.com/asterisk/asterisk/issues/jira/browse/ASTERISK-18352>)
		- Configuration could be under a header, and then create your own filters for channels, and what verbosity,debug,etc. is output to a log file and console per file
		- **Take Away**: Need to have a discussion of what people would want and need (requirements gathering), and then we can investigate how difficult it would be to implement, and what the order of implementation.

##### (P4, Simon's features)

* Multiple SIP Sockets
	+ (Listen on multiple ports or on multiple interfaces, but not all; also set binding for RTP)...alternate idea / solution would be to make Asterisk capable of loading multiple SIP profiles, it might be easier
	+ **Review 2011**: No change.
* Multiple DNS results
	+ (need to be able to traverse a list of DNS results, rather than just getting back one result)
	+ **Review 2011**: Some work has been done, but chan_sip (or others) has not been enhanced to take advantage of that.
* ICE-lite
	+ (no code, responding correctly to ICE connectivity checks (STUN multiplexed on the RTP port) and understanding the SDP); it makes NAT traversal work for clients that do ICE; also addressed lightweight NAT refresh)
	+ **Review 2011**: No change or progress. No one has tried to work on it. Appears to be very little deployment.

##### (P5)

* AstDB replacement SQLite
	+ **Review 2011**: Have initial support implemented for Asterisk 10. Backend is being used. Terry is continuing to work on additional functionality in trunk.
* SIP identity
	+ (on reviewboard; needs to be forward ported; important for organizations w/ federated identities; a requirement for DTLS SRTP; not widely deployed)
	+ **Review 2011**: No change.\

##### (P6)

* Structured identifiers for errors
	+ (tag an error message with a unique string, specific to the error message and where it came from; should be alphanumeric to keep them short)
	+ **Review 2011**: No change. Nice to have feature, but someone needs to take it on as a personal project. Essentially building a knowledge base. Would have to research what a code would look like, then pick 10, start with those, and continue to expand over time.
* AMI SetVar, Context limits
	+ (there's code already...Olle has it)
	+ **Review 2011**: Idle.
* AMI filters on demand
	+ **Review 2011**: Created by Kobaz and is part of Asterisk 10. Allows you to add filters per session and not globally.
* DTLS SRTP
	+ (not likely to be widely deployed in the next 12 months)
	+ **Review 2011**: No progress has been made. Only one library has it, and is not very mature. Not really up to the Asterisk project to solve the problem. Future consideration.

##### (P7, not kobaz)

* Write a Specification for AMI (not kobaz)
	+ **Review 2011**: Goes hand-in-hand with the event documentation. Make it so that we do no break AMI versions – no changes within the same version. We can do this since we do have the ability to version the AMI commands.
* Multiple TLS server certs
	+ (1 socket, requires support by OpenSSL; simpler to implement than multiple SIP profiles; don't know if any clients use it yet; needs more research)
	+ **Review 2011**: Currently no SIP end points that support the mechanism, and some discussion on SIP lists say that an RFC should be written. Not very difficult to do on the server side of things. Could be done between Asterisk to Asterisk since we'd implement both the client and the server.

##### (P8, nice to have)

* Make resource modules that talk to DBs attempt reconnects
	+ **Review 2011**: Added reconnect support to res_config_postgres by Kobaz. Already part of res_odbc. Other native drivers should have it added. Could abstract the reconnection support so that we don't duplicate code. Some work done, more work still possible.
* Apple's new file streaming format, derived from .m3u
	+ **Review 2011**: No changes known.
* Make MixMonitor and Monitor feature compatible
	+ **Review 2011**: Done in Asterisk 10 (per David Vossel)
		- Some discussion should be done to move res_monitor to 'extended' or 'deprecated' support level. MixMonitor() likely is now feature complete for Monitor(), especially since MixMonitor() has been implemented in a more friendly manner (in terms of I/O and threading).

##### (P?, Research Required)

* New app_queue (as if? no, seriously? talking about this scares Russell)
	+ **Review 2011**: Suggested by Kevin that we could have a single box that handles no media, and just does the signalling. Since the agents can be distributed with distributed device state, all registrations would be remote from the queue server. There needs to be an atomic server that would handle the decision making.
		- Gregory (irroot) – additional skills based routing code and features.
* Identify and fix all bugs in AMI
	+ **Review 2011**: In progress.
* Broadsoft or Dialog Info shared line appearance (SLA) support
	+ (Tabled for later discussion)
	+ **Review 2011**: Licensing issues. Code written using documentation that is marked as confidential. No situation change. Unable to merge code.
* LDAP from within the dialplan
	+ (we may already have it, needs research to see if the realtime driver does what's desired - Leif)
	+ **Review 2011**: Yes you can already do this using dialplan functions. REALTIME_FIELD and REALTIME_HASH, etc..
* Device state normalization
	+ **Review 2011**: Unknown what this means. Could be different channel drivers report different types of information. No change.
* Anything DB over HTTP(s) with failover handling
	+ **Review 2011**: Unknown what this is.
* Use a channel as a MoH Source
	+ **Review 2011**: Still a neat idea.
* Kill Masquerades
	+ **Review 2011**: With fire! (Kevin)
* Bridging thread pool
	+ **Review 2011**: If you have 200 calls up, you have 200 threads up just polling, when you could just have 10 that each handle 20 bridges, and then you reduce context switching. (That's the idea.) Code not likely flexible enough to do this. Could be done... (Kevin)
* Threadify chan_sip
	+ **Review 2011**: This would cause an entire re-write on chan_sip, so this is not possible unless a new channel driver were written.
* Export ISDN ROSE information up to Asterisk channels
	+ **Review 2011**: Not much was really discussed on this as there has not been much requirement for it.

### Projects Discussed

* Group variables (Kobaz)
	+ (on review board, in progress)
	+ Code written and then re-written last year; has been in production for some time.
	+ Kobaz to take a look at getting the review refreshed
		- <http://reviewboard.asterisk.org/r/464>
		- <https://github.com/asterisk/asterisk/issues/jira/browse/ASTERISK-15439>
* RTCP (Olle)
	+ Pinefrog; Work to be done - Ported to trunk, added to CEL
	+ Mentioned that this would be really nice to have.
* Async DNS (TCP DNS and use a good resolver)
	+ Many people mentioned that having asynchronous DNS and supporting multpile srv records would resolve a lot of issues with Asterisk behind SIP proxies. This would be a good project for Asterisk 12.
* Named ACLs (deluxepine)
	+ Named ACLs committed for Asterisk 11; however, this did not fully capture all of the use cases of Olle's deluxepine branch.
	+ For folks interested in security, this may be worth looking into.
* IPv6 Support for chan_iax2
* Call-ID Logging Filtering
	+ Make use of the call-id that is tagged with channels through other mechanisms (CLI filtering, etc.)

Agreed Upon Goals
=================

After much discussion, the attendees agreed that two broad areas needed to be addressed for Asterisk 12. While many other projects should also receive attention, these two goals should be the focus of the Asterisk developer community. These are:

* Overhaul the SIP functionality in Asterisk.
* Make the APIs exposed by Asterisk consistent and easier to build applications on top of.
