---
title: AstriDevCon 2017
pageid: 38764641
---

Overview
========

AstriDevCon was held on  at the Omni Orlando Resort at Championsgate near Orlando, FL. There were approximately 35 attendees on average throughout the day. Lunch was provided by e4strategies.com.

![](Devcon-group-2.jpg)

Attendees
---------

* Matt Fredrickson, Digium, US
* Josh Colp, Digium, US
* George Joseph, Digium, US
* Malcolm Davenport, Digium, US
* Kevin Harrell, Digium, US
* Ben Ford, Digium, US
* David Duffett, Digium, US
* Matt Jordan, Digium, US
* Sean Pimental, Digium, US
* Kyle Kurz, Digium, US
* Torrey Searle, Voxbone, BE
* Gabriel Gontariu, Voxbone, BE
* Clod Patry, Jive, CA
* Lorenzo Emilitri, Loway, CH
* Dan Jenkins, Nimble Ape, UK
* Nir Simionovich, Greenfield, IL
* Eric Klein, Greenfield, IL
* Sean McCord, CyCore, IL
* Jim Van Meggelen, CA
* Louis-Olivier Roff, Jive, CA
* James Finstrom, Sangoma, US
* Jason Parker, Sangoma, US
* Bryan Walters, Sangoma, US
* Andrew Nagy, Sangoma US
* Evan McGee, HiFelix, US
* Emmanuel Rolon, Organic Farms Vitamins, US
* Daniel Mierla, Miconda, DE/RO
* Fred Posner, Qxork, US
* François Blackborn, Wazo, CA
* Sylvain Boily, Wazo, CA
* Ludovic Gasc, ALLOCloud/Eyepea, BE
* Sean Bright, Callshaper, US
* Alex Goodman, Axia Technology Partners, US
* David Al-Khadhairi, USAN, US
* Dan Collins, USAN, US
* Steve Murphy, US
* Corey Farrell, US
* Jared Smith, US
* Corey McFadden, Voneto, US

 

Presentation Slides
===================

[AstriDevCon 2019 - State of the Asterisk (Asterisk 15)](StateOfTheAsteriskDevCon2017.pdf) - Matthew Fredrickson

[AstriDevCon 2019 - Asterisk and Video](Asterisk-and-Video.pdf) - Joshua Colp, Kevin Harwell

[AstriDevCon 2019 - AMQP](Astridevcon-2017-AMQP-2.pdf) - Sylvain Boily

[AstriDevCon 2019 - Asterisk Calendars](Asterisk-calendars.pdf) - Ludovic Gasc

Notes and highlights
====================

Morning Session
---------------

Introductions. See attendees list.

Matt F introduces his background and why he's in the front of the room.

Current releases of 13 and 14 and now 15.0.0.

Asterisk 15 contribution stats:  924 commits, 82 individual contributors, almost 2400 merged code reviews acros all branches on Gerrit in the past 12 months.

  


Top contributors by # of commits by people outside of Digium:

* 104 Sean Bright, Callshaper
* 42 Corey Farrell
* 39 Alexander Traud
* 20 Alexei Gradinari
* 19 Tzafrir Cohen, Xorcom
* 15 Torrey Searle, Voxbone
* 11 Walter Doekes
* 9 Rodrigo Ramirez Norambuena
* 9 Badalyan Vyacheslav
* 6 Frahaase
* 6 Sebastian Gutierrez
* 6 Michael Kuron
* 5 Daniel Journo
* 4 kkm
* 4 Timo Teras
* 4 Martin Tomec
* 4 Joshua Elson
* 4 Jean Aunis
* 4 Aaron an

  


### What’s new in Asterisk 15?

Platform Improvements

Miscellaneous Other Improvements and…

Video, WebRTC, and more, Oh My!

### Platform Improvements:

GCC 7 fixes

Build fixes for FreeBSD when missing crypt.h

Build fixes for the GNU HURD

Added support to build against BIND8

OpenSSL 1.1 support

Libsrtp2.1 support

Alembic support for MS-SQL

PJPROJECT bundled support is enabled by default

### Miscellaneous Other Improvements:

New Asterisk sounds release (1.6)

Google OAuth 2.0 protocol support for XMPP/Motif

Chan_rtp uses ulaw by default now instead of slinear

Binaural audio support patches for confbridge were merged

Debug_utilities: ast_coredumper

Debug_utilities: ast_loggrabber

### Video, WebRTC, and more, Oh My!:

Support for RTCP-MUX

‘Webrtc’ endpoint option in res_pjsip.conf

VP9 passthrough support

RTP dynamic payload numbers are now truly dynamic (on a per-call basis)

Extensive work to preserve RTP sequence number gaps / losses across legs in a call (critical for video, makes audio better, too)

ICE interface blacklist optional added to rtp.conf

  


(Discussion about Sean Bright’s patch on Gerrit for ephemeral keys - that are used in the RTP encryption in DTLS-SRTP.)

(Torrey brought up the point that Kamailio now has ephemeral authentication, as well, so that certificates for authentication can be time-limited, etc.)

  


Support for more than 32 dynamic RTP payloads now exists.

Abstracted SDP layer was added (and is still being worked on)

Added support within the Asterisk core for multi-audio and multi-video stream media per ast_channel

Added support within the Asterisk core to renegotiate media capabilities on an active call as required

Support for BUNDLE was added

app_steram_echo added

SFU support in app_confbridge

  


(some discussion about SFU and MCU and the tradeoffs between them)

### Project Background

Asterisk 11( LTS) was released in October of 2012

Asterisk 12 was released in December of 2013

Asterisk 13 (LTS) was released in October of 2014

Asterisk 14 was released Monday, Sep 26 of 2016

Asterisk 15 was released Tuesday, October 3rd of 2017

Asterisk 16 is the next LTS target.  There is a lot of additional work that needs to go into the video capabilities of Asterisk 15 before we want to support it as an LTS.  The video work in Asterisk 15 is a great MVP, but it needs more functionality to be useful for years to come.  So, many changes will occur in 15 towards the goal of 16 as the next LTS.

  


RTCP-MUX

Chrome decided to require an additional flag be passed in to interoperate with legacy endpoints that lack support for RTCP-MUX in January/February of this year

Dan Jenkins informed the Asterisk project of this issue around that time

RTCP-MUX support was implemented at around that time frame to deal with a potential end of life of that behavior

RTCP-MUX support was merged into Asterisk 13 and 14 branches

Chrome is supposed to completely remove support for RTCP-MUX at sometime around the October timeframe.

### Reminder

11 was already in security-fix only mode and is going to be completely dead in October.  Get off that branch! (particularly if you run WebRTC)

  
Now, Joshua Colp and Kevin Harwell to talk about video SFU in Asterisk.  


But first, recognition to those that have built tests for the Asterisk test-suite in the past year.

Now, actually, Josh and Kevin.

  


### Asterisk 15 and video.

Overview

Old Media Flow

Streams

New Real STreams

PJSIP

Legacy Support

Bridging

SFU

WebRTC

### Old Media Flow

Single logical flow internally carrying media

Each media frame has a type and format

Conceptually, only 1 stream of each type is possible

Negotiated media formats are all combined together

### Streams

Flow of a single type of media

Can be one way or two way

Has a name which can have meaning

Can be added, removed, or changed

Has negotiated media formats specific to the stream

### New Real STreams

First class stream object

Contains only information specific to the stream

Groups of streams are kept in a container called a topology, indexed based on position number

Channel can have stream added, removed, or changed

Each media frame has a type, format, and stream number

### Multistream Users

Constructs streams according to negotiated result

Responsible for placing stream topology on channel - not done automatically

Responsible for responding to requests

### PJSIP

Only channel driver supporting multiple streams currently

Outgoing uses requested stream topology, adding streams to SDP

Incoming negotiates streams based on configured formats

Can be told to renegotiate to add/remove/change streams

PJSIP has a hard limit right now of 16 streams; you’d have to recompile pjproject in order to change that number

### StreamEcho

Extended version of the Echo() application

Will request renegotiation to ensure specified number of streams are present

Echoes media receives on first stream of each type to every other stream of that type

### Legacy Users

See and interact with only a single pipe like before

Can have only 1 stream of each type

Existing APIs create streams automatically as appropriate

Does not have any knowledge of new stream support

Ast_read, ast_write, ast_channel_nativeformats

Required no code changes to legacy useres

### Legacy Video Support

Calling between devices (if video is in the initial offer)

Basic video recording

Basic video playback

Conference with single video sent to each participant

### Bridging

Currently two bridging modules support multistream:

Simple

Softmix (What confbridge uses)

Other bridge modules, e.g. bridge_native_rtp, unchanged and behave the same

### How Simple Bridging Now Works

Channel with fewer stream renegotiated to match other

IF same number then second channel joined gets renegotiated to match first channel that joines

Each stream is mapped 1 to 1

Acts as media forwarder based on stream number

### Softmix additions

Multiple video streams can now be sent to participants (SFU)

### SFU

Selective forwarding Unit

Picks a subset of video streams to forward

Currently limited by max number of video streams on channel

No server side transcoding or manipulation is done

In the future, additional policy choices will probably exist.

### How Softmix Now Works

Each video stream on a channel is mapped to a bridge specific stream number

Each channel can have a mappping from bridge specific stream number to channel video stream

Audio is still mixed server side to provide same ConfBridge audio experience as previously

Enabled using video_mode=sfu in ConfBridge

### WebRTC

Quick implementation

Best option for rich ConfBridge SFU experience

### BUNDLE

 

Required for Google Chrome to support multiple streams due to Plan B usage

Specification to allow multiple streams to be sent/received over the same transport

Cuts down on ICE and DTLS negotiation time

Now available in PJSIP

### CyberMegaPhone

Limited example code available (is on Github, MIT license)

Uses HTML and Javascript

JsSIP based client for use with Asterisk

Adds/removes video as participants join/leave conference

Controls to mute/unmute

Firefox and Chrome supported on desktop

### Potential VIdeo Support Additions

Adding/removing video mid-call

Better video recording (into containers)  and playback (with multiple streams)

Feedback allowing video quality to change due to bandwidth change

Better handling of packet loss and out of order packets

### Putting it All Together

…(notes not compiled for this segment)

  


(A demo of CyberMegaPhone was done.)

  


Now, it’s time for planning the Agenda.

  


Agenda:
-------

 

* Prepared Presentations:
	+ Talk by Wazo
	+ Talk by Ludovic
	+ Talk by Daniel
* Discussion by Nir
* Proposed deprecation of `app_macro`


	+ `Gosub has existed for 12 years now and is suitable replacement, but not 100% compatible.`
	
	
		- `You exit a Macro by using Goto to any different context.`
		- `You normally exit a Gosub using the Return app which sends control back to the n+1 priority that originally called Gosub.`
		- `A Gosub return address can be thrown out using "StackPop", then you can use Goto with any context.`
	+ `Documentation for the Dial app would be simpler if the Macro option were excluded.`
	+ `Macro adds some code/complexity to the pbx core and a few apps.`
* Proposed deprecation of `chan_sip`
	+ Feature Parity - What features are available in `chan_sip` that are not available in `chan_pjsip` and what is the level of effort to get us there
		- CCSS is missing
		- AOC is missing
		- Outbound SUBSCRIBE is missing
	+ Configuration - `sip.conf` vs. `pjsip.conf` vs. `pjsip_wizard.conf` vs. `contrib/scripts/sip_to_pjsip`
		- `Can we make chan_pjsip read sip.conf directly?`
	+ Stability - Both actual and perceived
	+ Performance - Both actual and perceived
	+ Outside Forces - Is there a business case for keeping `chan_sip` around?
	+ Leaving it around misrepresents its support status to people within the community (no current maintainer for chan_sip)
	+ Proposed deprecation plan:
		- Gain feature parity (16 ?)
		- Give warning on load (Wait until feature parity question is resolved - maybe into 15.x.0?)
		- Give warning on call start (maybe 17?)
		- noload in modules.conf/remove from default menuselect enabled modules (maybe 16?)
		- Kill it with fire
* How do we get to an all ARI solution?
	+ pbx_ari
	+ Can we have ARI be more system aware (subscribe to all channels) instead of channel aware
		- There's already a parameter that causes your ARI application to receive all events on the system.
* Getting features from 14 into an LTS.
* What's the next revolution of Asterisk?
* How to improve functions in ARI to make it more of a first class citizen?


	+ Setting variables on a bridge (Sylvain and Torrey +1 this)
	+ Set or Get multiple variables on a channel
	+ List global variables
	+ No variables when a channel is hung up (perhaps some sort of race condition)
	+ ARI way to administratively convert a channel to stasis (from dialplan)
* Documentation:
	+ Organization
		- Required content sections
		- Dealing with Asterisk version differences
	+ Contributions
		- Peer reviewed before publish?
		- Ease of contributing
	+ Autogenerated content
		- Integration with edited wiki content

Now Wazo

  


### AMQP and the Stasis Message Bus

Why?

Remove direct connection to AMI (no parsin)

And use AJAM to send actions to AMI

Scale (aoto)

<https://github.com/sboily/asterisk-consul-module>

Remove external proxy for ARI

<https://github.com/invisibleinc/go-ari-proxy>

We already talked about this feature at the last AstriDevCon

  


### Res_amqp

AMQP client for Asterisk

* Only publish

Based on patch from <https://reviewboard.asterisk.org/r/4365>

Extracted version to have a first asterisk patch

 <https://github.com/wazo-pbx/wazo-res-amqp>

Based on librabbitmq

 We only test with rabbitmq

Configuration is on /etc/asterisk/amqp.conf

It doesn’t nothing, only an AMQP connection

To install

 Git clone; make; make install

  


### Res_stasis_amqp

Publish stasis message to AMQP

 <https://github.com/wazo-pbx/wazo-res-stasis-amqp>

Support

 Stasis AMI

 Stasis ARI

 Stasis Channel

Depends on res_amqp

Configuration /etc/asterisk/res_stasis_amqp.conf

To install:

 Git clone; make; make install

To test on your Asterisk and get messages

 <https://github.com/wazo-pbx/xivo-tools/blog/master/scripts/recv-bus-event>

 Adapt the exchange on the script

  


Allows you to subscribe on specific events, e.g. just the status of a Queue.

  


### Demo TIme!

Integration in Asterisk

Proposal

 Submit to gerrit the res_amqp support

 Submit to gerrit the res-stasis-amqp support

Roadmap

 Functional test

 CEL? 

 CDR?

 Your feedback is welcome!

  


(Some discussion on why the original patches weren’t merged (lack of tests in the CEL and CDR modules) and about where this would end up if it was merged (16 if no tests, or 13 if tests).)

  


Now, Ludovic to talk about res_calendar!

  


### Asterisk and the calendars, when non-C developers meet Asterisk+libical

  


#### Who am I?

Creator of API-House (Daemon framework for Python-AsyncIO)

Creation or aiosip (used by Sangoma to test their phones)

Co-maintainer of Panoramisk (Asterisk binding for AsyncIO)

Small contributor in several AsyncIO libraries (aiohttp…)

Interested by benchmarks to find the bottlenecks

Contributor of <https://www.techempower.com/benchmarks>

  


#### ALLOcloud

Most simple as possible

Distributed telephony and collaboration

Efficiency is the first class citizen (1500+ simultaneous calls by server)

  


#### Eyepea

Full-monty customized solutions

Solutions mainly based on Wazo

Historical business of the company

  


#### Customer needs:

Open/close schedule

Personal calendar

Oncall schedule

Google Calendar/Office365 integrations

  


#### There are two steps:

Step 1, define a calendar.

Step 2, put the calendar in the callflow

  


#### What now?  Icalendar is the most obvious format.

It’s used in a lot of products.

It’s a stable standard

And it’s very old; more chances that there are good implementations

But not really...old != stable.

  


First, they wrote an implementation using icalendar in Python

It was easy to debug and integrate.

But, libical integration in Asterisk looked like a Proof of Concept during an Astricon.

Very few messages from people using it on the Internet

Lack of examples

Need to dig in the original Astricon presentation to understand how to use the diaplan functions.

And, crashes.

  


(they’re not C-developers)

First client?  Crashed immediately.

  


The first challenge: recurrency; something very common with calendar events.

Most libraries parse recurrency fields, but most don’t interpret correctly recurrency data.

  


 They tested lots of libraries, but libical works best.

  


Plan B: libical integration in Asterisk

They put it into production, and it worked!

  


But..then comes the daylight savings time in winter and everything’s going to be thrown for a loop.

  


Libcal has bugs with timezone and DST.

But they’re fixed in libical3

But, libical1 and libical forks are widely distributed.

Libical3 isn’t released and available in Debian or CentOS.

So, they had to import it manually from libical master branch.

  


One more bug remains...editing of a recurring event, recurrence-id.

A fix was submitted on Gerrit: ASTERISK-27296 / <https://gerrit.asterisk.org/#/c/6625/>

  


For now, they have 973 calendars in production.

Right now, there is no file system support for res_calendar..working on a patch but it has memory leaks.

Might do python bindings for libical.

  


Lunch!

  


### Next, Daniel will talk about SIP Proxy Router and Media Server PBX; Integrate, Interconnect, Innovate.

  


There are things that aren’t yet possible, but we worry about how to make things easier.

  


#### Integrate:

 We could integrate log formatting, and have a common prefix for easy correlation, callid, cseq, etc.

 It would improve troubleshooting and unit testing.

  


 We could integrate user profile and database structure

 That’d give us unified user authentication, user location, and presence.

  


#### Interconnect:

 We need ad-hoc and realtime propogation of information (by headers) so that we don’t have to always worry about having replicated state across nodes.

  This would be done in the forwarded/generated request/response.

 Examples:

  Retransmission timeouts

  Next hop address (route)

  Location/presence states

 ...so that we can make configuration easier on people.  People can forget to make changes in two places and have negative results today.

 Could be done via templates that respect special headers that are sent in the signaling.  Templates indicate what sorts of parameters to apply to the call/endpoint.

  


#### Innovate

 Don’t always wait for specifications between all parties - IETF, ITU, ETSI, etc.

 Collaborate with others to define new features and services, like the XMPP model

 Amend, or go around existing specs

  Avoid useless roundtrips

  Why not allow dynamic new server nodes, because you can’t predict their IPs always (Amazon, for example) that are authenticated via an API key that’s a shared secret between server apps?  It’s better than IP and digest-based authentication.

 Optimize for mobile and IoT

  Get rid of “not needed” headers

  Use a server-side app to fetch data, like for hard phones.

 Security and Privacy

 Auto-provisioning of end points/cpe

 Federation and open peering.  There’s a lot of FUD out there that suggests SIP isn’t designed for federation.  But, if we don’t have a trust model that people will use, then they won’t interconnect, because they’re afraid of bad calls.

  


(Discussion about Asterisk’s existing, new capability to a allow identification of an incoming request by token, as well as discussion around how to pass a SIP call identifier around the internals of Asterisk - today, you can’t.)

  


(Discussion about the upcoming implementations of SHAKEN/STIR that are going to be mandated on many carriers.)

  


(Summary of discussion: It would be good to see work in the area of authentication between services.)

  


What about knowing what pool of servers is available?  DNS is currently used, for round-robin environments. What’s the right way in Kamailio though to make it intelligently aware there has been an expansion or contraction of a pool of available media (Asterisk) servers?

  


Kamailio has a module called RTJSON that allows pushing JSON into Kamailio to tell it about new routes.

  


(More discussion of the sharing of state and the dangers of replication - you’re only as good as your weakest server.)

  
  


### Now...Nir!

  


#### Make our community greater.

Wanted to talk about deployments and containers, but that shouldn’t be the topic.  Instead, we need to talk about our community.

We write good code (or phenomenal bugs)

We write good tests (or at least we want to believe it)

But, we suck at...providing proper documentation.  Most of it isn’t updated.

We also suck at providing best practices; people are still making the same, old stupid mistakes.

Now, Nir spends his time writing product specs, but still finds that he’s not doing a good job of providing documentation.

Training has actually gotten better in the latest syllabus, so that’s good.

Concrete examples of doing things don’t exist.

Who’s willing to sit for a documentation hackathon?  Dialplan, for example, is documented to death, but it’s not documented well enough.

Why aren’t people using it enough?  It’s probably documentation.

How do we change the state?

  


Kamailio has moved to accepting markdown.  ARI in Asterisk is Swagger, so there’s no markdown.  The docs in Asterisk are in the code in XML and aren’t in a good position to include lots of formatting.

Kamailio, like Asterisk, isn’t missing reference documentation, just examples.

There should be templates for various types of articles: HOWTO, Advanced Guide, Beginner Guide, etc.

Finding information in the Wiki is challenging.

There’s no formal way to make a pull request into the Asterisk repo on Github.

Sometimes, while people are happy to contribute code, because it’s a burden to maintain it, they’re not happy to contribute extensive documentation.  How do you get people to contribute, where you’re not paying full-time documentors?

Post-DevCon discussion to be had at the Wine event.

  


### Now, the afternoon topics (at 3:30pm)...

  


#### Proposed deprecation of app_macro

 Gosub has existed for 12 years now and is a suitable replacement, but not 100% compatible.

 You exit a Macro by using Goto to any different context

 You normally exit a Gosub using the REturn app which sends control bck to the n+1 priority that originally called Gosub.

 A Gosub return address can be thrown out using “StackPop,” then you can use Goto with any context.

 Documentation for the DIal app would be simpler if the Macro option were excluded.

 Macro adds some code/complexity to the pbx core and a few apps.

  


 (Room is in general consensus that it should be proposed.)

  


#### Proposed deprecation of chan_sip

 Feature Parity - What features are available in chan_sip that are not available in chan_pjsip and what is the level of effort to get us there?

 Configuration - sip.conf vs. pjsip.conf vs. pjsip_wizard.conf vs. contrib/scripts/sip_to_pjsip

 Stability - Both actual and perceived

 Performance- Both actual and perceived

 Outside Forces - Is there a business case for keeping chan_sip around?

  


What 3 features are missing?  CCSS, AOC and outbound Subscriptions.  The only one that still gets used is CCSS.  Asterisk maintains support for CCSS in the core, and pjproject has the necessary bits to handle it; someone just has to tie them together.

  


What about stability?  The FreePBX community has a large thread with users indicating issues with PJSIP that they don’t experience with chan_sip, but no one is filing bugs or presenting actual issues - it appears to be primarily anecdotal.

  


Is it already defacto deprecated since it’s in extended support and there is no community maintainer?  And, are we being setup for something bad by not making it more clear.

  


What about configuration?  The converter isn’t necessarily feature complete; but is written in Python (hint, non-C developers)  There’s built-in help in Asterisk’s CLI (config show help [res_pjsip_endpoint.so](http://res_pjsip_endpoint.so), for example).  Is it worthwhile to make PJSIP read sip.conf?  (There are problems here as a friend and a peer are different and if you move that to PJSIP under the hood you can end up with weird configuration or vulnerability issues)

  


We need a plan of attack.  Something in 15 (warning on startup, something else in 16 (noload it and unselect it in menuconfig), and deprecate it in 18.  All deprecated modules should probably have a warning on startup.  When fully booted list all modules that are deprecated.

  


#### How do we get to an all ARI solution?

 Pbx_ari?

 Worry that users could get themselves into trouble here, because their ARI apps could get into trouble.

 Counterpoint against this request is that this can be accomplished with just 3 lines of dialplan - use this Stasis app, vs. pre-setting the ARI app in ari.conf.

 Proposal to set stasis=xyz on an endpoint so that an incoming call to an endpoint goes straight to a Stasis app.  The room really likes this proposal.

 But with a pbx_ari you can just map a dialplan context to a Stasis app.

 How can an ARI app know more than just what’s in its own app?  “Subscribe all” when connecting the web socket.

 

#### Getting features from 14 into an LTS.

Discussion about the implications of 15 as a Standard release instead of an LTS.

  


#### What’s the next revolution of Asterisk?

 There’s going to be a continued focus on video.

 There’s going to be less of a focus on Asterisk as a PBX, and a continued focus on Asterisk as a general purpose media application server, which might be a PBX by the time a developer delivers it to an end user, but might be more like a call center, but could be something else entirely.

  


#### How to improve functions in ARI to make it more of a first class citizen?

 Setting variables on a bridge

 Set or get multiple variables on a channel

 List global variables

 No variables when a channel is hungup

 Easily redirect a channel into Stasis

 

  


#### Should Asterisk be packaged up as a ready-made app for certain purposes?

(Discussion that this is complex and not best served by the core development team)

### Closing

Everyone's work is appreciated! Thanks for coming!

