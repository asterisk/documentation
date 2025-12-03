---
title: Overview
pageid: 17793142
---

Asterisk Testing
================

Testing of Asterisk takes primarily three forms:

* Unit testing through the Asterisk Unit Test Framework
* Functional testing through the Asterisk Test Suite
* Formally defined system tests

The Asterisk Unit Test framework exercises individual units within Asterisk in a 'white-box', 'bottom-up' approach, verifying that an individual unit maintains its interface contract with the rest of the codebase. The Asterisk Test Suite operates at the next higher level by exercising the functionality of entire modules within Asterisk and how they interact with the core of Asterisk. This is typically more of a 'black-box', 'top-down' approach, although since the typical writer of tests within the Asterisk Test Suite are developers, some knowledge of the modules under test typically occurs. Both of these tests are automated, and are executed on a frequent basis. Contrasting both of these approaches are System tests, which are typically manual and exercise the interaction of many modules in Asterisk together. System tests often occur in conjunction with initial releases of major branches and on a less frequent, periodic basis. The diagram below illustrates where each of these forms of testing fall within the larger context of a testing philosophy.

Test Philosophy
Combined, the Asterisk Unit Test Framework and the Asterisk Test Suite allow the Asterisk development team to perform continuous integration, wherein changes are continually merged into the various supported branches and verified not to introduce major regressions. The unit tests and integration tests performed by these two frameworks guarantee that a basic level of functionality is not broken at any time by the introduction of a new feature or the fixing of a bug. Note that this does not mean that regressions do not occur between Asterisk versions, but that the risk associated with each check-in is reduced, and, as new tests are added, further minimized.

The Asterisk development team uses [Atlassian Bamboo](http://bamboo.asterisk.org/) to perform the continuous integration tests.

The Asterisk Test Suite
=======================

The Asterisk Test Suite is an open source project that manages functional testing of Asterisk. It orchestrates instances of Asterisk along with various third party protocol injection applications, allowing a developer to write tests that exercise a wide variety of the functionality within Asterisk.  While the Asterisk Test Suite is language agnostic, a set of libraries have been developed in Python and Lua to aid in test development.  Currently, the Python libraries receive the majority of development attention, and most tests are written in Python.
