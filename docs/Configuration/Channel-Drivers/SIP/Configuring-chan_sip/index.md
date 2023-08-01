---
title: Overview
pageid: 28934283
---

Note about chan_pjsip
======================






!!! warning PJSIP is the Standard SIP Driver
    It is not recommended for new installations to use chan_sip.

    * chan_sip has been officially removed in Asterisk 21 – Releasing 2023
    * chan_sip was deprecated in Asterisk 17 – Released: October 2019
    * Beginning with Asterisk 13.8.0, a stable version of pjproject is included in Asterisk's ./third-party directory and is enabled with the `--with-pjproject-bundled` option to `./configure`.
    * Beginning with Asterisk 15.0.0, it is enabled by default but can be disabled with the `--without-pjproject-bundled` option to `./configure`.

    

    See: [PJSIP-pjproject](/Getting-Started/Installing-Asterisk/Installing-Asterisk-From-Source/PJSIP-pjproject)

    See:  [Configuring res_pjsip](/Configuration/Channel-Drivers/SIP/Configuring-res_pjsip)

    See: [Migrating from chan_sip to res_pjsip](/Configuration/Channel-Drivers/SIP/Configuring-res_pjsip/Migrating-from-chan_sip-to-res_pjsip)

      
[//]: # (end-warning)





Configuring chan_sip
=====================

There is documentation that resides in the **sip.conf.sample** file included with the source.



\* Please be advised that limited support will be available on the mailing list, IRC, and bug tracker for issues with chan_sip

* Further development and bug fixes for chan_sip are not likely



