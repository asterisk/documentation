---
title: The Most Basic PBX
pageid: 4817422
---

Requirements and Assumptions
============================

While it won't be anything to brag about, this basic PBX that you will build from Asterisk will help you learn the fundamentals of configuring Asterisk.

For this exercise, we're going to assume that you have the following:

**A machine, virtual or real, with Asterisk already installed.**

Got here without installing Asterisk? Head back to the Installation Asterisk section. Be sure to install the SIP Channel Driver module that you want to use for SIP connectivity. This tutorial will cover using chan\_sip and res\_pjsip/chan\_pjsip.

**Two or more phones which speak the SIP voice-over-IP protocol.**

There are a wide variety of SIP phones available in many different shapes and sizes, and if your budget doesn't allow for you to buy phones, feel free to use a free soft phone. [Softphones](http://en.wikipedia.org/wiki/Softphone) are simply computer programs which run on your computer and emulate a real phone, and communicate with other devices across your network, just like a real voice-over-IP phone would. If you do use a soft phone, remember to watch out for software firewalls blocking traffic from or to the system hosting the softphone.

