---
title: Overview
pageid: 21464254
---

### Items to research

* ##### Community

* Is the community active?
* Are they continually adding new functionality and fixing bugs?
* Can we get help from the community easily if need be?
* How often do they release new versions?
* Is there an easily accessible issue tracker?

* ##### Ease of use

* Can we easily interface with the API?
* Is it easy to add new things?
* If we distribute it, is it easy to work into our build system?
* Can a beginner pick up using it quickly?
* Can additions be made to the stack outside of it?

* ##### Feature richness

* Does it have the features our customers will want?
* Are new features being developed based on new RFCs?
* Do they include an SDP parser and generator?
* Do they implement the SDP offer/answer negotiation for us?
* Transport: UDP, TCP, TLS, IPv6

* ##### Interoperability

* Are they widely used by many companies?
* Are there many reports of interop issues?

* ##### Documentation

* Are the APIs well documented?
* Are examples available?

### Sofia-sip

URL: <http://sofia-sip.sourceforge.net/>  

License: [LGPL](http://www.gnu.org/copyleft/lesser.html)  

Language: C  

Distributed using: Tarball, some distros have packages

##### Background

Sofia-sip was originally created by Nokia and continues to be primarily developed by them. Outside community members have contributed patches back to them.

##### Community

Mailing list is available at <https://lists.sourceforge.net/lists/listinfo/sofia-sip-devel> for development and while it does see some emails the amount of traffic has dwindled considerably in recent times. This could either mean that the project has reached a point where it fulfills all the needs for everyone in a way that doesn't require any questions asked, the number of users of sofia-sip is not that large, or that noone is considering sofia-sip these days. Unfortunately this also means that the number of users on the development mailing list answering questions has gone down quite a bit as well, with questions in recent times receiving no answers. Issues reported on the issue tracker on sourceforge have gone unhandled and it is difficult to find the current repository for the project. The git repositories on sourceforge and gitorious both show the last commit to master being from ~17 months ago and the site sofia-sip.org where the website says a Darcs repository should be is unreachable.

##### Ease of use

The APIs provided by Sofia-SIP are straight forward and well documented, they provide everything required to write many different SIP applications such as a B2BUA. The stack can be extended some by interacting with the transaction layer and user agent layer to add additional functionality. An autoconf based build system is provided that can be easily worked with in our own build system.

##### Feature richness

Sofia-SIP has kept up with implementing RFCs as they have been created, covering a wide range. A complete RFC list is available at <http://sofia-sip.sourceforge.net/refdocs/sofia_sip_conformance.html> and included is a brief detail of how they can be accomplished using what is available. An SDP parser, generator, and answer/offer API is available that is very straight forward to use. Numerous transports exist including UDP, TCP, TLS, DTLS, and SCTP. Some transports are considered experimental. IPv6 is supported everywhere. Following my community comments though there have been no feature additions in recent times.

##### Interoperability

The complete list of projects and products using Sofia-SIP is unknown but a small list is available at <http://gitorious.org/sofia-sip/pages/SofiaApplications> with the most prominent being FreeSWITCH. Research shows that interoperability is quite well, with the stack having been tested against a myriad of other SIP stacks over its entire lifetime both in real life applications and at SIPit events.

##### Documentation

Documentation is available at <http://sofia-sip.sourceforge.net/development.html> for the various modules provided by Sofia-SIP. Each module includes a general description with details and also detailed information at the individual function level. What is missing though is a document showing the complete picture view for using the stack. Without this it can be cumbersome for a beginner to use the stack or make changes. After considerable searching though I was able to find a small softphone CLI client that uses Sofia-SIP which could be used as a more detailed example. This can be acquired at <http://gitorious.org/sofia-sip/sofsip-cli>

### Resiprocate

URL: <http://www.resiprocate.org/>  

License: [Vovida Software License](http://www.resiprocate.org/License)  

Language: C++  

Distributed using: Tarball, some distros have packages

##### Background

As taken from <http://www.resiprocate.org/Why_did_we_start_reSIProcate>, a team needed to create an awesome SIP stack long ago and resiprocate is the end result.

##### Community

Mailing lists are available at <http://list.resiprocate.org/mailman/listinfo> and while they do not receive many emails any emails that are sent with questions are generally answered. This could mean that uptake of resiprocate with new projects is low but the companies and projects already using it are still invested in it. Source code is easily accessible from SVN at svn.resiprocate.org. Development of resiprocate has continued with new commits occurring every week or so. Development efforts seem to be focused on bug fixes and maintenance with new development occurring on the "repro" project, which uses resiprocate. There are few issues on the issue tracker and those that have been reported seem to have gone unhandled. This probably means that the companies involved are fixing things as they see them and then committing them, bypassing the issue tracker itself. Releases occur often and the release notes are detailed enough to be valuable.

##### Ease of use

The APIs provided by Resiprocate are a bit more complex than other SIP stacks to use but are complete enough to provide everything needed to write many different SIP applications. What is lacking are higher level APIs that encompass specific areas, such as presence. The stack can naturally be extended some by modifying it directly. This is not as easy as other SIP stacks and could make it difficult to truly extend in the ways people would want or expect. An autoconf based build system is provided that can be easily worked with in our own build system. Since Resiprocate is written in C++ there would be some additional effort required to integrate it with our normal C usage, this could prove to be a hinderance for users wishing to contribute and even ourselves since this would be yet another language we would most likely need to constantly use.

##### Feature richness

Resiprocate has evolved as the companies involved have added features and made changes. This has caused the implementation of core and common RFCs to be really complete and well thought out. RFCs that are uncommon and few would need have not been implemented as a result. For our purposes all the RFCs we would expect to be used are implemented. An out-dated but potentially still useful list of RFCs and features is available at <http://www.resiprocate.org/ReSIProcate_Current_Features>. Transports covered include UDP, TCP, TLS, and DTLS. IPv6 is supported everywhere.

##### Interoperability

A list of companies using Resiprocate is available at <http://www.resiprocate.org/We_Use_ReSIProcate>. Research shows that interoperability is quite well, with the companies involved fixing things as they are uncovered. Resiprocate has also been tested at SIPit events.

##### Documentation

Doxygen documentation is available at <http://svn.resiprocate.org/dox/>. Outdated, but potentially still useful, documentation is also available on the wiki at <http://www.resiprocate.org/Main_Page>. Examples of using the stack and user agent layer are available in the "apps" directory of the resiprocate source code. I have not found a well documented complete example of using the user agent layer, though.

### pjsip

URL: <http://www.pjsip.org/>  

License: GPL Version 2  

Language: C  

Distributed using: Tarball

##### Background

Pjsip is developed by a company known as Teluu. They provide pjsip for free under an open source license and also are able to commercially license it.

##### Community

A mailing list is available at <http://lists.pjsip.org/mailman/listinfo/pjsip_lists.pjsip.org> and is quite active. Responses to emails are sporadic with many going unanswered. This probably means Teluu is busy with other obligations usually and that pjsip is being chosen, or tried, by many companies/projects. Source code is easily accessible from SVN at <http://svn.pjsip.org/repos/pjproject/> with releases being made often. Development of things has continued with focus being on video in recent times for their higher level API, and only bug fixes themselves for the lower level pjsip. Issues with pjsip or associated pjproject libraries are reported directly to Teluu and then put up on their public issue tracker. Issues do appear to be getting handled, though.

##### Ease of use

Many APIs are provided by pjsip for different levels of usage and for different features. Most are optional and built upon the lower level APIs. APIs available include a user agent library, presence library, authentication support, and more. They are all straight forward and logically done, making it easy to pick up. Extending pjsip is also easy as an external module can insert itself into many different points within the stack to influence behavior and react. This is how most things are implemented. An autoconf based build system is provided and it has already been integrated into our own build system for ICE/STUN/TURN support.

##### Feature richness

Pjsip has implemented the common RFCs used by everyone. These cover all the current ones we would expect people to need and want. A partial, and out of date, list of RFCs and features can be viewed at <http://www.pjsip.org/sip_media_features.htm>. Transports covered include UDP, TCP, and TLS. IPv6 is available on all transports, with support for TCP and TLS coming from SCF pjproject (it will be integrated back into mainstream).

##### Interoperability

A list of companies and projects using pjsip is not available but from talking to people it seems to be everywhere, and it was used as the SIP stack for the Asterisk SCF project. As a result of being used for SCF there are a few individuals within the Asterisk community who have experience using it already.

##### Documentation

Documentation is available at <http://trac.pjsip.org/repos/wiki> with many APIs being well documented. Samples are available in the source code in the 'samples' directory. As many APIs are built upon others and the lower level pjsip they can also be used to figure out how things work.
