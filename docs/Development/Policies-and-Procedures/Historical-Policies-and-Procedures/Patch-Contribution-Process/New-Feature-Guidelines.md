---
title: New Feature Guidelines
pageid: 21464432
---

Overview
========

At some point in time, you may find yourself asking, "I wish Asterisk did [new cool feature]". The great news about Open Source software is that if you really want, you can make Asterisk do [new cool features]! But after you make your local copy of Asterisk do [new cool feature], you may find yourself wishing that you didn't have to patch Asterisk every time you need to upgrade a system. At which point, you'll want to have your feature included in the Asterisk source.

This page describes how new features move through the Asterisk development process. For more information on general issue workflows, see .

On This Page1

Before You Begin...
===================

Before writing a new feature for Asterisk, there are multiple things to consider.

* Is the feature general purpose enough that it is appropriate for all Asterisk consumers?
* Is the feature appropriate for the next major version release?
* How can I help reviewers of the feature verify its correctness?
* How can I help Asterisk developers maintain the new feature, once it is included?

Is a New Feature Appropriate?
-----------------------------

Whether or not a new feature is appropriate for inclusion in Asterisk is a tricky question. If you're considering adding a new feature to Asterisk, you obviously find it useful! However, not everyone uses Asterisk the same way, and features added to Asterisk should be as generally applicable to everyone as possible.

Some questions you should ask yourself when thinking about whether or not your feature is appropriate in Asterisk:

* Does the new feature contain logic that is specific to an Asterisk deployment scenario?
* Can the new feature be implemented using Asterisk interfaces and without modifying the Asterisk source?
* Does the new feature change long standing Asterisk conventions?

If the answer is **No** to all of the above questions, then the feature may be appropriate for Asterisk. A **Yes** to any of the above questions does not invalidate the new feature, but it may mean that discussion on the [asterisk-dev mailing list](http://lists.digium.com/mailman/listinfo/asterisk-dev) is appropriate before submitting the patch to the issue tracker. If in peer review, you may be asked to change the feature to make it more suitable.

At any time, it is always appropriate to discuss new features on the [Asterisk Developer's Mailing List](http://lists.digium.com/mailman/listinfo/asterisk-dev). Whether or not a patch is appropriate for Asterisk can often be subjective, and getting the consensus of the Asterisk developer community on the design of a feature before starting implementation is often a wise decision.

 

Some case studies illustrating features that could be considered for inclusion in Asterisk and why or why not they are appropriate are below.

whiteCustom Device State Providersolid50%**Feature Description**50%**Analysis**50%* A new module that intercepts device state from a set of configurable devices and modifies the state that is passed to subscribers
* Example:
	+ Alice subscribes to Bob's presence
	+ The module forces Bob to be Not Available during the evenings, but only for Alice. If someone else subscribes to the device state (say, Charlie), they see Bob as his original status at all times.
50%* Most likely does not belong in Asterisk.
	+ Very difficult to implement without hard coding business logic into the module itself. Once custom logic is hard coded, its difficult to remove and creates a moving target for development/maintenance.
	+ Because the business logic will almost have to be hard coded in the module, this feature most likely is better served by being provided as a separate module outside of Asterisk itself.
whiteMachine Parseable CLI Commandsolid50%**Feature Description**50%**Analysis**50%* Add a new CLI command 'motif show channel concise' that dumps Motif channels in a machine parseable format.
50%* Most likely does not belong in Asterisk.
	+ Closely duplicated by existing functionality ('core show channels concise')
	+ Dumping machine parseable information in the CLI is a practice that is discouraged. Interfaces suitable for external application development exist, and the CLI is better served for human interaction.
whiteVideo Capable Jitter Buffersolid50%**Feature Description**50%**Analysis**50%* Make the Asterisk jitter buffers handle video frames.
50%* Has to be done in Asterisk.
	+ Feature has general applicability.
	+ Cannot be done outside of Asterisk.
Is the Feature Appropriate for the next Major Version?
------------------------------------------------------

Each year, the Asterisk [trunk](http://svn.asterisk.org/svn/asterisk/trunk) is made into a major version branch. Periodically, releases are made from the major version branches. There are two types of major version branches, **Standard** and **Long Term Support (LTS)**. The two types differ both in their supported lifetimes as well as their development focus.

If a new feature changes the architecture of Asterisk or has a particularly large impact on core functionality, the preference is to have that new feature released in a Standard release. LTS releases should include new features that enhance the Asterisk experience, but should avoid major internal changes that fundamentally alter behavior.

Some examples are listed below. Note that Standard releases can include any new feature, and hence new features that are appropriate for an LTS release are technically appropriate for any Asterisk release.



| Change | Preferred Release | Analysis |
| --- | --- | --- |
| Change the structure and representation of media formats within Asterisk | Standard | Not only did this change add new functionality, but it had a ripple effect throughout the code base requiring all consumers/producers of media to change. Due to its large scope, it was more appropriate for a Standard release. |
| Hangup Handlers | Any | While hangup handlers did require some changes in the Asterisk core, they were limited in scope and were easy to define - that is, we had to concern ourselves with locations where the 'h' extension would be executed, but the behavior of the 'h' extension was not altered. |
|  | Standard (debatable) | On its face, T.38 gateway appears to be a feature that is relatively non-intrusive, as much of its handling exists in a separate resource module (res\_fax). However, in order to enable/disable gateway mode, chan\_sip had to be able to maintain some rather complicated state information. This was relatively tricky, as chan\_sip does not have a modular design and does not lend itself well to code changes. It was best handled in a Standard release; if chan\_sip was more flexible, then this could potentially have been done in an LTS release. |
|  | Any | While Unique Call ID Logging affected a large number of modules (channel drivers + the logging core, as well as other core modules), the changes were relatively small and unintrusive. In addition, if a module chose not to make use of the Unique Call IDs for log messages, it still behaved exactly the same. The fact that the behavior is optional is what makes this easy to justify in an LTS release. |

If your feature is deemed to be intrusive or risky for an LTS release and you are asked to hold off on including it, a branch can be set up to maintain the feature in parallel with the current Asterisk trunk using automerge. See  for more information.

testing

Is the Feature Correct?
-----------------------

There are many ways of testing a new feature. The simplest, and most common, is the 'developer test', where the developer of a new feature verifies that it works on their development machine. While this is good, as the complexity of a new feature increases, the more difficult it becomes to verify that the new feature (a) works as intended and (b) does not adversely impact other Asterisk features.

Testing your new feature is **extremely** beneficial to those who have to review, approve, and maintain your feature. See Testing for more information.

It is **highly** recommended that all new features have tests, either using the Asterisk Unit Test framework or the Asterisk Test Suite. If you need help writing tests for your new feature, be sure to ask on the asterisk-dev mailing list! Many developers are experienced in writing unit tests and functional tests, and would be happy to help point you in the correct direction.

 

maintainability

Is the Feature Maintainable?
----------------------------

Maintainability is a tricky proposition. When a developer writes a new feature, the implementation makes perfect sense! However, not all developers view code the same way, and even the same developer - upon revisiting code at a later date - may forget why something was implemented the way it was. These problems are compounded by code complexity, differences in coding standards, and poorly abstracted design.

Making your new feature maintainable goes a long way to getting it included in Asterisk. Features that fit well within the Asterisk architecture; are easy to inspect and test; and impact as little existing code as possible are much easier to incorporate than features that are not well compartmentalized. The following are a list of questions to ask yourself when you're writing your new feature that will help in making the feature maintainable:

* Are you following the established Asterisk coding guidelines?
* Are you using all of the appropriate Asterisk libraries, and are you using them for their intended purpose?
* Have you thought about how your code will be tested?
* Can the new feature exist in a separate module?
* Are the places where the new feature interacts with existing code well understood? By that, think about:
	+ Locking and threading concerns
	+ Reference counting issues
	+ Memory leaks/corruption
	+ Potential performance impacts
* Do you need to refactor any existing code to make the new feature easier to understand and verify?

New Feature Development
=======================

New features are developed against Asterisk [trunk](http://svn.asterisk.org/svn/asterisk/trunk/). You may propose that a feature be included in a release branch as well, if the feature is appropriate for the type of release branch. New features included in a release branch **must** have accompanying automated tests. See  for more information about the various branches in Asterisk.

In general, there are very few "requirements" when developing a new feature. Where something is required, it is specifically noted that developers **must** perform some action. However, the following guidelines exist to help you get your feature into Asterisk. The fewer of these guidelines that are followed, the more burden is placed on the Asterisk developer community to review and verify the correctness of your feature for you. This may limit the speed at which your feature can be incorporated into Asterisk.

Planning
--------

### JIRA Issues

New features and improvements can have an issue in JIRA, if there is a developer who is assigned and working the issue. Once the new feature or improvement has been made, a patch should be made and placed on the issue.

Note that you must sign a  to contribute any code back to the Asterisk project.

### Wiki Pages

It is generally recommended that developers for major new features create a page on the wiki using the  under the  section's page for the next major Asterisk version. Even before implementation of a new feature begins, basic requirements and design can be documented and discussed.

How to Know if Your Project Warrants a Planning PageWhile there is no hard and fast rule that determines whether or not you should write a wiki page for your project, here are some things to keep in mind:

* Do you have a team branch for the new feature?
* Do you want assistance in the development or testing of the feature?
* Does the feature span multiple files or modules in Asterisk?
* Does the feature change some portion of the Asterisk architecture?
* Does the feature require unit or integration tests to verify its requirements?

In general, **any** project benefits from a project page - but if your project is deemed to be sufficiently complex, you may be asked to create one.

When starting a major new feature, an e-mail **should** be sent to the [Asterisk Developer's Mailing List](http://lists.digium.com/mailman/listinfo/asterisk-dev) announcing the development of the feature. This announcement can also be used to discuss whether or not the feature is appropriate for inclusion in Asterisk. If you feature impacts an Asterisk interface, you may also consider announcing the development of the feature on the [Asterisk Application Development mailing list](http://lists.digium.com/pipermail/asterisk-app-dev/).

Periodically, it is recommended that the primary developer for a new feature send updates to the Asterisk Developer Mailing List updating the community with the status of the project.

Testing
-------

All new features should have automated tests. New features that are proposed for an existing release branch **must** have accompanying tests.

Help is Available!The Asterisk project has spent a significant amount of time investing in both the Asterisk Unit Test framework and the Asterisk Test Suite. Developers are more than happy to help you with these frameworks in #asterisk-dev or on the asterisk-dev mailing list - don't be afraid to ask for help!

### Test Plans

New features with a project plan on the wiki can document their test plans, which is useful both in the outlining of the new feature as well as to gain help on testing a feature. Each major requirement of a new feature should have some level of test coverage to help verify its functionality. Tests that exist at the Unit or Integration level may use the Asterisk Unit Test Framework or Asterisk Test Suite, respectively.

### Test Resources

The Asterisk project provides a number of ways to help you test your feature:

* Unit tests, using the [Asterisk Unit Test Framework](http://svn.asterisk.org/svn/asterisk/trunk/include/asterisk/test.h).
* Functional/Integration tests, using the Asterisk Test Suite.
* Beta testing with the Asterisk community, conducted as part of a major version release cycle. Note that all major versions go through a beta test cycle.

Making use of the Unit Test Framework and the Asterisk Test Suite is **highly encouraged** for all new features. Tests written for either framework are automatically included in the Asterisk project's [continuous integration](http://bamboo.asterisk.org/myBamboo.action) activities. This helps not only to verify the correctness of the new feature, but also make it maintainable (see the next section).

Individual tests at any level are not guaranteed to catch all bugs. The types of bugs caught in Unit or Integration tests often differ greatly from the types of tests caught in System or Beta tests. Taken as a whole, testing at all layers builds a safety net that guarantees that new features provide the basic functionality that they promise, as well as not impact other areas of the code base.

Implementation
--------------

Implementation is left up to the developers working on the new feature. The project does provide several resources to collaborate on a new feature:

* The [asterisk-dev](http://lists.digium.com/mailman/listinfo/asterisk-dev) mailing list can and should be used for any and all discussions about code
* The #asterisk-dev IRC channel on [Libera Chat](https://libera.chat/)
* The Asterisk wiki contains substantial information in the  section. In particular, be mindful of the .
* For developers with commit access, team branches can be used to help keep a new feature in sync with particular branches. See  for more information about team branches.

When implementation is complete, patches should be attached to the JIRA issues and the new feature put up for . Be sure to read the , as well as the  prior to putting the patch up for review.

 

resources

Resources
=========

The following resources exist to help you when writing a new feature for Asterisk. Your best resource, however, are other Asterisk Developers. Never hesitate to use the mailing lists and IRC channels to discuss a feature or an issue you may be facing.

Planning
--------

* - used for describing a new feature and coordinating plans.
* - major goals for Asterisk versions, and descriptions of new features and improvements being proposed and worked on for the next major version.
* - current new features and improvements open in the issue tracker, but not yet committed to SVN.

Development
-----------

* [Issue Tracker Workflow](https://wiki.asterisk.org/wiki/display/AST/Issue+Tracker+Workflow) - how issues are moved through the public Asterisk project.
* [Code Review](https://wiki.asterisk.org/wiki/display/AST/Code+Review) - how code reviews are performed. This contains links to lots of other useful information, including:
	+ [- How to use Gerrit for code reviews.](https://wiki.asterisk.org/wiki/display/AST/Review+Board+Usage)
	+ [Coding Guidelines](https://wiki.asterisk.org/wiki/display/AST/Coding+Guidelines) - **Follow these for all C code**. For Python code, use PEP8. For other code, try to match the project you are working in.
	+ [Code Review Checklist](https://wiki.asterisk.org/wiki/display/AST/Code+Review+Checklist) - useful things to keep in mind when reviewing code (and before putting your code up for review)
* [Commit Messages](https://wiki.asterisk.org/wiki/display/AST/Commit+Messages) - how to write proper commit messages.
* [- information on the available Git repositories.](https://wiki.asterisk.org/wiki/display/AST/Subversion+Usage)
* [Repotools](https://wiki.asterisk.org/wiki/display/AST/Repotools) - useful tools that are needed for the Asterisk SVN repositories.
* Debugging:
	+ [How to collect debug information](https://wiki.asterisk.org/wiki/display/AST/Collecting+Debug+Information).
	+ Getting [crash information](https://wiki.asterisk.org/wiki/display/AST/Getting+a+Backtrace).
	+ [Debugging deadlocks](https://wiki.asterisk.org/wiki/display/AST/Getting+a+Backtrace#GettingaBacktrace-GettingInformationForADeadlock).

Testing
-------

* [Bamboo](https://bamboo.asterisk.org) - continuous integration server
* [Asterisk Test Suite](https://wiki.asterisk.org/wiki/display/AST/Asterisk+Test+Suite+Documentation) - useful information on setting up and writing tests
