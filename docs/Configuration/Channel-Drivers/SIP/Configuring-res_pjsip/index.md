---
title: Overview
pageid: 25919621
---

Overview
========

This page and its sub-pages are intended to help an administrator configure the new SIP resources and channel driver included with Asterisk 12. The channel driver itself being chan_pjsip which depends on res_pjsip and its many associated modules. The **res_pjsip** module handles configuration, so we'll mostly speak in terms of configuring res_pjsip.

A variety of reference content is provided in the following sub-pages.

* If you are moving from the old channel driver, then look at [Migrating from chan_sip to res_pjsip](/Configuration/Channel-Drivers/SIP/Configuring-res_pjsip/Migrating-from-chan_sip-to-res_pjsip).
* For basic config examples look at [res_pjsip Configuration Examples](/Configuration/Channel-Drivers/SIP/Configuring-res_pjsip/res_pjsip-Configuration-Examples).
* For detailed explanation of the res_pjsip config file go to [PJSIP Configuration Sections and Relationships](/Configuration/Channel-Drivers/SIP/Configuring-res_pjsip/PJSIP-Configuration-Sections-and-Relationships).
* You can also find info on [Dialing PJSIP Channels](/Configuration/Channel-Drivers/SIP/Configuring-res_pjsip/Dialing-PJSIP-Channels).
* Maybe you're migrating to IPv6 and need to learn about [Configuring res_pjsip for IPv6](/Configuration/Channel-Drivers/SIP/Configuring-res_pjsip/Configuring-res_pjsip-for-IPv6)

Before You Configure
====================

This page assumes certain knowledge, or that you have completed a few prerequisites.

* You have [installed pjproject](/Getting-Started/Installing-Asterisk/Installing-Asterisk-From-Source/PJSIP-pjproject), a dependency for res_pjsip.
* You have Installed Asterisk including the res_pjsip and chan_pjsip [modules](/Getting-Started/Installing-Asterisk/Installing-Asterisk-From-Source/Using-Menuselect-to-Select-Asterisk-Options) and their dependencies.
* You understand [basic Asterisk concepts](/Getting-Started). Including the [role of extensions.conf](/Configuration/Dialplan) (dialplan) in your overall Asterisk configuration.

Quick Start
===========

If you like to figure out things as you go; here's a few quick steps to get you started.

* Understand that res_pjsip is configured through pjsip.conf. This is where you'll be configuring everything related to your inbound or outbound SIP accounts and endpoints.
* Look at the [res_pjsip Configuration Examples](/Configuration/Channel-Drivers/SIP/Configuring-res_pjsip/res_pjsip-Configuration-Examples) section. Grab the example most appropriate to your goal and use that to replace your pjsip.conf.
* Reference documentation for all configuration parameters is available on the wiki:
	+ [Core res_pjsip configuration options](/latest_api/API_Documentation/Module_Configuration/res_pjsip)
	+ [Configuration options for ACLs in res_pjsip_acl](/latest_api/API_Documentation/Module_Configuration/res_pjsip_acl)
	+ [Configuration options for outbound registration, provided by res_pjsip_outbound_registration](/latest_api/API_Documentation/Module_Configuration/res_pjsip_outbound_registration)
	+ [Configuration options for endpoint identification by IP address, provided by res_pjsip_endpoint_identifier_ip](/latest_api/API_Documentation/Module_Configuration/res_pjsip_endpoint_identifier_ip)
* You'll need to tweak details in pjsip.conf and on your SIP device (for example IP addresses and authentication credentials) to get it working with Asterisk.  
Refer back to [the config documentation on the wiki](/Configuration/Channel-Drivers/SIP/Configuring-res_pjsip/PJSIP-Configuration-Sections-and-Relationships) or the sample pjsip.conf if you get confused.
