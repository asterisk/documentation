---
title: Asterisk 14 Project - ARI and generic Text To Speech
pageid: 30279239
---

Project Overview
================




!!! info ""
    This is a draft. Please keep that in mind when commenting. Thanks!

      
[//]: # (end-info)





Text to Speech is nice. If nothing else, it let's you get a demo off the ground much faster. Doing something like this in ARI:

```
POST http://localhost:8088/ari/channels/12345/play/p1?media=tts:dude%20where%20is%20my%20car

```

Is much more preferable than having to record the sound, put it on the file system, and playback the new sound file. Sure, there's no beating Allison for professional sound, but if the goal is just to make a funny noise in a demo, TTS is great.

Plus, there are times where you can't have a sound file (dynamic data). In that case, TTS is your best option.

Unfortunately, Asterisk has a few limitations with TTS:

1. All current TTS engines are independent of each other; that is, there is no generic TTS wrapper that various APIs can use. That makes using a particular TTS engine problematic for ARI - either someone has to add a wrapper for each engine (ew), or we need a generic mechanism added to the core. You can imagine which approach this project page advocates.
2. All TTS implementations are different. Whether or not they cache the results, re-generate files, etc. is all handled differently. That's a bit suboptimal, since generally you don't want to be generating the same phrases every single time - and re-implementing caching logic is prone to obvious errors.

The goal of this project is two-fold:

1. Provide a generic TTS engine implementation engine in Asterisk with at least one reference implementation.
2. Add support to ARI for `/play` operations on a `tts` scheme.






Requirements and Specification
==============================



Configuration
-------------

### project.conf

#### [general]



| Parameter | Description | Type | Default Value |
| --- | --- | --- | --- |
| foo | Turns feature foo on or off | Boolean | True |
| bar | A comma delineated list of bar items (pun intended?) | String |   |

### RealTime schemas

APIs
----

Add an entry for each Application, Function, AMI command, AMI event, AGI command, CLI command, or other external way of interacting with the features provided by the project. Different APIs require different sets of documentation; in general, sufficient documentation should be provided to create the standard XML documentation for that particular item.

Design
======

For sufficiently complex projects, a high level design may be needed to illustrate how the project plugs into the overall Asterisk architecture. Sufficiently detailed design of the project should be provided such that newcomers to the Asterisk project are provided a conceptual view of the construction of the implementation.

Note that the design should be independent of the implementation, i.e., if the code is not drastically changed, it should not require updates to this section.

Test Plan
=========

Project should include automated testing, using either the Asterisk Unit Test Framework or the Asterisk Test Suite. Automated testing not only helps collaborators and reviewers verify functionality, but also helps to future proof new functionality against breaking changes in the future. A test plan maps Use Cases, User Stories, or specific APIs to tests that exercise that functionality. Test plans should be broken up by specific pieces of functionality, and should enumerate the tests for each function.

Each test description should provide, at a minimum, the name of the test, the test level (Unit, Integration, or System), and a description of what the test covers. For System level tests (which implies manual testing), a detailed description should be provided such that the test is reproducible by any third party.

Tests for Use Case: Bob calls Alice
-----------------------------------



| Test | Level | Description |
| --- | --- | --- |
| sip_basic_call | Integration | Test a basic call scenario between two SIP UAs and Asterisk |
| sip_uri_parse_nominal | Unit | Nominal parsing of SIP URIs |
| sip_uri_parse_off_nominal | Unit | Tests that ensure that off nominal SIP URIs are handled properly |
| sip_invite_request_test_nominal | Unit | Test INVITE request handling |

Project Planning
================

Provide links to the appropriate JIRA issues tracking work related to the project using the {jiraissues} macro (for more information on its usage, see [JIRA Issues Macro](https://confluence.atlassian.com/display/DOC/JIRA+Issues+Macro)). The sample below uses a public Triage filter - you will need to set up a JIRA issue filter for the macro to pull issues from that is shared with the **Public** group.

JIRA Issues
-----------

Contributors
------------



| Name | E-mail Address |
| --- | --- |
| unknown user | mjordan@digium.com |

Reference Information
=====================

Include links to code reviews, asterisk-dev mailing list discussions, and any other related information.

