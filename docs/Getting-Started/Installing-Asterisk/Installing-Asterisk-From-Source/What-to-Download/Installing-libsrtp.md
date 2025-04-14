---
title: Installing libsrtp
pageid: 38765169
---

libsrtp is a critical part of providing secure calling with Asterisk but there are some very old versions floating around and even still being made available by major distributions.  It's also a library that's used by both Asterisk itself and pjproject.  To make matters even worse, pjproject bundles a version with it's tarball.

As of November 2017, the minimum supported version of libsrtp supported by Asterisk is 1.5.4.  Earlier versions may allow Asterisk to compile but there were enough issues that earlier versions MAY CRASH, will NOT BE SUPPORTED and are used at your own risk.  Both Asterisk and pjproect do support libsrtp 2.x.

Make sure to specify **`--with-pjproject-bundled`** when running **`./configure`** to make sure both Asterisk and pjproject are in sync with respect to library versions.
