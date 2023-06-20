---
title: Dial Application
pageid: 4817433
---

Overview of the Dial Application
================================

The Dial application is probably the most well known and crucial Asterisk application. Asterisk is often used to interface between communication devices and technologies, and Dial is a simple way to establish a connection from the dialplan. When a channel executes Dial then Asterisk will attempt to contact or "dial" all devices passed to the application. If an answer is received then the two channels will be bridged. Dial provides many options to control behavior and will return results and status of the dial operation on a few channel variables.

Using the Dial application
--------------------------

Here is a few ways to learn the usage of the Dial application.

* Read the detailed documentation for your Asterisk version: e.g. for Asterisk 13 - [Asterisk 13 Application\_Dial](/Asterisk-13-Application_Dial)
* See how to use Dial for a specific channel driver: [Dialing PJSIP Channels](/Configuration/Channel-Drivers/SIP/Configuring-res_pjsip/Dialing-PJSIP-Channels)
* Note how Dial is used in a simple Asterisk dialplan: [Creating Dialplan Extensions](/Deployment/Basic-PBX-Functionality/Creating-Dialplan-Extensions)

See Also
========

* [Pre-Dial Handlers](/Configuration/Dialplan/Subroutines/Pre-Dial-Handlers)
* [Hangup Handlers](/Configuration/Dialplan/Subroutines/Hangup-Handlers)

 

