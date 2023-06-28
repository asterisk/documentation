---
title: Bridging Modules
pageid: 4817439
---

Beginning in Asterisk 1.6.2, Asterisk introduced a new method for bridging calls together. It relies on various bridging modules to control how the media streams should be mixed for the participants on a call. The new bridging methods are designed to be more flexible and more efficient than earlier methods.


Bridging modules have file names that look like **bridge_xxxxx.so**, such as **bridge_simple.so** and **bridge_multiplexed.so**.

