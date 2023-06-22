---
title: Overview
pageid: 4260053
---

The [Asterisk core](/Configuration/Core-Configuration) provides a set of features that once enabled can be activated through DTMF codes (also known as feature codes).

Features are configured in features.conf and most require additional configuration via arguments or options to applications that invoke channel creation.




!!! tip 
    Versions of Asterisk older than 12 included parking configuration inside features.conf. In Asterisk 12 parking configuration was moved out into res\_parking.conf.

      
[//]: # (end-tip)



The core features discussed in this section are:

* [Feature Code Call Transfers](/Configuration/Features/Feature-Code-Call-Transfers)
	+ Blind transfers
	+ Attended transfers and variations.
* [One-Touch Features](/Configuration/Features/One-Touch-Features)
	+ This includes instructions for call recording, disconnect and quick parking.
* [Call Pickup](/Configuration/Features/Call-Pickup)
	+ Feature code call pickup as well as dialplan application-based call pickup.
* [Built-in Dynamic Features](/Configuration/Features/Built-in-Dynamic-Features)
	+ How to use a couple of functions to set built-in feature codes on a per-channel basis.
* [Custom Dynamic Features](/Configuration/Features/Custom-Dynamic-Features)
	+ How to define custom features and set them on a per-channel basis using a channel variable.
* [Call Parking](/Configuration/Features/Call-Parking)
	+ Instructions for how to implement parking lots (with examples).

The only features discussed in this section are those that have some relation to features.conf. Features in a broader sense - that is features that your application built with Asterisk may have - are implemented through usage of [Applications](/Applications), [Functions](/Functions) and [Interfaces](/Interfaces) or [Dialplan](/Configuration/Dialplan).

 

