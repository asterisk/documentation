---
title: Overview
pageid: 21464232
---




Project Overview
================

This project's aim is to create a new SIP channel driver to be included in Asterisk 12.

Asterisk's current SIP channel driver (hereon referred to as "chan\_sip") basically has the flaw of being poorly architected.

* The code is not arranged in a stack. Attempting to add elements such as a new transport or other new feature means touching the code in places you would never expect to have to touch.
* chan\_sip is monolithic; all aspects of SIP reside in the channel driver. Attempting to have a SIP registrar that does not accept calls is not easy.
* Fixing bugs in chan\_sip is rarely straightforward. Changing code in order to fix one bug usually leads to new faults being discovered as a result.
* chan\_sip takes up the lion's share of issues in the issue tracker. [Here](https://github.com/asterisk/asterisk/issues/jira/secure/IssueNavigator.jspa?mode=hide&requestId=11822) is an up-to-date list of open issues against chan\_sip. This accounts for about 25% of the open issues in the issue tracker.
* Many limitations are deeply-ingrained in chan\_sip. For instance, trying to change chan\_sip to support binding to multiple addresses would require huge changes.

Asterisk developers have on several occasions attempted projects to give chan\_sip a transaction layer, or to give it some semblance of a refactor. In every case, they've found that the magnitute of their efforts was much greater than originally expected. In the end, their frustration got the better of them and they reported that the effort that it would take in order to do whatever task they were doing would be better spent in rewriting chan\_sip altogether.

Requirements and Specification
==============================

SIP stack
---------

The new chan\_sip will use a third-party SIP stack. Research was done into various offerings. SIP stack research can be found [here](/Development/Roadmap/Asterisk-12-Projects/New-SIP-channel-driver/SIP-Stack-Research). The result of the research was to choose PJSIP as the SIP stack. This was communicated on the [asterisk-dev mailing list on December 10th, 2012](http://lists.digium.com/pipermail/asterisk-dev/2012-December/057997.html).

As part of this work, pjproject has been pulled out of the Asterisk source tree and placed into its own Git repository. The repository is available at <git://github.com/asterisk/pjproject.git>.




---

**Note:**  You **must** use the version of pjproject in the github repository. Asterisk requires the shared objects built by this version of pjproject and will not build against another version of pjproject.

If you already have an old installation of pjproject, you can remove it with:




---

  
  


```

rm -f /usr/lib/libpj\*.a /usr/lib/libmilenage\*.a /usr/lib/pkgconfig/libpjproject.pc  



---



```




---




---

**Note:**  Alternatively, packages for CentOS 6 are available at <http://packages.asterisk.org/centos/6/current/>.

  



---


### Installing pjproject

1. Check-out pjproject from the github repository




---

  
  


```

# git clone http://github.com/asterisk/pjproject pjproject

```



---
2. Configure pjproject to produce shared objects in the /usr directory (or in an appropriate folder in which your system expects shared objects to reside)




---

  
  


```

# cd pjproject
# ./configure --prefix=/usr --enable-shared

```



---




---

**Note:**  You may need additional configure options depending on your local system and what is already installed.

Commonly used options are: --with-external-speex --with-external-gsm --with-external-srtp --disable-sound --disable-resample

  



---
3. Compile pjproject and install




---

  
  


```

# make
# make install

```



---

 

Configuration

Configuration for the new chan\_sip will be redesigned entirely. Configuration will be more modular, allowing easier control over aspects than previously allowed. At the same time, the new chan\_sip MUST be backwards-compatible with the old chan\_sip's configuration to ease upgrade. The tentative plan for this is to parse old configuration and translate the options into their new equivalents where possible.

At this stage, no configuration schema have been devised. This will be added as it is decided.

Features
--------

A brief high-level overview of features for the new chan\_sip includes:

* Transports (all IPv4 and IPv6)
	+ UDP
	+ TCP
	+ TLS
	+ Websocket
* Digest authentication
* Media sessions
	+ Basic phone calls
	+ Call transfer
	+ Audio/video capability negotiation (to include T.38 negotiation)
	+ Direct media
	+ Session timers
	+ Party Identity
* Registration
	+ Registrar for incoming registrations
	+ Client registration (i.e. outgoing registration)
* Subscriptions
	+ Presence
	+ Dialog-info
	+ Message-summary
	+ Call-completion
* Messaging
	+ Out-of-call messaging

Use cases
---------

Since A SIP channel driver has so many use cases, these reside on their own sub-page. SIP use cases can be found [here](/Development/Roadmap/Asterisk-12-Projects/New-SIP-channel-driver/SIP-use-cases).

Documentation
-------------

In order to increase adoption of the new chan\_sip and encourage enhancement, detailed documentation MUST be provided. Documentation will be provided in several forms.

##### In-code documentation

This can be broken into two categories

* API documentation (i.e. Doxygen)
* User documentation (i.e. XML documentation)

All functions must have thorough doxygen documentation, and all applications, dialplan functions, manager actions, and manager events must have XML.

##### Configuration sample

A sample configuration will be included. The sample configuration will serve to be a minimal documentation of options. More detailed explanations may be found on the wiki.

##### Wiki documentation

The wiki will be used to document high-level information, ranging from configuration option details to an explanation of the threading model and architecture for developers. Links to documentation pages will be added here as documentation is written.

APIs
----

At a minimum, all dialplan applications, dialplan functions, manager commands, and CLI commands that worked with the old chan\_sip must also work with new chan\_sip. The following will be present

### Dialplan applications

##### Legacy applications

* [SIPDtmfMode](/Asterisk-11-Application_SIPDtmfMode)
* [SIPAddHeader](/Asterisk-11-Application_SIPAddHeader)
* [SIPRemoveHeader](/Asterisk-11-Application_SIPRemoveHeader)
* [SIPSendCustomINFO](/Asterisk-11-Application_SIPSendCustomINFO)

##### New applications

TBD

### Dialplan functions

##### Legacy functions

* [CHANNEL](/Asterisk-11-Function_CHANNEL) (The SIP-specific bits)
* [SIP\_HEADER](/Asterisk-11-Function_SIP_HEADER)
* [SIPPEER](/Asterisk-11-Function_SIPPEER)
* [CHECKSIPDOMAIN](/Asterisk-11-Function_CHECKSIPDOMAIN)

##### New functions

TBD

### CLI commands

##### Legacy CLI commands

* sip show channels
* sip show channelstats
* sip show domains
* sip show inuse
* sip show objects
* sip show peers
* sip show peer
* sip show users
* sip show user
* sip show registry
* sip show settings
* sip show mwi
* sip show channel
* sip show history
* sip show sched
* sip show tcp
* sip prune realtime
* sip debug
* sip set history
* sip reload
* sip qualify peer
* sip unregister
* sip notify

##### New CLI commands

TBD

### Manager commands

##### Legacy Manager commands

* [SIPPeers](/Asterisk-11-ManagerAction_SIPpeers)
* [SIPshowpeer](/Asterisk-11-ManagerAction_SIPshowpeer)
* [SIPqualifypeer](/Asterisk-11-ManagerAction_SIPqualifypeer)
* [SIPshowregistry](/Asterisk-11-ManagerAction_SIPshowregistry)
* [SIPnotify](/Asterisk-11-ManagerAction_SIPnotify)
* [SIPpeerstatus](/Asterisk-11-ManagerAction_SIPpeerstatus)

##### New Manager commands

TBD

### AGI commands

##### Legacy AGI commands

None

##### New AGI commands

TBD

Design
======

Since a SIP stack has not been chosen yet, it is difficult to go about trying to design anything. As design is done, more will be added here.

Test Plan
=========

The new chan\_sip test plan can be found [here](/Development/Roadmap/Asterisk-12-Projects/New-SIP-channel-driver/SIP-Test-Plan)

Project Planning
================

Jira issues will be posted here for the new chan\_sip as they become created. If you are interested in helping with any of these, feel free to step forward and help out. Please comment on the specific Jira issue rather than on this page. If you wish to have more in-depth discussions about a task you wish to take on, then please direct the discussion to the [Asterisk developers mailing list](http://lists.digium.com/mailman/listinfo/asterisk-dev)

true

Reference information
=====================

The decision to move forward with a new chan\_sip was made at [AstriDevCon 2012](/Development/Roadmap/AstriDevCon-2012).

Testing
-------

* [Build and Unit Tests](http://bamboo.asterisk.org/browse/ASTTEAM-PIMPMYSIP)

Notable Reviews
---------------



| Review | Link |
| --- | --- |
| res\_sip and res\_sip\_session design review | <https://reviewboard.asterisk.org/r/2251/> |
| Initial work for res\_sip and res\_sip\_session: Inbound and outbound calls work | <https://reviewboard.asterisk.org/r/2285/> |
| SIP authentication support | <https://reviewboard.asterisk.org/r/2310/> |
| Pimp My SIP Media Improvements | <https://reviewboard.asterisk.org/r/2318/> |
| Make new SIP work make use of threadpool | <https://reviewboard.asterisk.org/r/2305/> |
| Fix pjproject's build system to support shared objects | <https://code.asterisk.org/code/cru/CR-AST-12> |

