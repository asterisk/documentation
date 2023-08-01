---
title: Minutes
pageid: 41451707
---

Opening Matt Fredrickson - asterisk project lead

we want to make sure to thank you by having a lunch that is catered, there is some drinks & breakfasts available.  
  
so lots of ways to prevent your blood suagar from dropping

thanks for E4 stratiges for lunch that helps us a lot

also of note we are ending at 15h, that is atypical due to conflicting obligations like a panel  
Eric - when will pictures happen  
Answer - we will wait until lunchtime

lunch is in the national ballroom B (accross the way)

We do have a speakerphone available & a wireless network called asteriskdevcon that should be more reliable than the astricon wifi  
  
Password is the same digium18  
Also want to thank Torrey for taking notes day and George for setting up streaming for those who cannot participate onsite.   The development process is bigger than any one room  
  
Introductions:

* Matt Fredrickson - sangoma
* Torrey Searle - Voxbone
* Malcom Davenport - digium - product manager - here for free food
* Jared Smith - digium
* Christophe Durieux - connect with the community
* Claude Paltry - jive
* Jroan Vinzens- sipgate - bulding a new infrastructure in ast16 with ari
* david duffet - digium - observing
* fred posner - lod - interestin in the future of asterisk
* Ludovic gasc - allo cloud -belgium - interested in ari
* pascal cadotte - wazzo - in quebec in future development esp ari
* evan boily - wazzo - hope next astricon will be in canada - interested in futre of asterisk
* Igor Goncharovskiy - russia - IQTek unistim developer
* Nir Simovitch - isreal - clodonix - uncarrier - here for fun
* Eric Klein - clondonix - sponsoring dangerous demos
* Lenz Dimitiri - lowe in switserland
* Sean McCord - psycore systems - atlanta
* Dan Jenkins - nimble ape UK - here to be quiet
* andrew naggy - socal - sangoma
* james benstrup - writes bugs for freepbx
* brian walters - sangoma - buffalo ny - interested in future of asterisk
* Jason Parker - atlanta -sangoma - work on phones for sangoma
* Dan Collins - usan - knoxville TN
* Paulo Vicentini - Brazil - Voxbone - help with ast13 rollout
* Steve Murphy - next vortex - wyoming -
* Peter Weschke - see where asterisk is going with ari
* harrison schults - corona - indianapolis
* john harden
* alex goodman - corona
* Ben Ford - digium - working on ast for 1 year
* Kevin Harwell - alabama - digium - getting feedback
* Alexander Traud - frankfurt germany - unemploied - used ast for 6 years
* George Joseph - digium developer

  
  
  
  
What ever direction you like to see asterisk is within your power.    
What has happened in this last year:  
asterisk 15.x 6 bug fix releases, current is 15.6.1  
asterisk 14 8 security releases last version is 14.7.7  
asterisk 13.x 6 bug fix releases current 13.23.1  
  
  
3300 merged code reviews (across all branches)  
  
it is amazing the number of contributions, that is a pretty amazing number  
that is also means alot of eyeballs, people helping wiht review is strongly encouraged, there are alot of patches pending review a long time because of lack of reviews  
  
  
1000 commits on asterisk 16 (close 3 per day) 72 individual contributing  
asterisk 16 as been released! it has been in feature freeze already for a while.  if you haven't tested it yet, then well patches welcome   
  
Top contributor  
260 Corey Farrel  
  
Standard release vs LTS  
  
something happened last here that broke convention, that made some people angry  
  
in asterisk land we have 2 categories of releases, one is the standard release and the other is the magic LTS  
  
alot of people feel confort in LTS, we decided in lots of caution due to the lots of changes in ast 15 especially ref multi-stream support   
we decided not to make 15 an tls, which broke lots of conventions. On the other hand the changes were supprisingly stable.  they maintained compatiblity with most of the applicaiton interfaces  
  
  
Standard release  
1 year bug fix, 1 year security fix  
  
LTS   
4 year bug fix, 1 year security fix  
  
additionaly we have a new branch inclusion policy.  new features can be put into an existing branch so long as there are tested and are non-major nor breaking changes  
  
  
that allowed us to alot of neat things with that especially in branch 13, and it helps other branches because all those tests can get moved to the other branches as well  
  
it has been a few years since the last LTS.  16 will be an lts, will be around until 2022, and security fixes til 2023  
  
What's new in 16?

Webrtc video   
webrtc api   
chan_pjsip performance  
misc fun

Improving video resilance

* sensitive to packet loss
* a loss of a single frame - strange things happen
* in ast 15 we took a sledge happer approach, if we detected packet loss we requested a full new video frame, (sending an entire video frame uncompressed, -very wasteful)
* we knew there were some better tech, but didn't have time to use them
* one tech is NACK - an RTCP control message
	+ rtcp is the protocol used in accompanment of rtp, sends statistics
	+ the decided to extend rtcp to do other things to allow other things, including NACK
	+ it is a negative acknowledgement
	+ so if a packet is lost, you send a nack to inform of the lost packet and sender will retransmit, allowing stream repair  
	  
	  
	Remb
* bandwith estimation
* informs of sender of bandwith limitaitons (I only detect 1.5mb of video, please limit)
* instant packet repair problem
* negotiated in sdp (nack is as well)



Enhanced Messaging:  
Backround - updated all apis to have multiple audio/video streams  
last year it looked like people in boxes ( it was a really big deal)  
there is some metadata, local video description, remote video description  
  
how on earth do I figure out that is kevin karwell and write in on his box  
we added an api to correlate callerid streams with participant metadata  
additionally we thought it would be good to add participant to participant messaging to confbridge  
allows a one stop shop solution, or to keep messaging close the the media path  
uses in-dialog sip MESSAGE, you can set the content type, but only use UTF-8  
  


George did alot of work on the conference bridge, don't want to take away his thunder  
  
PJSIP performace improvements  
good talk ref chan_sip vs pjsip last year, large attendence room was packed.  in alot of cases chan_pjsip performed better, but some cases it did not  
however not a considerable difference, but we still wanted to address them  
  
approx 7% in cpu usage worse in reg handling  
after some perfomance improvements we now have chan_pjsip perform better than chan_sip, 2k req/s for chan_pjsip vs 300 for chan_sip  
  
Misc fun  
build improvements: DragonFly BSD, NetBSD, OpenBSD, Solaris 11, FreeBSD  
  
I'm a linux guy so I always fall into the trap of thinking that Linux is the only \*nix out there, but Alexander Traud contributed alot for building for other platforms  
  
IPV6 added for Dundi  
Does anybody use Dundi? (not that you shouldn't be useing it but it often gets forgoten about)  
  
  
pjproject updated to v2.8  
ability to bundle build libjansson, some versions of jansson have bugs, so bundling helps  
misc gccc bug fixes  
enhanced messaging with app_sendtext  
new databuffer api added to the internal core api of asterisk, allows to do things like packet retransmisison buffers

early media video support in app_dial  
  
  


python3 compatibility fixes - test suite is largely written in python, and different supporiting scripts

if you are a python developer we would love to see some help in reviewing those scripts to geting them compatible with python 3  
sean bright worked on ephemeral DTLS certificates saves alot of pain of cert generation

support for a new cdr backend called beanstalk, developed by Nir

started looking into performance bottlenecks in stasis message buss, (it's a pubsub message buss)

improvements to strictrtp - the way we live in a world that is outside the standards of the RFCs, nat is a reality and part of the challenges are that, in sdp there is an address it expects to recieve media on.  In order to work in that world you have to believe that address.  If the other end is a private ip address that isn't true.  some of the things that are done are symmetricip, where asterisk sends rtp back to the same address it recieved on, this is all find, but it has to trust the rtp stream is the right stream.  But this can lead to hijacking of rtp streams.  
  
  
Strict rtp is on by default, prevents of rtp hijacking can't happen, it may cause limitations when lots of video streams are happening, or crappy networks that send packets in big clumps, that presented problems in strictrtp, some improvements were added to make that better.   
  
  
Reminder ast14 went EOL a couple weeks ago.  Ast15 graduated to security fixes only mode.  Keep track of what's happening in non-lts major releases of asterisk.  
keep a test environment with non-lts releases to avoid supprises,  
  
ast17 is presumably a standard relase so good opportunity to start breaking things  
  
  
Questions:

when shall we see 16?  
Answer:

right now! downloads.asterisk.org is up

  
Agenda for today  
Presentation by George Joseph and Kevin Karwell about performance enhancements in 16 (30 min)

presentation of Ben Ford (originally Josh Colp presentation) about new video improvements (30 min)

Luch 12-1

Discussions





George Joseph | kevin Harwell presentation presentation:  
  
Asterisk 2018 Performance Update

Matt gave a preview this morning but we are going to go in more detail

all of us would define performance a bit different as we have different usage patters & network environments and introducing their own deifintion of performance

so it is hard to define performance and what it means to improve it.  CPU? CPS? memory? disk io?

where do improvements come from?

every release have performance improvements, some from community, some from core.  even minor releases have perf improvements.  you should always check the changes file as some perf changes might have functional implications too

Key improvements:



rmudgett spent a good amount of time with CDRs to reduce the time and resources to process it. 

it doesn't really impact cps or quality, so do we care? yes, it takes reasources away from those other things.

stasis is another area, it's our internal pubsub buss.  over the last 1.5 months we have done alot of work to reduce the overhead. one of the areas we discovered was that app_voicemail when you start it, and you have holding turned on, app_voicemail wants to know which mailboxes currently have subscribers so it only polls the mailboxes with subscribers.

most people don't have that turned on, collected via stasis, and in order to do that stasis had to keep track of every mailbox, it had to also have to keep track of the message flowing on the buss & never flushed cached.  even if you didn't have polling turned on then you had alot of memory growth, which in turned caused cpu growth.  all for app_voicemail.  We cut that out, resulting in significat memory & cpu reduction



qualify & options, alot of attention this last year, one issue especially with realtime db, the time it takes to iterate contacts, to find which ones need to have qualify, and also write it back.  lots of startup overhead.  similarly inbound reistrations are the same way.  Very read/write dependent.  if you have thousands of aors and you are building up this db of contacts it can get really slow.  pjsip show contacts is forced to go back to the database just to show it on the console  
  
kevin will show some results now:

the thing we mainly focused on was cpu utilization, but you will also see some slides about memory

CDRs -30% increase in record processing, thanks richard

stasis cache - before memory climbing, after cpu is stablized and memory too

pjsip contacts

prior to 13.21.0

poor load and reload time, low reg/s

asterisk 13.21.0

improved registrations per second  
asterisk 13.22.0 and after

context re-write patch had the biggest effect for improving performance

reloading contacts now take less than a second



Inbound registrations

pjsip channel was kind of lacking on registration perfomance (as mentioned last year) we took that seriously

setup: 1. socket 2 core 2 threads per core i3-2330 cpu 2.20GHZ (cpu will be averaged across all cpus)

regs are written to a database

we only loaded the modules required for the test (only loaded registration module)

4000 endpoints

we used sipp scenario to over local network

res_pjsip uses 7-8% more cpu than chan_sip, not many retransmissions

13.23.0 now uses less cpu than chan_sip for registration traffic (1-2% less cpu usage)

asterisk 16.1.0

cpu has dropped even more (3% less cpu than chan sip) mem use dropped by 3-4 mb

chan_sip can safely handle 300req/s but will choke on retransmisisons after

res_pjsip can easily handle that & much more, here you can see it easily handle 2k reg/s, at 2.5k/s retransmissions did climb a bit, but still ok

in the latest version of asterisk should see more improvements, some will be shipped in 16.1, be sure to test

testing is a huge part, so please let us know what you find (patches are welcome too)

Questions?

which format do you write cdrs in, can you specify the format?

answer: we don't have a json formatter for cdrs yet

answer: we have different backens, e.g. database, adding a json backend should be easy to add

answer: improvements should be across the board regardless of the backend tech

question: what was the motivation of performace evaluation

answer: there was a presentation last year that did a comparison of chan_sip vs chan_pjsip

answer: there should be a blogpost with a link to the tests

question: in the presentaiton ref performace, there was also a performance hit ref concurrent calls

answer: concurrent calls depends on media processing, chan_pjsip and chan_sip share the same underlaying media processing, so we confused by that and have no idea how to test that

answer: the delta between the two was only 1-2 concurrent call difference, so we were looking for more extreme differences that

answer: if anything could make the difference, it could be memory as pjsip does use more memory

answer: don't have any data-points but I found that chan_pjsip can handle more concurrent calls than chan_sip

answer: found a performance difference between 1.4 and 1.6 and it came down to a one line change ref DNS, there should be more performance tests on a regular basis

answer: yes, we are attempting to focus more on performance, we can def use more feedback, especially on what things we should test, indeed DNS can make a huge difference



Ben Ford  
How not to trust the quality of the internet

Shattering the illusion some have that the traffic on the internet always get from point A to point B



today we will talk about media improvements particularly ref video

I'm not josh & don't have his knowlege, send him or me questions [bford@digium.com](mailto:bford@digium.com)

Overview:

patchy networks cause packet loss, which causes awful video experience

we are going to talk about how REMB & NACK work within asterisk w some demos



packet loss causes:

routing options - sub-obtimal routing (it may go via california)

network congestion - some packets won't get there

some packets may end up out of order



this hurts communicaiton if you are missing packets then you are obviosuly going to get (more apparent in video)

video freezes, or video stops

audio just gets choppy or "wonky" sounding

webrtc has tech to help video REMB & nack

What is remb?

remote estimated max bitrate

what this does is poll all the users of a call and find the bandwith of each user individually

it applys to all media streams

it can change throughout the lifetime of a call - so things can change during the call

it can control the video encoding bitrate of the sender, telling the sender the range we can expect/allow

supported in webrtc land



how does remb work

each receiver going to calculate max bitrate, then send it to asteris

asterisk relays or generates it's own feedback message



REMB is just a first step, transportcc and tmmbr, not widely supported though, foundation is in place to add later



NACK is like a ACK but not really it's a negative acknowledgement

it is a message when you do not get something you expect, eg report a lost packet

can be used to trigger retransmission & counter the effects of packet loss

works on a per-stream basis

no guarantee to get all lost packets back, (you may loose the packets again)



how does nack work?

ingresss -store packets in a buffer, so we can resend if needed

egress - if we recieve a packet we are expecting process it

otherwise store it, any missing packets then send a NACK request

when buffer reaches 1/2 size we send a nack to get the missing packets



if we get packets out of order, we store them, it's possible for the missing packet to still come late, if it does we process it, then get any subsequent packets from the buffer



conference bridges behave differently for remb than for 1 on 1

we provde a way to combine reports, we do that by adding options

avg max and min bitrate

depending on which reports we receive we send either lower/highets/avg we receive to the other participants



it's possible to receive nack request from multiple participants asterisk needs to determine which stream it belongs to



Discussions:

* Have discussion about proposing that chan_sip be marked deprecated

Torrey brings up the point that chan_sip should be no-loaded by default.  PJSIP users often have to nuke chan_sip just to use PJSIP.  
Dan brings up the point that the plan for chan_sip (warnings on startup, no-load in 16) didn't happen.  Dan also suggests no-loading chan_sip in SuperAwesome Company.  
Jason suggests that even though 16.0 doesn't have the warnings; we should add them anyway.  MattF disagrees and doesn't think we should make the change, given that 16 exists.  
Fred points out that warnings should be noisy in the logs - not just errors.  
A point was made that there still are some gaps in capability.  MattF's rebuttal is that those capabilities are ones that are lightly used and the user community hasn't ported them forward for years.  
Alexander makes the point that forcing users to move by no-loading or making it harder to use chan_sip, could result in user exodus.  He also makes the point that it is good to ensure people don't end up on a channel driver that isn't well-supported.

* res_xmpp/chan_motif should they remain core supported (due to dependency on unmaintained libraries)

Corey notes that the last commit on the supporting library is 2011, and it isn't even packaged in Fedora.  
Jared seconds.  
No dissent.

* Discuss deprecation/removal of res_monitor

Torrey wants to know what replaces res_monitor.  chan_spy replaces res_monitor.  
Corey prefers mixmonitor because it uses framehooks; monitor requires separate core code (and doesn't use framehooks).  
No dissent.

* Discussion around removal of macro functionality

macro is long-deprecated.

* Opportunistic DTLS

Torrey uses Kamailio.  Kamailio is one endpoint.  He'd like to have one endpoint configuration that'd work for both.  Most things work except for use_received_transport.  The outbound leg doesn't work, but may not be as necessary.  
A patch had been submitted but was rejected. <https://gerrit.asterisk.org/#/c/asterisk/+/10245/>  
Discussion will resume on the mailing list.

* Making it easier to send audio to/from Amazon, Google, IBM (especially in context of speech recognition)

Dan prefers not putting audio on the machine itself when his ARI apps are themselves, remote.  It'd be nice to have an HTTP endpoint way to get one or both sides of the media stream for a call and relay them somewhere else.  In particular, Dan's looking to push that audio out to a remote speech API.  
Sean references (GRPC) as a means for sending audio.  He has similar needs to Dan and built something called app_audiosocket, that directs a call over a TCP socket to anywhere; sends audio (SLIN) + metadata and receives audio back.  It solved his problem and he'll hopefully demo it tomorrow.  He pipes it to Google or to a websocket connection for manipulation.  It's a better solution than app_jack, which is only local, and UniMRCP.  
Sean and Dan want a way to use ARI to control where the audio is being sent to and received from.  ASR, TTS, audio manipulations.  
George - so a REST endpoint that allows you to specify the channel, a hostname, and a port.  
Sean's app does the work, but it's not callable via ARI.  
Ivan wants the feature callable not only by ARI, but also via Dialplan.  He's familiar with chan_rtp, but it's hard to use for his purposes.  
Matt - big picture, the capabilities today aren't enough to handle these requests in chan_rtp.  
Dan points out that other projects handle this with individual modules for individual services.

* Getting access to end of call statistics (regardless of who hangs up first)

Torrey wants SRTP stats at the end of a call, or put (in the hangup handler) what codecs were negotiated, or whether SRTP was negotiated, or query the channel for details in order to drop them into billing information, or find out if T.38 was negotiated to see if it was a fax call.  But, there's no, currently, safe way to access that information after the channel is hung up.  He's tried to copy details from the A-leg to the B-leg, but there's not a good way to guarantee the information's lifetime by the time the channel in invoked.  
Matt - some of this, e.g. T.38 events, might be contained in CEL and be able to pump that externally.  
Steve - Where would this information be stored?  Once the channel is gone, it's gone.  CEL was created to generate the information about a call as it traverses and is the right place for this, not CDRs.  
Torrey - could a

* Getting rid of extensions.conf for ARI applications

Missed notes for this section...

* Discussion around having Asterisk and some message queue/bus (like RabbitMQ) talk directly to each other

Torrey uses an ARI proxy and then puts it on an external message bus.  Torrey would like to get rid of the proxy.  
Dan wants to know if we can have an ARI proxy built into Asterisk; Torrey says "yes, that's what I'm wondering."  
Sylvain did a presentation about RabbitMQ and Stasis last year and has a module over on github.  Andrew has either looked at it our used it.  
Dan wants one way to do this.  
Jroan sees the need for some small glue code to make it simpler to use any message bus, not one in particular.  
Dan points out that this might be made easier if you could have more than one websocket connected for one app - instead of today's limitation of one socket for one app.  
There are some rumblings about Protocol Buffers and Swagger, etc.

* Alexander wants to talk about RTCP/media-interaction with audio codecs

Most people in the room have deployed Asterisk with Opus.  
Most of the room doesn't use Opus as a primary audio codec.  
Sean - most of the room is interested in it, but most of the room hasn't done it.  
Alexander just wanted to survey the room.

* Josh Elson wants to talk about task processor architecture limitations, e.g. the challenges of 50K sparsely registering endpoints.

They struggle with equal prioritization between taskprocessors and that one taskprocessor overflowing can cause badness for other items.  
Is there a good approach to handling this?  
A method of configuration might be helpful, but no such thing exists at this time.  CDRs and AMI are both problematic; ARI where poorly-written apps that don't respond at the TCP layer can bring down the whole system.



* Give Igor some time to talk about improvements for various applications in how you interact with multiple media streams.
* Discuss how Sangoma's acquisition of Digium affects the future of Asterisk

There's a Q&A about this in a few minutes in a different conference room.







