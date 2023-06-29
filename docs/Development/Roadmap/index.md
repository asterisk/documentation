---
title: Overview
pageid: 4259934
---

Roadmap Overview
================

The roadmap for the Asterisk project is discussed at [AstriDevCon 2019](/Development/Roadmap/AstriDevCon-2019) each year at the annual Asterisk User Conference, [AstriCon](http://www.asterisk.org/community/astricon-user-conference). During AstriDevCon, the Asterisk Developer Community:

* Discusses the development efforts of the previous year and reviews the status of the project
* Works as a community to set priorities for the project for the next year
* Coordinates development efforts between groups

The goals for the project are subject to the constraints of the next major version to be developed. Asterisk has a [rotating release schedule](/About-the-Project/Asterisk-Versions) between [Standard Releases and Long Term Support (LTS) Releases](/Development/Policies-and-Procedures/Software-Configuration-Management-Policies); as such, the development focus for a Standard Release will often be very different than for a LTS Release. Sub-pages off this page include past AstriDevCon notes as well as project plans for projects chosen at AstriDevCon.

Asterisk 14 Roadmap
===================

While the planning for Asterisk 14 will take place on the development mailing lists ([asterisk-dev](http://lists.digium.com/mailman/listinfo/asterisk-dev) and [asterisk-app-dev](http://lists.digium.com/cgi-bin/mailman/listinfo/asterisk-app-dev)), at [AstriDevCon 2014](/Development/Roadmap/AstriDevCon-2013), the community decided to focus on the following items:

1. Move the project to Git, improve the project infrastructure, and provide clearer instructions and/or processes to make it easier for developers to submit patches and participate.
2. Document features better and make it easier to install, configure, and deploy Asterisk.
3. Improve Asterisk into acting more as a media applications server. This has implications for scalability as well as for major improvements in ARI.

For more information, see the [Asterisk 14 Projects](/Asterisk-14-Projects) page.

Past Asterisk Versions
======================

### Asterisk 13

As the first LTS release of Asterisk based on the new architecture provided by Asterisk 12, the goals for Asterisk 13 were to:

* Refine the architecture afforded by Asterisk 12 such that Asterisk 13 is a proper LTS release
* Enhance and extend the SIP functionality afforded by the new PJSIP stack
* Make ARI feature complete for its initial purpose such that applications such as Queue and VoiceMail can be created by external application developers

### Asterisk 12

* New SIP stack and channel driver based on pjproject (chan_pjsip)
* Revamped Bridging core to support new APIs
* New infrastructure to support consistent APIs
* New RESTful API - ARI

### Asterisk 11

* Initial WebRTC support
* Usability features (hangup handlers, pre-dial, hangup cause)
* PresenceState
* New XMPP Channel Driver (chan_motif)

### Asterisk 10

* New internal media architecture and handling
* New ConfBridge
* Fax Gateway

### Asterisk 1.8

* Call Completion Supplementary Services (CCSS)
* SRTP
* Advice of Charge (AoC)
* CEL
* Connected Party (COLP)

 

