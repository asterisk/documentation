---
title: IPv6 Support
pageid: 29393488
---

Overview
========

Since Asterisk 12, IPv6 is supported by the most commonly used components of Asterisk which support IP based communication. This includes the latest SIP channel driver chan\_pjsip as well as the older chan\_sip. IPv6 support may be spotty before Asterisk 12. For sufficient IPv6 support it is recommended that you upgrade to Asterisk 13 or greater.

Configuration
=============

Fortunately, the configuration is easy and most things will simply work. For channel technologies such as chan\_pjsip, chan\_sip or chan\_iax2 the IPv6 support must be configured in the channel's configuration file. (i.e. pjsip.conf, sip.conf or iax.conf). In each configuration file there are typically options referring to a general bind address or specific TCP or UDP bind addresses. Other than configuring those options to bind to IPv6 interfaces there should be few other options needed. The documentation or configuration samples for each driver should make this clear.

Links to specific instructions:

* [Configuring res\_pjsip for IPv6](/Configuration/Channel-Drivers/SIP/Configuring-res_pjsip/Configuring-res_pjsip-for-IPv6)
* [Configuring chan\_sip for IPv6](/Configuration/Channel-Drivers/SIP/Configuring-chan_sip/Configuring-chan_sip-for-IPv6)
* [Configuring IAX for IPv6](/Configuration/Channel-Drivers/Inter-Asterisk-eXchange-protocol-version-2-IAX2/IAX2-Configuration/Configuring-chan_iax2-for-IPv6)
* [Configuring ACLs for IPv6](/Configuration/Core-Configuration/Named-ACLs)

At the time of writing, DUNDi does not support IPv6.

