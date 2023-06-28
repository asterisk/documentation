---
title: Resource Modules
pageid: 4817493
---

Resources provide functionality to Asterisk that may be called upon at any time during a call, even while another application is running on the channel. Resources are typically used as asynchronous events such as playing hold music when a call gets placed on hold, or performing call parking.

Resource modules have file names that looks like **res_xxxxx.so**, such as **res_musiconhold.so**.

Resource modules can provide [Asterisk 1.8 Dialplan Applications](/Asterisk-1.8-Dialplan-Applications) and [Asterisk 1.8 Dialplan Functions](/Asterisk-1.8-Dialplan-Functions) even if those apps or functions don't have separate modules.

