---
title: Overview
pageid: 4817412
---

The Asterisk dialplan
=====================

The dialplan is essentially a scripting language specific to Asterisk and one of the primary ways of instructing Asterisk on how to behave. It ties everything together, allowing you to route and manipulate calls in a programmatic way. The pages in this section will describe what the elements of dialplan are and how to use them in your configuration.

Dialplan configuration file
===========================

The Asterisk dialplan is found in the extensions.conf file in the **configuration directory**, typically /etc/asterisk.

If you modify the dialplan, you can use the Asterisk CLI command "dialplan reload" to load the new dialplan without disrupting service in your PBX.

Example dialplan
================

The example dial plan, in the configs/samples/extensions.conf.sample file is installed as extensions.conf if you run "make samples" after installation of Asterisk. The sample file includes many examples of dialplan programming for specific scenarios and environments often common to Asterisk implementations.

On This PageTopics