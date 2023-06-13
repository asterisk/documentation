---
title: AstriDevCon 2010
pageid: 6979978
---

{numberedheadings}

{toc}

h1. Introduction

AstriDevCon 2010 was held on Friday, October 29th. It was held on the day following AstriCon at the same location. A group of active development community members met and discussed a number of topics, including:

\* Asterisk SCF Ideas
\* Asterisk 10 Ideas
\* Asterisk Test Framework Ideas
\* Asterisk Release Policy

h1. Asterisk SCF Ideas

The Asterisk SCF discussion kicked off the morning. The topics that were covered included:

- VMWare/Etc. Image
- Channel driver
- ICE management tools.
- Queues
- Security, security, security
- Do we build the security functionality into the SCF code, or do we simply define best practices for securing an SCF system?

h1. Asterisk 10 Ideas

We spent probably half of the day discussing Asterisk 10. We came up with a list of development projects we'd like to get done and then prioritized them.

h2. (P0)

P0 are committed projects that are going to get done.

\* -[AST:T.38 Gateway]- (Digium)
\* -Performance of State Change Processing (Stefan Schmidt)-
\*\* -(work is already being done on this front)-
\* SIP path support (Olle)
\*\* (first generation of code exists, needs more work, simple patch, going to get it done, needs an extra field in astdb; helps when there are 2 or more load balancing proxies in front of asterisk, when you'd like the call to be able to get back to Asterisk; see https://reviewboard.asterisk.org/r/991/)
\*\* [https://issues.asterisk.org/view.php?id=18223]
\* Group variables (Kobaz)
\*\* (on review board, in progress)
\* Pre-Dial (Kobaz)
\*\* (practically done, or something)
\* Distributed extension state using SIP (Olle)
\*\* (resources in place, doing it, 1.4 done before Christmas, project pinana)
\* Manager event docs (Paul Belanger)
\* Cross-platform documentation (Ben Klang) 
\*\* (caveats for using Asterisk on operating system xyz; pull a PDF of the Wiki documentation into the source, don't forget to include basic installation information, and do it all in .txt - Ben)
\* Fix libs to optionally init OpenSSL (Digium)
\*\* (or use existing tools; sort of a bug)
\* Make ast\_channel an opaque type (Digium)

h2. (P1)

P1 is the highest priority.

\* -[Codecs (SILK, OPUS), Media Negotiation|AST:Media Overhaul]- (Digium)
\* RTCP (Olle)
\*\* Pinefrog; Work to be done - Ported to trunk, added to CEL
\* -Conferencing that supports a new magic media- (Digium)
\*\* -higher sampling rates-


h2. (P2)

- Async DNS (TCP DNS and use a good resolver)
- Named ACLs (deluxepine)
- [AST:SIP Security Events]
- Light weight means of holding NAT open in SIP (less complex than current qualify, Consider it done)
- IPv6 for the restivus (IAX, Jabber/XMPP/Gtalk, Manager, etc.)
- -ConfBridge feature complete with MeetMe-
- Support sound file containers (matroska)

h2. (P3)

\* Who hung up? (there's a branch, shouldn't take too much time - Olle)
\* Unique identifier for filtering log data to a call 
\*\* (finishing what was already begun w/ Clod's project, CLI filtering; should take a look at what Stephan from Unlimitel.ca's created)


h2. (P4, Simon's features)

\* Multiple SIP Sockets 
\*\* (Listen on multiple ports or on multiple interfaces, but not all; also set binding for RTP)...alternate idea / solution would be to make Asterisk capable of loading multiple SIP profiles, it might be easier
\* Multiple DNS results 
\*\* (need to be able to traverse a list of DNS results, rather than just getting back one result)
\* ICE-lite 
\*\* (no code, responding correctly to ICE connectivity checks (STUN multiplexed on the RTP port) and understanding the SDP); it makes NAT traversal work for clients that do ICE; also addressed lightweight NAT refresh)

h2. (P5)

\* -AstDB replacement- SQLite
\*\* (realtime, there's code, nearly ready)
\* SIP identity 
\*\* (on reviewboard; needs to be forward ported; important for organizations w/ federated identities; a requirement for DTLS SRTP; not widely deployed)
\* RTMP client channel driver


h2. (P6)

\* Structured identifiers for errors 
\*\* (tag an error message with a unique string, specific to the error message and where it came from; should be alphanumeric to keep them short)
\* AMI SetVar, Context limits 
\*\* (there's code already...Olle has it)
\* AMI filters on demand
\* DTLS SRTP
\*\* (not likely to be widely deployed in the next 12 months)


h2. (P7, not kobaz)

\* Asterisk register for XMPP account (Leif)
\* Write a Specification for AMI (not kobaz)
\* Multiple TLS server certs
\*\* (1 socket, requires support by OpenSSL; simpler to implement than multiple SIP profiles; don't know if any clients use it yet; needs more research)

h2. (P8, nice to have)

- Make resource modules that talk to DBs attempt reconnects
- Apple's new file streaming format, derived from .m3u
- Make MixMonitor and Monitor feature compatible


h2. (P?, Research Required)

\* New app\_queue (as if? no, seriously? talking about this scares Russell)
\* Identify and fix all bugs in AMI
\* Broadsoft or Dialog Info shared line appearance (SLA) support
\*\* (Tabled for later discussion)
\* LDAP from within the dialplan 
\*\* (we may already have it, needs research to see if the realtime driver does what's desired - Leif)
\* Device state normalization
\* Anything DB over HTTP(s) with failover handling
\* Use a channel as a MoH Source
\* Kill Masquerades
\* Bridging thread pool
\* Threadify chan\_sip
\* Export ISDN ROSE information up to Asterisk channels




h1. Testing Framework Ideas

We discussed the automated testing that has been built for Asterisk and discussed ideas for future improvements.

- Add Adhearsion
- Media Analysis (Quality)
- TestServer / TestClient
- Emulate phone-specific behavior
- Test $\{RESULT\} vars
- Check memory usage (for leaks)
- Custom statistics over time
- Automated load tests
- Valgrind integration
- Tone generation and analysis
- Broken dial strings
- Bad options to applications
- Make tests more generic so they can be toggled to run across multiple channels, or channel types, more easily
- Try to access features that are disallowed
- Test calls between versions of Asterisk
- Randomize call length and application during load testing - "Fuzzing"
- Automated crash analysis (generate backtraces and logs, etc)
- Testing against a SIP Proxy
- Non-root isolated test suite
- RFC4475 and RFC5118 tests (SIP Torture tests)
- More chan\_sip parsing unit tests
- SDP testing multiple media streaming
- protos SIP tester
- TAHI SIP tester for IPv6
- test SSL / TLS SIP connectivity
- Sound file I/O
- Manager events for scenarios
- Basic calls with all channel types
- Connected party ID
- Tonezone tests
- Language tests


h1. Release Policy Discussion

We discussed Asterisk release policy. Specifically, we were considering the current policy that excludes features from a release branch. After a bit of discussion, it was decided that no changes to policy would be made. We did agree that a new self contained module that was not compiled by default would be fine, but that it would be rare that it would provide benefit, since most projects are modifications of existing code. 

h1. Photos of attendees 

We rock.

!IMG\_4162.JPG|align=center,thumbnail!
!IMG\_4164.JPG|align=center,thumbnail!
!IMG\_4165.JPG|align=center,thumbnail!
!IMG\_4166.JPG|align=center,thumbnail!

{numberedheadings}