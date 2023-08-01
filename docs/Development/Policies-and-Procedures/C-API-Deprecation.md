---
title: C API Deprecation
pageid: 47874730
---





Overview
========

This page documents the C API deprecation process in Asterisk.

On This Page



Policy
======

Asterisk follows a 2 year C API deprecation process. A C API is initially marked as deprecated in a [standard release](/Development/Policies-and-Procedures/Software-Configuration-Management-Policies) which is carried over to the next [long term supported release](/Development/Policies-and-Procedures/Software-Configuration-Management-Policies). This provides a period of 2 releases and thus 2 years where the C API is marked as deprecated. In the next standard release the C API is then removed from the source code tree entirely which is carried over to the next long term supported release. This closely mirrors that of the [Module Deprecation](/Development/Policies-and-Procedures/Module-Deprecation) policy. An example of a C API to deprecate would be the "image" API contained in main/image.c

Marking A C API As Deprecated For Standard Release
==================================================




!!! note 
    Reminder: C API deprecation practices within the tree are only eligible to be done in master when the next release is a standard release. No C API deprecation can be done during the development of a long term supported release.

      
[//]: # (end-note)





#### The following instructions are for the master branch in which the C API is to be deprecated.

1. Before a C API can be marked as deprecated a discussion needs to occur on the [asterisk-dev mailing list](http://lists.digium.com/pipermail/asterisk-dev/) and its use has to be confirmed as non-critical.
2. Create a new issue in the [Asterisk project issue tracker](https://github.com/asterisk/asterisk/issues/) using the "Deprecation" issue type. Ensure the issue summary is descriptive as it will go into release notes.
3. Obtain the Asterisk source code from [Gerrit](https://gerrit.asterisk.org). Since you'll need to put your patch up for review, make an account in Gerrit as well, following the instructions on [Gerrit Usage](/Development/Policies-and-Procedures/Historical-Policies-and-Procedures/Code-Review/Gerrit-Usage).
4. Create a new Git branch for your deprecation change.
5. Mark the C API as deprecated through commenting on its various API calls.
6. Add an UPGRADE.txt document stating that the API has been deprecated and state the version it is scheduled to be removed in.
7. Write a commit message describing the change and referencing the Asterisk issue you created as part of step 1.
8. Submit the patch to Gerrit.

Removing A C API
================




!!! note 
    Reminder: C API removal is only eligible to be done in master when the next release is a standard release. No C API removal can be done during the development of a long term supported release.

      
[//]: # (end-note)





1. Only remove a C API if it has not been reverted from being deprecated.
2. Create a new issue in the [Asterisk project issue tracker](https://github.com/asterisk/asterisk/issues/) using the "Deprecation" issue type. Ensure the issue summary is descriptive as it will go into release notes.
3. Obtain the Asterisk source code from [Gerrit](https://gerrit.asterisk.org/). Since you'll need to put your patch up for review, make an account in Gerrit as well, following the instructions on [Gerrit Usage](/Development/Policies-and-Procedures/Historical-Policies-and-Procedures/Code-Review/Gerrit-Usage).
4. Create a new Git branch for your removal change.
5. Remove any C API implementations and header files for the API. This may include entire files using "git rm".
6. Remove any logic in the respective Makefile for the API implementation if it exists.
7. Remove any logic from configure.ac
8. Remove any mention from makeopts.in
9. Remove any mention from build_tools/menuselect-deps.in
10. Remove any dependency from the contrib/scripts/install-prereq script
11. Add an UPGRADE.txt document stating that the API has been removed.
12. Write a commit message describing the change and referencing the Asterisk issue you created as part of step 1.
13. Submit the patch to Gerrit.
