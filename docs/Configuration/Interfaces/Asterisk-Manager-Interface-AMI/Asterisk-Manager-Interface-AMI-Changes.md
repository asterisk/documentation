---
title: Asterisk Manager Interface (AMI) Changes
pageid: 4260021
---

AMI version numbers are formatted as MAJOR.BREAKING.NON-BREAKING:

* MAJOR – changes when a new major version of Asterisk is released
* BREAKING – changes when an incompatible API modification is made
* NON-BREAKING – changes when backwards compatible updates are made (new additions or bug fixes)

Any time a new major version of Asterisk is released the AMI version number is modified to reflect that. This is done by taking the major AMI number of the last major release of Asterisk, increasing it by one, and then resetting the other numbers to zero. From there the breaking and non-breaking versions are increased by one when a change (incompatible and compatible respectively) has been made to AMI.

This has the effect of making the AMI version number relative in relation to an associated Asterisk release, and contextual applicable only to that major release of Asterisk.

