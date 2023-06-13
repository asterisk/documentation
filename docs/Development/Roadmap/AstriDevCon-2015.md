---
title: AstriDevCon 2015
pageid: 32376286
---

Overview
========

AstriDevCon 2015 was held at the [Loews Royal Pacific Resort](http://www.asterisk.org/community/astricon-user-conference/venue-and-travel) on Tuesday, October 13th, 2015. Participants gathered to discuss the state of the Asterisk project, ideas for improvements, and to coordinate development efforts.

In addition, four participants presented on topics interesting to their usage of Asterisk. Those four were:

* Sean McCord of Cycore Systems
* Lorenzo Emilitri of Loway
* Ben Klang of Mojo Lingo
* Torrey Searle of Voxbone

Lunch was provided by [Bluehost](https://www.bluehost.com), who once again sponsored this event. Much thanks to the speakers and sponsor!

Participants
============

Apologies in Advance I often misspell names while I'm taking them at the start of AstriDevCon. If you see your name here and it is typed incorrectly, please comment on the bottom of the page and we'll get it fixed up quickly. The same goes for your organization as well.

If you were in attendance at AstriDevCon and I don't have you on the list, please also comment and we'll make sure you're noted.



| Name | Organization |
| --- | --- |
| Matt Jordan | Digium |
| Mark Michelson | Digium |
| Malcolm Davenport | Digium |
| Joshua Colp | Digium |
| Scott Griepentrog | Digium |
| Kyle Kurz | Digium |
| Dan Jenkins | Nimble Ape |
| Andy Smith | Truphone |
| James Body | Truphone |
| Tim Panton | Himself |
| Corey Farrell | Raynet Technologies |
| Jason Parker | Sangoma |
| Rob Thomas | Sangoma |
| Lorenzo Emilitri | Loway |
| Marco Signorini | Loway |
|  Sylvain Boily | Xivo |
| Clod Patry | TelcoBridges |
| Daniel Collins | USAN |
| Steve Sokol | Digium |
| Carlos Medina | Sangoma |
| Andrew Nagy | Sangoma |
| Bryan Walters | Sangoma |
| David Duffett | Digium |
| Perry Ismangil | Teluu |
| Nanang Izzuddin | Teluu |
| Ahmad | ITConsultant |
| Alan Graham | Thinking Phones |
| Bradley Watkins | Avoxi |
| Michael Swann | Connection Telecom |
| Steve Davies | Connection Telecom |
| Florian Buzin | Starface |
| Daniel-Constantin Mierla | Kamailio/Asipto |
| Vincent Morsiani | Voxbone |
| Torrey Searle | Voxbone |
| Philippe Lindheimer | Sangoma |
| Sean McCord | CyCore Systems |
| James Cloos | Consultant |
| James Finstrom | Sangoma |
| Kevin McCoy | QLOOG |
| Nir Simionovich | Greenfield Technologies |
| Arik Halperin | Greenfield Technologies |
| Or Polaczek | Greenfield Technologies |
| Eric Klein | Greenfield Technologies |
| Keith Hunt | Mojo Lingo |
| Ben Klang | Mojo Lingo |
| Leif Madsen | Avoxi |
| Darren Sessions | Avoxi |
| Jared Smith | Bluehost |
| Brian West | FreeSWITCH Solutions |

Discussion
==========

Recap of 2015
-------------

* gave a brief recap of the development work that occurred in 2015 (see ).
* Three major goals were outlined from last year's DevCon:
	+ Move the project to Git
	+ Improve the documentation
	+ Improvements to Asterisk as a media application server
* Move the project to Git
	+ This was (relatively) completed:  
	
		- The project has been moved to Git, with code reviews and hosting performed by Gerrit (see [https://gerrit.asterisk.org)](https://gerrit.asterisk.org)
		- Continuous Integration (CI) infrastructure was deployed using Zuul and Jenkins (see <https://jenkins.asterisk.org>)
	+ Some things that still need to be done:
		- Some tweaks to the CI infrastructure still need to be done, including 's ref leak tests. **Note:** all Zuul/Jenkins jobs are open source in the **infrastructure** repo, and can be submitted for review to Gerrit
		- There's clearly a bit of a learning curve with Gerrit. Some education on its usage would be useful.
			* did a demo of submitting a patch at the end of DevCon, but others remarked that was still a bit daunting.
* Improve Documentation
	+ Lots of new pages have been added to the wiki, covering both existing functionality, e.g., , , as well as new features in point releases of Asterisk 13, e.g., ,
	+ Phase 1 of  was completed, including reference configuration for a basic PBX included in the source tree (under the folder 'configs/basic-pbx').
	+ **Note:** this is an ongoing process
* Asterisk as a media application server
	+ New events:
		- [ChannelConnectedLine](https://wiki.asterisk.org/wiki/display/AST/Asterisk+13+REST+Data+Models#Asterisk13RESTDataModels-ChannelConnectedLine)
		- [`ChannelHold`](https://wiki.asterisk.org/wiki/display/AST/Asterisk+13+REST+Data+Models#Asterisk13RESTDataModels-ChannelHold) and [`ChannelUnhold`](https://wiki.asterisk.org/wiki/display/AST/Asterisk+13+REST+Data+Models#Asterisk13RESTDataModels-ChannelUnhold)
		- [`ContactStatusChange`](https://wiki.asterisk.org/wiki/display/AST/Asterisk+13+REST+Data+Models#Asterisk13RESTDataModels-ContactStatusChange) and [`PeerStatusChange`](https://wiki.asterisk.org/wiki/display/AST/Asterisk+13+REST+Data+Models#Asterisk13RESTDataModels-PeerStatusChange)
	+ [`channels`](https://wiki.asterisk.org/wiki/display/AST/Asterisk+13+Channels+REST+API) resource additions:  
	
		- The [`originate`](https://wiki.asterisk.org/wiki/display/AST/Asterisk+13+Channels+REST+API#Asterisk13ChannelsRESTAPI-originate) operation now lets you specify an `originator` for `linkedid` propagation
		- The [`channel`](https://wiki.asterisk.org/wiki/display/AST/Asterisk+13+REST+Data+Models#Asterisk13RESTDataModels-Channel) data model now includes the `language` field for the Asterisk channel it represents
		- The [`originate`](https://wiki.asterisk.org/wiki/display/AST/Asterisk+13+Channels+REST+API#Asterisk13ChannelsRESTAPI-originate) operation and [`continue`](https://wiki.asterisk.org/wiki/display/AST/Asterisk+13+Channels+REST+API#Asterisk13ChannelsRESTAPI-continueInDialplan) operation now let you specify a priority label
		- The [`redirect`](https://wiki.asterisk.org/wiki/display/AST/Asterisk+13+Channels+REST+API#Asterisk13ChannelsRESTAPI-redirect) operation was added, allowing channels to be transferred or forwarded to external systems
	+ [`asterisk`](https://wiki.asterisk.org/wiki/display/AST/Asterisk+13+Asterisk+REST+API) resource additions:
		- Module manipulation can now be done via `/asterisk/modules`:
			* [`listModules`](https://wiki.asterisk.org/wiki/display/AST/Asterisk+13+Asterisk+REST+API#Asterisk13AsteriskRESTAPI-listModules) - retrieve all modules in the system
			* [`getModule`](https://wiki.asterisk.org/wiki/display/AST/Asterisk+13+Asterisk+REST+API#Asterisk13AsteriskRESTAPI-getModule) - retrieve a specific module
			* [`loadModule`](https://wiki.asterisk.org/wiki/display/AST/Asterisk+13+Asterisk+REST+API#Asterisk13AsteriskRESTAPI-loadModule) - load a specific module
			* [`unloadModule`](https://wiki.asterisk.org/wiki/display/AST/Asterisk+13+Asterisk+REST+API#Asterisk13AsteriskRESTAPI-unloadModule) - unload a specific module
		- Log channel manipulation can now be done via `/asterisk/logging`:
			* [`listLogChannels`](https://wiki.asterisk.org/wiki/display/AST/Asterisk+13+Asterisk+REST+API#Asterisk13AsteriskRESTAPI-listLogChannels) - retrieve the current log channels
			* [`addLog`](https://wiki.asterisk.org/wiki/display/AST/Asterisk+13+Asterisk+REST+API#Asterisk13AsteriskRESTAPI-addLog) - add a new log channel
			* [`deleteLog`](https://wiki.asterisk.org/wiki/display/AST/Asterisk+13+Asterisk+REST+API#Asterisk13AsteriskRESTAPI-deleteLog) - remove a log channel
			* [`rotateLog`](https://wiki.asterisk.org/wiki/display/AST/Asterisk+13+Asterisk+REST+API#Asterisk13AsteriskRESTAPI-rotateLog) - rotate the log channels
		- Push configuration for  backed modules. This was designed specifically for use with the PJSIP stack. Using ARI, PJSIP objects can be pushed into Asterisk and backed by one of the pluggable sorcery backends. See  for an example of using this.
	+ `events` resource additions:
		- When establishing a WebSocket connection, you can now subscribe to all events happening in Asterisk using the [`subscribeAll`](https://wiki.asterisk.org/wiki/display/AST/Asterisk+13+Events+REST+API#Asterisk13EventsRESTAPI-eventWebsocket) query option.
	+ `applications` resource additions:
		- When [subscribing](https://wiki.asterisk.org/wiki/display/AST/Asterisk+13+Applications+REST+API#Asterisk13ApplicationsRESTAPI-subscribe) to an event resource, not providing any specific resource name will now subscribe you to all events for that resource type. Note that the specific resource names are now optional for all resource types.
Presentations
-------------

### Sean McCord

Where is Sean's Presentation?Sean, in a fit of daring, presented completely without slides. Impressive!

* Sean has now migrated/rewritten several systems that previously used AMI and AGI with Asterisk 11 to Asterisk 13, ARI, Go, and Docker
	+ As an aside, with ARI, there are pros/cons to using a statically typed language such as Go. The more dynamic languages (JavaScript, Python, etc.) can auto-generate bindings more easily. On the other hand, static typed languages can make development more predictable, eliminating some classes of errors. It's a tradeoff.
* Asterisk 13 with ARI feels somewhat like the intent of Asterisk SCF. True, it doesn't have some of the interesting scalability features of Asterisk SCF, but pulling the application logic out of Asterisk makes it scale more easily, and the API presented by ARI is nice.
* Things that could be better in ARI:
	+ Documentation still needs work. The "first level" of documentation is okay, the "second level" needs improvement. Some documentation is confusing. Specific examples:
		- Media URIs in ARI are not always documented consistently
		- Body and path parameters both have IDs, and when to use body versus path is not always clear
	+ As a C developer, adding features to ARI is not clear. Unlike AMI, or dialplan applications, where there were clear registration functions, ARI is more "tightly coupled" with the system. This may also be a documentation issue.
	+ When a WebSocket connection is broken, channels 'hang around' in the Stasis dialplan application, and new channels can enter - albeit with a warning. Some way to more gracefully handle this scenario would be good.
	+ Arbitrary tone detection is desirable. DTMF is great, but getting an event when a particular DSP specific frequency is triggered would be neat.
* Docker


	+ Docker has lots of benefits when used with Asterisk (see open discussion notes below). However, there are some issues.
	+ Docker networking sucks. Asterisk uses a lot of ports; having to open up large ranges is never fun.
	+ Lots of third party docker files, most suck (but that's okay). Maybe we can improve upon this by adding a docker file to the source tree as a basis?
* Asterisk logging options could be improved upon (see open discussion notes below).

As a result of Sean's presentation, a large number of discussions occurred on a variety of topics. Since these ranged across a broad spectrum and were added to as the day progressed, those topics are documented in the open discussion section below.

### Lorenzo Emilitri

### Ben Klang

### Torrey Searle

open\_discussionOpen Discussion
-------------------------------

* dockerDocker
	+ The networking system is now pluggable.
		- Sean: Not many good implementations yet.
		- Lenz: Lots of traction with Docker, will probably just be improved in the future.
		- Sylvain: Docker 1.9 contains a new system.
	+ Sean: Docker image format is stable; what has changed is breaking things out and making it more modular
		- Doesn't feel like a moving target; really, does it provide what a VoIP application needs?
	+ Motivations:
		- CoreOS stack/scaling
		- Immutable infrastructure/testing
		- Microservices
		- Orchestration
		- Easier to build than RPMs
* Packaging
	+ In a Docker world, how much do we care about packages?
	+ Community people typically just do it, as opposed to the projects
	+ Leif: packages are still required
		- Every run command adds a layer of information to the image
		- Packages let you flatten things a bit in the image
	+ James: lots of systems means you need packages
	+ Ben: source packages are very helpful
	+ Should we have a common docker file in Asterisk?
		- Leif: we can probably figure that out
		- Corey: How about just having a .spec file?
		- [packages.asterisk.org](http://packages.asterisk.org) should be related to that .spec file
* Configuration
	+ Would be nice if Asterisk played better in a cluster environment
	+ Steve: How much configuration is doable from ARI?
		- Not much. Just sorcery.
		- Rob: I hate the idea.
		- Mark M: Can we just use more sorcery?
		- Darren: I'd +1 that
		- Darren: You're at a different level if you're doing this
		- Steve: GUI or API is the way things are done today.
		- Corey: Be careful which configs we can do via ARI
* ARI
	+ How many others have attempted to add things to ARI?
		- Darren: TTS.
	+ Lenz: People are still trying to wrap their heads around ARI.
		- I'd like to offer a Docker image that you can run an ARI hello world in
		- Goal: Have an Asterisk image that people can load up and use
		- Daniel: How about VirtualBox?
		- Could be anything, so long as it is easy to setup, deploy, and throw away
* Video
	+ Ben/Dan: Don't reinvent the wheel
	+ Farm out to FreeSWITCH or Jitsi videobridge
	+ Should we farm out? Makes it harder for users
		- Darren: we already do that. TTS, ASR, etc.
	+ Steve: so we're a telephony engine. What do we want to be?
		- Where is this headed? Is it WebRTC?
		- Asterisk disrupts the PBX world
	+ Lenz: Video is just part of telephony
	+ Ben: Asterisk is an infrastructure piece.
	+ Daniel: WebRTC brings more security stuff, which is good
		- Codecs.
		- Hardware/telephony manufacturers: SRTP
	+ Dan Jenkins: Opus.
	+ Steve: microservices are the way other people are approaching the problem, as opposed to the traditional model of SMB PBX
* Documentation
	+ Hard to find, probably exists
* Codec negotation improvements
	+ Reduce eliminate transcoding on the fly
* Asterisk as a piece of Infrastructure
	+ loggingLogging
		- Dan: grok filter, file input
		- Sean: Asterisk console output + wrapper
			* stdout is flexible
			* UDP port with JSON is easiest
		- Brad: logstash monitor
			* loggly
			* sumo logic
	+ Horizontal scalability
		- Torrey: How can we roll out Asterisk faster? Can we run multiple versions on the same box?
			* Docker
			* CLI commands/APIs to tell Asterisk to stop/start listening
		- Leif: Discovery is an issue
			* Rob: UPnP
			* etcd (CoreOS)
			* consul
			* SRV records
			* Leif: attach metadata about what an instance is capable of doing
		- Daniel: Also have to worry about authentication/authorization
			* Discovery is a part
		- Corey: Custom module to run a script on startup
* Swagger versioning
	+ It'd be nice if it was one version
	+ Sean Bright was working on this
Conclusions
===========

 

