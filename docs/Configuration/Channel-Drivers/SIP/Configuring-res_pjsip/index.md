---
title: Overview
pageid: 25919621
---

Overview
========

This page and its sub-pages are intended to help an administrator configure the new SIP resources and channel driver included with Asterisk 12. The channel driver itself being chan\_pjsip which depends on res\_pjsip and its many associated modules. The **res\_pjsip** module handles configuration, so we'll mostly speak in terms of configuring res\_pjsip.

A variety of reference content is provided in the following sub-pages.

* If you are moving from the old channel driver, then look at .
* For basic config examples look at .
* For detailed explanation of the res\_pjsip config file go to .
* You can also find info on .
* Maybe you're migrating to IPv6 and need to learn about

Before You Configure
====================

This page assumes certain knowledge, or that you have completed a few prerequisites.

* You have installed pjproject, a dependency for res\_pjsip.
* You have Installed Asterisk including the res\_pjsip and chan\_pjsip modules and their dependencies.
* You understand basic Asterisk concepts. Including the role of extensions.conf (dialplan) in your overall Asterisk configuration.

Quick Start
===========

If you like to figure out things as you go; here's a few quick steps to get you started.

* Understand that res\_pjsip is configured through pjsip.conf. This is where you'll be configuring everything related to your inbound or outbound SIP accounts and endpoints.
* Look at the  section. Grab the example most appropriate to your goal and use that to replace your pjsip.conf.
* Reference documentation for all configuration parameters is available on the wiki:
	+ Core res\_pjsip configuration options
	+ Configuration options for ACLs in res\_pjsip\_acl
	+ Configuration options for outbound registration, provided by res\_pjsip\_outbound\_registration
	+ Configuration options for endpoint identification by IP address, provided by res\_pjsip\_endpoint\_identifier\_ip
* You'll need to tweak details in pjsip.conf and on your SIP device (for example IP addresses and authentication credentials) to get it working with Asterisk.  
Refer back to the config documentation on the wiki or the sample pjsip.conf if you get confused.
