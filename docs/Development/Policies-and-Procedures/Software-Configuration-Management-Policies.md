---
title: Software Configuration Management Policies
pageid: 21464277
---

60%Overview
========

This page details the various branches of Asterisk, the focus of development in those branches, and what patches are allowed in a given branch.

Asterisk Configuration Management and Release Policies
======================================================

Development in the Asterisk project follows the **Mainline** branching model of Software Configuration Management. During a development year - typically kicked off at [AstriDevCon 2019](/Development/Roadmap/AstriDevCon-2019) - new features and bug fixes are integrated into the Asterisk project's [source control](https://gerrit.asterisk.org) `master` branch (hereafter referred to only as `'master`'). At the end of the developer year, the Asterisk development team makes a new major version branch from `master`. From all currently supported major version branches, tags are made on a periodic basis and released as minor version releases of that major version.

See [Asterisk Versions](/About-the-Project/Asterisk-Versions) for the approximate dates when a given version's development is started; when beta releases are created and announced; and when a major version branch is made and the first feature release made from that branch.




!!! info "**  For an excellent article on Software Configuration Management branching schemes and a description of the **Mainline"
    branching model, see [Branching Strategies by Stephen Vance](http://www.vance.com/steve/perforce/Branching_Strategies.html)

      
[//]: # (end-info)



On This Page 

Major Version Branch Types
--------------------------

The Asterisk project currently defines two different types of major version branches: Standard and Long Term Support (LTS). The type of branch dictates the types of features that receive focus during that period of Asterisk development as well as their supported maintenance lifetime.

### Standard Versions

When a Standard branch is being developed, all changes that improve the Asterisk project are candidates for inclusion. This includes fundamental architectural changes, modifications to APIs, and other substantial changes.

A Standard release receives bug fixes for a year after release, and security fixes for an additional year. At the end of this two year time span, branch maintenance is discontinued.

### Long Term Support (LTS) Versions

When a LTS branch is being developed, the focus of development is upon improving stability and the end user experience. Major architectural changes are not prohibited but should be avoided when possible.

A LTS release receives bug fixes for four years after release, and security fixes for an additional year. At the end of this five year time span, branch maintenance is discontinued.

Currently Supported Branches
----------------------------

Please refer to the [Asterisk Versions](/About-the-Project/Asterisk-Versions) page for more information on specific branch lifetimes.

Release Policies
----------------

When a release is made, a tag is made from the major version branch, or, in the case of security or regression bug fix releases, from the previous tag for that major version. The types of releases are described below.

### Feature Releases

The first release of a major version is a **feature release**, and contains all the new features developed for that new version of Asterisk. Each major version typically only has a single feature release (see [New Feature](#newfeatures) policy below).

### Point Releases

New versions of Asterisk are released on a periodic basis from all currently supported major version branches, typically every 4 to 6 weeks. These Asterisk releases are **point** releases, and primarily contain bug fixes for reported [issues](https://github.com/asterisk/asterisk/issues/jira) against those branches. Sometimes, these releases will also include improvements and new features. For more information about what is contained in a release, see that release's Change Log.

Sometimes, a sufficiently critical regression will be detected that will warrant an immediate regression release. These releases are made from the previous release's tag, as opposed to the major version branch.

### Security Releases

When a security vulnerability is reported against the Asterisk project (typically by e-mailing **security@asterisk.org**), bug marshals will create a private issue on the [issue tracker](https://github.com/asterisk/asterisk/issues/jira) and work to resolve the problem. Patches are made against all release branches that are currently within their security fix timeline and are made available at <http://downloads.asterisk.org/pub/security/>, along with a security advisory describing the vulnerability. Note that tags for security releases are made from the previous release's tag, and not from the major version branches.

Feature Policy
--------------

### Bug Fixes

Bug fixes are merged into all supported release branches that contain that particular bug. When dealing with multiple branches, it's hard to keep track of where comments are made so comments will always be made in the gerrit review for the lowest branch. The patch should therefore be submitted to gerrit against the *lowest* applicable branch, and cherry-picked to the other branches, including master. With controversial or large patches, it's highly recommended to submit *only* against the lowest applicable branch and wait for feedback before cherry-picking. This will save you the time and aggravation of re-cherry-picking your review after every comment. An Asterisk team member will usually give you the "OK to cherry-pick" comment when it's safe for you to do so.  Note that in some very rare cases, a bug fix may be deemed too intrusive in a particular branch. Such cases are discussed when the patches are proposed.

 

ExampleA bug is reported against Asterisk 13. The current supported branches are 13, 16, 18 and 19. You should submit your patch to gerrit for the 13 branch. To avoid having to re-cherry-pick to the other branches, you stop there and wait for feedback. If you get negative feedback, you address it and re-submit the review. When an Asterisk team member sees that you have enough "+1" votes on your review, they'll add an "OK to cherry-pick to the other branches" comment which you can then do. Usually a "+2" to start the test and merge process will follow shortly.

 




!!! tip 
    See [Git Usage](/Development/Policies-and-Procedures/Historical-Policies-and-Procedures/Git-Usage) and [Gerrit Usage](/Development/Policies-and-Procedures/Historical-Policies-and-Procedures/Code-Review/Gerrit-Usage) for more information on cherry-picking between Asterisk branches.

      
[//]: # (end-tip)



 

 

 

 




### New Features

New features are classified as patches that either:

* Improve on existing functionality in Asterisk (better implementation, improved performance, etc.)
* Add new functionality to Asterisk

New features should follow the same procedure as bug fixes however they are, subject to the following conditions:

* Any new feature proposed for an existing release branch must have suitable test coverage using either the Asterisk Test Suite, the Asterisk Unit Test Framework, or both.




!!! tip 
    Tests are always good and encouraged, especially for new features. Having tests is a mandatory requirement for new features in release branches to minimize the risk of regression.

      
[//]: # (end-tip)

* The new feature or improvement must be backwards compatible with the previous releases in those major versions. That is, users upgrading from one point release to the next should **not** be aware of any new feature or improvement unless they want to use said feature. Some things that should **not** be changed naturally follow from this:
	+ APIs that follow semantic versioning should not receive a major version increase.
	+ Configuration and database schemas can be added to or updated, but users should not be required to update their configuration or databases.
* Any new features or improvements **must** be included in the first release candidate of a new version. First release candidate announcements must be made to the `asterisk-users` mailing lists, with at least a week of testing time allowed. If a new feature or improvement is deemed to cause an inappropriate burden on end-users, it **must** be removed from the release.

Generally, new features or improvements should always be done as new modules where possible, and those modules should be disabled if included in a release branch. If changes are necessary to the Asterisk core, all care possible should be given to not impact existing modules.

Note that if a new feature radically changes the architecture of Asterisk and the next planned major version branch is an LTS branch, you may be asked to defer the change until the next Standard branch is being developed.

Major Version Stability
=======================

Once a major version branch has been made, all effort shall be made by Asterisk developers to not introduce breaking changes into that major version.

What is a breaking change?

A breaking change is any that invalidates a previous configuration or changes the way in which an application interfaces to Asterisk either implicitly or explicitly. Adding items to a configuration or information presented to an application is not a breaking change as it does not invalidate an existing configuration or require modifications to a well-written application. To that end, the following items should not be invalidated within a major version branch:

* AMI Actions and Events
* AGI Commands and Responses
* Dialplan Applications, Functions, and pattern matching rules
* Configuration file settings
* Realtime database schemas
* CLI Commands and Responses
* CDR/CEL behavior




!!! warning 
    Within a major version branch, there are times when a breaking change must be introduced - usually to fix a serious, critical bug within that branch. Or because we switched source control systems. When this occurs, the UPGRADE text file delivered with Asterisk will be updated noting the change.

      
[//]: # (end-warning)



The following items **can be changed** between minor versions in a major version branch:

* Log file output

Asterisk Version Numbers
========================

Asterisk uses three digits in its version number sequence:

*major***.***minor***.***patch*

* **Major** - denotes which major version branch the release was made from.
* **Minor** - denotes a release version. These increase sequentially for each release.
* **Patch** - denotes that the release was either a security release made from the previous release, or a release made to fix regressions or serious bugs detected in the release.




!!! note 
    Over the years, the Asterisk version numbers have changed. A lot. For anyone who has ever had to write a script that parses Asterisk version numbers, we apologize. We'll try hard not to change it again.

      
[//]: # (end-note)



