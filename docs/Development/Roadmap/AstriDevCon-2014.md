---
title: AstriDevCon 2014
pageid: 30278623
---

Participants
============



| Person | Organization | Country |
| --- | --- | --- |
| Matt Jordan | Digium | US |
| Scott Griepentrog | Digium | US |
| Gary Hoskins | Vectra Software | US |
| Sam Galarneau | Digium | US |
| Rusty Newton | Digium | US |
| Joshua Colp | Digium | US |
| Malcolm Davenport | Digium | US |
| Mark Michelson | Digium | US |
| Brad Watkins | ThinkingPhones | US |
| Alan Graham | ThinkingPhones | US |
| Paul Belanger | PolyBeacon | Canada |
| Leif Madsen | ThinkingPhones | Canada |
| Sean Bright | CallShaper | US |
| Andrew Nagy | Schmooze | US |
| Nir Siminovich | Greenfield | Israel |
| Eric Klein | Greenfield | Israel |
| Chad Singer | USAN | US |
| Dan Collins | USAN | US |
| Torey Searle | VoxBone | Belgium |
| Vincent Morsiani | VoxBone | Belgium |
| Bryan Walters | SchmoozeCom | US |
| Kevin Miller | Vantage | US |
| Jason Parker | Schmooze | US |
| Rob Thomas | Schmooze | Australia |
| Marco Signorini | Loway | Switzerland |
| Lenz Em | Loway | Switzerland |
| Junichi H | Digium | US |
| Jakub Klausa | SS7 Tech | Poland |
| Daniel Mierla | Asipto | Germany |
| George Joseph | Farivew 5 | US |
| Russ Meyerriecks | Digium | US |
| Jared Smith | Bluehost | US |
| Andy Smith | Truphone | UK |
| James Body | Truphone | Great Britain |
| Antony Russell | Clarotech | South Africa |
| David Duffett | Digium | Great UK |
| Matt Frederickson | Digium | AL |
| Ben Klang | Mojo Lingo | US |
| Darren Sessions | Avoxi | US |
| Corey Farrell | Raynet Tech | US |

Agenda
======




!!! note 
    All times are in PDT

      
[//]: # (end-note)



Project Policies (10-11:15am)
-----------------------------

* Allowed changes (LTS/Standard)
	+ Standard is okay with test requirements
	+ Jared: policy worked really well and everyone seems to think so
	+ Does anyone run standard in production?
		- Jared/Daniel: yes
		- Aggressiveness in Standard release is warranted
			* Should we be more aggressive?  Particularly in the initial stages?
			* API versioning: when should it apply?
		- Daniel: don't change some things in LTS
			* Data models should not be changed
			* Configuration schemas should not change
			* No breaking changes in LTS release
		- LTS can allow new features, but must be low impact. No breaking features, does not impact the user in a negative fashion
			* Require community notice and sufficient time (1 week prior to cutting RC) to accommodate.  If new modules, merge disabled, then enable if approved.
		- Standard: allow more aggressiveness
		- **Action:** Matt to draft wiki page
* External libraries (help packagers)
	+ pjproject: such a core part of Asterisk.  Was embedded.  General speaking, do we feel it should be external?
		- Stability is iffy.  pjproject is not designed to be an external library.  People have to be careful when updating.
	+ Jared: generally, yes.  RH side is appreciated.  Harder sometimes on the end user, probably things we could to to help them.
		- May need better documentation, particularly for end users
	+ Asterisk:
		- editline, iLBC
* Infrastructure
	+ GIT!
		- George: really, just do it.
		- Darren: Stash integration with JIRA is nice.
			* but it doesn't bundle notifications
		- Will we do pull requests?
			* Only if it's the only mechanism.  Multiple mechanisms are hard.
		- Can we make it easier for contributors?
		- Do we do the Linus model for merging?
			* Paul: is it a developer's job to merge?
			* Sean: not a problem for merging between branches
			* Matt F: It isn't free.  There is work involved.
			* Downside of open stack approach: lots of moving parts
				+ Leif: you can pick a subset of those parts
		- **Action**: finish evaluation
* Testsuite
	+ Dependencies are the hardest part.  Debian packagers:
		- attest doesn't work (but do we care?)
	+ Paul: can we name the test suite?
	+ George: trying to get all of the tests to run usually blows up.  The documentation is lacking.
	+ Torey: versioning of the test suite?
		- Paul: I have a solution to that.  It's radical.  Remove the tests from the test suite (and put them somewhere else).
		- Version the 'stock' test suite libraries
		- **Action**: determine what it would take to do that as we move to git
		- Have test suite in docker.  Community: provider docker config

Application Server (11:20am-1pm)
--------------------------------

* Deprecate AMI/AGI (Ben Klang)
	+ George: configuration
		- "New" configuration - sorcery/config framework
			* Push model of configuration - ARI
		- "Old" configuration - (voicemail.conf, sip.conf, users.conf)
			* Update static files, then do a reload
			* Preferably preserve old mechanism in some fashion
	+ Motivation on deprecating it
		- There is no one API.  This makes it difficult for versioning.  A change to any one makes versioning challenging.
		- If we don't remove something, ARI may make things more painful.
		- AMI/AGI not sufficient by itself; if ARI is sufficient, that'd be nice
		- Can we at least get to the point where ARI is the future?
		- Paul: if multi-interfaces are the problem, why can't AMI/ARI be condensed?
			* Example: AMI/ARI have their own event systems
			* Let AMI use the ARI web socket for its events
				+ Would have to solve semantic issues between AMI/ARI event streams
		- Do we want ARI to replace AMI (take its role)?
			* Should ARI become a call control protocol?
			* Lenz: till lots of old stuff in the field.  Doing away with all of it will not be easy.  A change to ARI will not happen tomorrow unless you control the deployment.
			* Ben: can't just pull it.  Just don't want to keep enhancing it.
		- Example: Security events
			* Should they be in ARI?
			* George: we probably do need to have the distinction.
			* Nir: vast majority of community doesn't understand ARI.  It needs to be easier in order to replace AMI.
			* Jared: adoption may be slow since it doesn't do everything AMI does.
			* **Action**: -dev/-users list: what are using AMI for that we can't use ARI for?
			* Leif: we're in a transition, moving from dialplan model to external control model.  Probably need external application to be built for us to move completely away from AMI/AGI.
			* Paul: take away apps, and whatever is in the core is what we should care about
			* Lenz: some things are harder in ARI
				+ TTS is actually harder (I can use an AGI script for that)
				+ Playlists
			* Should we use the dialplan at all?
				+ The idea is: ARI should not use the dialplan applications at all
				+ pbx\_stasis: catch-all for channels
* ARI Enhancements
	+ Play media from remote sources
	+ TTS/ASR
		- Leif: write down how you think one would to it
		- **Action**: Matt to write things down
		- Grammar processor
			* DTMF & ASR
			* Adds latency to application layer today
* What things does ARI not do (that you would like to to do)?  

	+ Transfers
		- Need a way to tell the endpoint to redirect to another system
			* This does not exist today
	+ Playlists
	+ Subscriptions
		- Wildcard: subscribe me to all bridges (or everything)
	+ Security Events
	+ Have Asterisk initiate the web socket connection (client)

Scalability (1pm-2:15pm)
------------------------

* Message bus support (Reddis/RabbitMQ)
	+ Externalizing Stasis Message Bus
		- Really want just the state of the system
			* AMI syntax: still clunky, telnet breaks
		- Darren: more interested in scaling
		- Nir: How do I maintain the state of the user, and their location?
			* AstDB (sorcery)
			* Location of a device (and which system it is on)
				+ Maintaining synchronization of location across all systems
			* Documentation
				+ Jared/Leif: 'sample configuration' that solves X
					- Example: single-system PBX
		- Problem: every scalable system looks different
			* One way of approaching this would be to have a cookbook - defined solutions for defined problems
			* Higher-level view of Asterisk is an ecosystem (with proxies, etc.)
			* Daniel: scaling out is a matter of requirements.  Keep the core infrastructure simple, put the load on the client side
* Simplifying sitting behind a proxy
	+ Different identification schemes
	+ Registration state dictates endpoint/device state
		- If I have a call from something, assume it exists
		- Have the presence of a call signal that an endpoint/device state exists.  Derive from the signalling.
		- **Action**: Daniel to provide an e-mail describing the problem
	+ Need to know system load
		- NEED: CPU usage (Sean Bright and Malcolm: SNMP?)
		- Channel count
		- Memory usage
		- Torey: we send an INVITE once a minute and see what happens
		- Call quality statistics (secondary indicator)
		- Distribution of response times on requests/responses
		- Call quality (see above, again)
		- Darren: two scales - one for concurrent, one for calls per second
			* Caching mechanisms in Linux can be self-defeating.  Caching at that call volume can be rough
				+ Look at IOStat
* Simplifying routing/dialing of SIP URIs
* Federation

Media (2:15pm - 3pm)
--------------------

* Codec Visibility
	+ Codec control from dialplan
		- PJSIP\_MEDIA\_OFFER may provide this, would be nice for chan\_sip
	+ Better control over SDP Offer/Answer
		- Force re-INVITE for codec changes
		- or other things (such as a new media address)
* BUNDLE support
* Trickle ICE
	+ Need better documentation for WebRTC to aid in testing/dev
	+ During PJSIP development, the rapid pace made it hard to follow
	+ RTP: have someone act as a sponsor, have someone do the PR
* RTCP enhancement (Olle)
* res\_rtp\_asterisk "crufty"
* Live call failover???
	+ Relatively hard to do
	+ May not be the highest priority
	+ Other media externalization
		- Paul thinks it would be interesting
		- Daniel: Media processing as a service by Asterisk
			* Nothing advanced, just basic stuff like an announcement or something

PJSIP Enhancements (3pm - 3:30pm)
---------------------------------

* Dial an AoR
	+ endpoint -> Aor -> contact1 & contact2, etc.
	+ **Note** We need more documentation for this
	+ Disconnect between device state and contacts.  Need to know which contacts are in use.
		- There's no guarantee that information in SIP messages maps back to a contact
	+ **Action**: document & explain the problem
* SIP Outbound
	+ Client or Server?
	+ May be solved better by DNS support
	+ Not much pressure from market for it
	+ Table SIP Outbound until DNS is really good
* DNS Resolver Woes
	+ Are we only concerned with Asterisk's PJSIP DNS resolution? Or do we  care about the rest of Asterisk?
		- E.164 lookups are really needed (have to shell out to do it today - Rob)
		- XMPP
	+ Complaints about current system:
	+ Respect TTLs
	+ Asynchronous
	+ NAPTR
	+ SRV failover
	+ IPv6
	+ Josh: a lot of this is in how you use it
* Simplifying routing/dialing of SIP URIs
	+ sip: - go out specific peer
	+ **Action**: Ben Klang - propose out on -dev list
* Fix unloading/reloading of res\_pjsip

WebRTC (3:30pm - 4pm)
---------------------

* How is our happiness level today?
	+ Andrew: no way to determine if can\_sip or chan\_pjsip should be used for web sockets (open bug)
	+ Ben: better logging.  When it doesn't work, it's really hard to figure out.
	+ Better documentation
	+ Opus ...
	+ ORTC

Data Capture (Phone Home) (4pm - 4:15pm)
----------------------------------------

* Upload backtraces
* Figure out what crashes are most important
	+ Switch DONT\_OPTIMIZE off by default
		- Darren: Had a large impact in an Asterisk SCF test
		- May want to turn off for Standard Releases, leave on for LTS
	+ Opt-out for data?
	+ Opt-in for backtraces?
	+ Needs a notice that it's on
	+ Anonymize backtraces & open source the anonymize
	+ Philippe: this is two projects, stats and debugging), keep them separate
	+ Define where the data goes to

 

Conclusions
===========

GIT needs to happen. Need to improve our infrastructure and make it clearer how someone contributes to Asterisk.

Document features better, including scenarios. Make it easier to configure/deploy Asterisk.

Pushing Asterisk into acting more as a media applications server is very important.  It feeds into scalability, into making it do more than what it can do today, and affects more pointedly the features in ARI.

 

 

