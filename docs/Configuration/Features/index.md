---
title: Overview
pageid: 4260053
---

The Asterisk core provides a set of features that once enabled can be activated through DTMF codes (also known as feature codes).

Features are configured in features.conf and most require additional configuration via arguments or options to applications that invoke channel creation.

Versions of Asterisk older than 12 included parking configuration inside features.conf. In Asterisk 12 parking configuration was moved out into res\_parking.conf.

The core features discussed in this section are:

* + Blind transfers
	+ Attended transfers and variations.
* + This includes instructions for call recording, disconnect and quick parking.
* + Feature code call pickup as well as dialplan application-based call pickup.
* + How to use a couple of functions to set built-in feature codes on a per-channel basis.
* + How to define custom features and set them on a per-channel basis using a channel variable.
* + Instructions for how to implement parking lots (with examples).

The only features discussed in this section are those that have some relation to features.conf. Features in a broader sense - that is features that your application built with Asterisk may have - are implemented through usage of ,  and  or .

 

