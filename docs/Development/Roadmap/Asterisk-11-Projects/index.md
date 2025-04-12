# Asterisk 11 Projects

## Overview

The following is a listing of projects Digium has committed developer resources to for Asterisk 11. The majority of these were derived from the notes taken from [AstriDevCon 2011](/Development/Roadmap/AstriDevCon-2011), held on Monday, October 24th, 2011. The choice of the projects listed on this page was based on the following:


* The agreement in the community that Asterisk 11 is to be an LTS release (see [Asterisk Versions](/About-the-Project/Asterisk-Versions)).
* That, since Asterisk 11 is an LTS release, no major new features that introduce a significant risk should be included. Items that introduce a large amount of risk should instead be deferred for Asterisk 12.
* Priority should be given to those features that either significantly assist the users/developers of Asterisk without much risk, or those that improve the reliability of the product.


Some of these criteria are obviously subjective, but they were used as guidelines when determining whether or not a proposed change is appropriate for Asterisk 11. These guidelines should be kept in mind when any new projects are proposed and considered for inclusion in Asterisk 11.


The following subsections provide a brief description of each of the projects. As time progresses, sub-pages will be added to this page that expand upon these descriptions.


If you'd like to assist with any of these projects, please feel free to notify the development community in #asterisk-dev or on the development mailing list.


## SIP Path Support


This project implements RFC 3327 - Path Extension Header Field for SIP in Asterisk.  This allows discovery for intermediate proxies during SIP registration and in subsequent requests.  A patch (against 1.8) by Klaus Darilion (with assistance from Olle) currently exists at <https://reviewboard.asterisk.org/r/991/>, and may be used as a starting point for this work. If this patch is used as a basis for this project, it will need to be brought up to the current state of Asterisk.


Note that RFC 3327 recommends that the registrar support S/MIME, and attach a signed S/MIME of the response, which Asterisk does not currently support. This project does not include the work that would be necessary to make Asterisk support S/MIME.


## Pre-Dial and Hangup Handlers


Pre-dial allows you to jump to the dialplan after a channel has been created but before the actual dialing takes place. Similarly, hangup handlers let you attach a dialplan extension that is called when a channel is hung up. While similar to the 'h' extension, this is not global to a context or tied to a particular context, but rather follows the lifetime of a particular channel.


Both of these are currently being developed by Kobaz:


Pre-dial review:<https://reviewboard.asterisk.org/r/1229>

Hangup handlers review: <https://reviewboard.asterisk.org/r/1230>


[Pre-dial handlers](/Development/Roadmap/Asterisk-11-Projects/Pre-dial-handlers-Specification)

[Hangup Handlers Specification](/Development/Roadmap/Asterisk-11-Projects/Hangup-Handlers-Specification)


## Documentation improvements


This project covers a number of improvements to the documentation that is extracted from the Asterisk source:


* AMI events - this includes some subset of the current AMI events.  What is documented includes not only attributes of the event, but also the scenarios in which they are raised.
* Technology specific information - currently, there is no way to document information that pertains to a particular technology, but exists outside of that technology specific module.  For example, the MessageSend application has technology specific behaviour that is determined in res_jingle and chan_sip, but should be documented with the res_jingle/chan_sip specific documentation.  New tags are provided that allow for documentation to be written with the module that defines that behaviour (for example, in res_jingle) - but referenced by the application that uses it and displayed with that application, e.g., in MessageSend.
* Config file schemas - up until now, the config files were not a recommended configuration so much as a source of configuration documentation. In Asterisk 11, the configuration schema for each configuration file is instead defined in the source files that use that configuration information, including valid values for a configuration item, required items, optional, etc.


Note that with the AMI events documented - or at least a subset thereof - a full specification for AMI will be defined and released. This entails treating the documented events/actions as a new version of AMI.


﻿[AMI Event Documentation](/Development/Roadmap/Asterisk-11-Projects/AMI-Event-Documentation)


## OpenSSL initialization


During the devcon after AstriCon 2010, we got a report that using PostgreSQL from within Asterisk, when the PostgreSQL connections are configured to use SSL/TLS to connect to the database server, can cause random crashes and other bizarre behavior. The reporter said this was known to be an issue with some other packages as well (notably Kamailio), and had to do with both Asterisk and the PostgreSQL libraries assuming they "owned" the OpenSSL libraries in the process' memory space, and thus calling initialization code twice (or worse).


The fix for this problem uses dynamic linker functionality to **wrap** the real OpenSSL initialization functions (and some other dangerous ones) with versions that don't actually do anything, and then calls the real ones only **one** time during Asterisk startup. To make this work, the SSL functionality that is normally built into the main Asterisk binary now must be built into a dynamic library (libasteriskssl.so), which is installed into the standard dynamic library location on the system (this is **not** an Asterisk loadable module, just a regular dynamic library).


As part of this, the usage of ASTLIBDIR throughout the build system to refer to the directory where Asterisk loadable modules are installed was changed to ASTMODDIR (which matches how it is referred to in the source code and in asterisk.conf), and a new definition of ASTLIBDIR was created to point to the system's dynamic library directory.


Note that this patch has already been reviewed and committed to the subversion trunk.


## Opaquification of ast_channel


Making the ast_channel an opaque object has several large benefits regarding the maintenance of Asterisk:


1. It greatly simplifies complex operations on the channel, e.g., masquerades
2. It reduces the complexity in other portions of the code by requiring users of the channel to have a handle to the channel, as opposed to a reference (such as sip_pvt)


This is a two-part process. For Asterisk 11, the syntax of the ast_channel is being changed to be opaque, while the semantics are being left alone. This minimizes the risk of negatively impacting chan_sip and other users of the ast_channel object. Changing the semantics of ast_channel will be done in Asterisk 12, which will leverage the work of Asterisk 11 to make the maintenance improvements.


## Who hung up


"Who hung up" gives Asterisk, on a failed call, the capability to provide access to the information surrounding the hang up to entities that care about such information. This currently includes the list of devices dialed as well as the technology-specific and Asterisk cause codes.


This includes the following:


* Modification of ast_frame to contain sufficient information for each of the consumers of the event (committed)
* Implementations in core level channel drivers (committed for IAX2, SIP, DAHDI)
* A generic layer that allows access to Asterisk cause code equivalents (committed)
* Tests to exercise this feature for each channel driver (committed for IAX2, SIP)
* Test to exercise this feature as a replacement backend for SIP_CAUSE (committed)


See [Who Hung Up?](/Development/Roadmap/Asterisk-11-Projects/Who-Hung-Up) for more information.


## Named ACLs


Named ACLs expand upon Asterisk's current ACL functionality. This may have a starting point using a branch of Olle's, although it would have to be brought up to the current state of Asterisk.


[Named ACLs](/Development/Roadmap/Asterisk-11-Projects/Named-ACLs-Specification)


## Lightweight NAT


Lightweight NAT gives Asterisk a lightweight means of holding a NAT open in SIP (outbound only). This is similar to the qualify options in chan_sip, but consists of an empty UDP message that Asterisk would not expect a response for.


Note that Josh has already performed the work for this project, including tests for the Asterisk Test Suite.


## IPv6 for everything


IPv6 support already exists in some modules in Asterisk.  This expands on that, making all modules in Asterisk that use IP-based communication IPv6 compatible.  This includes all channel drivers, manager, http, database drivers, FastAGI, etc.


* FastAGI - Done
* ExternalIVR - Done
* chan_iax2
* Others...?


## app_page refactor


Page (app_page) no longer depends upon MeetMe (including using DAHDI as a timing source). Instead, app_page now uses the bridging layer in Asterisk. This is similar to the work that was done for ConfBridge for Asterisk 10, although much more limited in scope (as app_page is a much smaller application).


## Unique identifier for filtering log data for a call


Each call now has a unique identifier associated with it.  This unique identifier is associated with every log statement associated with a call.  This allows people viewing a lot to easily associate all statements that relate to a particular call, even when other log statements from other calls are interleaved with those they care about.


From an implementation standpoint, there are a number of technical challenges that need to be addressed for this project:


1. How do we handle logging statements that are occurring because a call is about to happen, but before an ast_channel object has been allocated? (The same could be said of those things that occur because of a call, but occur after an ast_channel has been torn down)
2. Locking semantics may be difficult to surmount without negatively impacting performance
3. How do we pass around a channel identifier through the various layers of Asterisk without over-complicating the various APIs?


Some initial work was done on this during a Google Summer of Code by Clod (JunK-Y) and may be used as a starting point for this work.


[Unique Call-ID Logging](/Development/Roadmap/Asterisk-11-Projects/Unique-Call-ID-Logging)


## Bridging Thread Pool / API usage expansion


When multiple channels are bridged, very often the allocated bridge channel threads do very little work. This project gives Asterisk the capability to provide a thread pool that services multiple bridges, reducing the number of necessary context switches.


At the same time, many things in Asterisk continue to use the standard 2-party calls (ast_bridge). These are migrated to use the bridging API instead. This would include making ast_bridge_call use the bridging API underneath.


## Complete app_macro deprecation


This project updates modules that require app_macro to instead prefer app_stack. Applications can continue to support the usage of app_macro for at least Asterisk 11, but everything that can use app_macro has an option for app_gosub instead. This is similar to what was already done for both app_dial and app_queue.


Candidates for this :


* CCSS
* Connected Line
* Channel Redirecting


This work is now complete, including external tests for both macro-based and gosub-based usage of these facilities. More information is available on the [app_macro Deprecation](/Development/Roadmap/Asterisk-11-Projects/app_macro-Deprecation) subpage.


## Coverity Report Fixing


A Coverity static analysis report was generated for Asterisk some time ago. This project entails performing a deep analysis of the results, turning the findings into JIRA issues, and resolving those findings. There are about a dozen "categories" of issues whose fixing would improve the stability of core Asterisk, and most of the findings in each category can be fixed at the same time.


## SIP Testing


In order to improve the stability and maintainability of Asterisk's chan_sip, the Asterisk Test Suite has a new set of SIP tests that expand upon its current capabilities. This includes both nominal tests for a variety of scenarios, as well as some off-nominal scenarios, which will be emulated using SIPp and/or pjsua.


## Configuration Management


Asterisk modules each load their own configuration files. While the configuration objects (ast_config, ast_variable, etc.) abstract away the actual reading of the config files/access of the realtime backends, each module still validates and applies the key/value pairs to its own configuration variables. Unfortunately, this is rarely done in a thread-safe manner, and is not done in a consistent manner across modules.


As there are a large number of configuration files in Asterisk, this task focuses on specifying the correct way to store configuration values such that it is consistent across modules and thread-safe.


## Leveraging of Media Format Architecture


The new media architecture in [Asterisk 10 Media Overhaul](../Asterisk-10-Projects/Media-Overhaul) was utilized to an extent by introducing some wide-band audio codecs and translations [Asterisk 10 Codec and Audio Formats](../Asterisk-10-Projects/Codecs-and-Audio-Formats). Currently, attributes are supported by the following codecs:


* SILK (res_format_attr_silk)
* CELT (res_format_attr_celt)


Attributes have not been applied for other formats, such as h264. SDP negotiation in chan_sip also does not take into account the format attributes. Additionally, with the current architecture, each codec's specific attributes must be referenced by the entity performing the negotiation. While there may not be any other way to do this, it does imply that chan_sip must have specific domain knowledge of each codec that it supports. (For example, to set the sampling rate of SILK would require it to set the SILK_ATTR_KEY_SAMP_RATE key, while setting the sampling rate of CELT would require it to set the CELT_ATTR_KEY_SAMP_RATE key).


This project continues to leverage the Media Format Architecture in chan_sip, with potential room for growth in other channel drivers (if the maintainers of those channel drivers would like to participate). This includes modifications to the architecture to make it easy for channel drivers to provide attributes to the format modules.
