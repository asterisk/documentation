---
title: Overview
pageid: 50921507
---

Overview
========

This page describes the general future of the Asterisk project infrastructure. To start off with: We're moving to Github. All further content reflects this. The decision to use a hosted solution was to minimize the amount of system maintenance and administration that needs to be done by the Asterisk team at Sangoma, which currently handles all aspects of it. We compared Gitlab and Github to see which would work best for us, and opted for Github. To see comparison details head over [here](/Development/Asterisk-Project-Infrastructure-Future/Trade-Study-Github-vs.-Gitlab).




!!! note 
    The Asterisk Project moved to GitHub on April 29th, 2023.

    https://github.com/asterisk

      
[//]: # (end-note)



On this Page


User Accounts
=============

A Github account will be needed for things. The old Asterisk Atlassian/community accounts will no longer be used for any project infrastructure, including Discourse. Discourse will revert back to being standalone and any existing user will need to reset their password.




!!! info ""
    If you have previously contributed to Asterisk then it is best to ensure that the email address you have used in your commits is also linked to your Github, for proper attribution and searching. This is not required but would be ideal.

      
[//]: # (end-info)



Issue Tracking
==============

This will be done using Github native issue tracking. Tags will be used to manage things as needed. Permissions will be granted as appropriate.

Review
======

Github pull requests will be used for code review. All changes will go through pull requests and code review. Commit messages will maintain the same format as now, except only the Github issue needs to be referenced. No reporters or testers need to be referenced.

CI
==

Github Actions will be used for executing checks on new pull requests and for executing gates before being allowed to merge.

Automation
==========




!!! note 
    For all cases where Github Actions are referenced for automation a market place action will be used if it works for our usage.

      
[//]: # (end-note)



Much like we do with the existing Atlassian and Gerrit based infrastructure, we would like to leverage automation as much as possible to reduce the amount of work we have to do. Github provides Actions which will be utilized by the process to automate things.

Automatic Closure of Old Issues
-------------------------------

Just like in JIRA an action will be used which will automatically close issues that have not been responded to in a time period of 2 weeks.

Branch Cherry Picking
---------------------

Right now branch management is easy as Gerrit provides a UI based cherry pick function. This does not exist in Github and instead we will try to replicate this using Github Actions, so that people do not have to manually cherry pick and create multiple pull requests themselves.

  
Releases
========

These will be done completely using Github Actions. CI will create the appropriate files such as the CHANGES / UPGRADE.txt files, the Alembic SQL files, and other things. Once done a tag will be created and the resulting tarball also made available on the downloads server.

Security Issues
===============

Reporting
---------

Due to the lack of confidential issues in Github, we will move back to an email based reporting format.

Review
------

Code review of fixes will take place in a forked private repository.

Contributor License Agreements
==============================

These will continue to exist and be required for contributions to be accepted. The exact process for this still needs to be worked out with the Sangoma legal department. We are aware that solutions do exist for Github for doing this. Everyone will need to sign a new contributor license agreement. This will not be preserved from the legacy infrastructure.

Wiki
====

The wiki will move to a static format using its own Github repository.

Existing Generated Documentation
--------------------------------

The existing scripts for using the Asterisk XML and REST API documentation will be updated to produce output for the new static format. This will use Github Actions to update nightly, just like happens now.

Existing Documentation
----------------------

Applicable wiki documentation will be manually moved to the new wiki, or if possible it will be automatically converted.

New Content
-----------

Unlike previously with the wiki being contained within a Github repository the normal code review process will be done for all changes to the wiki. Upon merging the wiki will be automatically regenerated and updated.

Downloads
=========

We will maintain a downloads server, matching the layout of the existing downloads server. This is due to widespread use of the downloads server not just for Asterisk but for other things such as sound files, binary modules, firmware, and other things. It is also widely used by automation for downloading Asterisk itself. The new release process will automatically upload new releases to the downloads server.

Legacy Infrastructure
=====================

Existing Issues
---------------

We will not be recreating our existing JIRA issues on Github. We have no ability to determine the appropriate user, or the ability to create an issue as them. Instead we will, if JIRA allows and doesn't explode, bulk comment on existing issues that we have moved to Github and that the user is welcome to recreate their issue on Github.

Sunsetting
----------

For reference purposes we will maintain the old Atlassian and Gerrit infrastructure in a read-only state publicly for a period of time to be determined after the move to Github occurs and is completed.

Mailing Lists
=============

There will be absolutely no changes to the mailing lists. They will continue to exist and work as they do now.

 

