---
title: Project Planning Template
pageid: 21463986
---

Instructions
============


To use this template as the basis for a new page, do the following:


1. Click **Add**->**Page**
2. In the blank New Page, click **Select a page template to start from.**
3. In "Step 1: Choose a page template", select **Project Planning Template** and click **Next >>**
4. This will automatically fill in the New Page with the template below.


Description
===========


Each major project being performed for a targeted release of Asterisk should have a project page on the Asterisk wiki. The purpose of a project page is to provide a point of reference for the project for Asterisk contributors.


Please use this page as a template for your projects under the Roadmap Section.



Remove this section ("Description") for your project.


3
Project Overview
================


This section should provide a description of the project and its goals. Appropriate information here would include:


* Motivations behind the project. If replacing/refactoring an existing module, sufficient motivation should be provided to justify the risk of the project. If new functionality, a description of the benefits the project adds to Asterisk should be noted.
* The end product of the project, e.g., a new channel driver, resource module, or some functionality.


Requirements and Specification
==============================


The purpose of this section is to provide the minimum requirements the project must fulfill. This can take several forms depending on the project; project developers should choose the schemes that best fit the project they are developing. This section should also provide details about the project from an end-user perspective. This can include dialplan configuration, sample configuration files, API descriptions, etc.


If needed, break this section up into multiple subsections. Several subsection examples are provided below; feel free to use/remove these as your project dictates.



If sufficiently complex, subpages should be used to provide reference information. In particular, sufficiently large configuration schemas and detailed API descriptions may benefit from their own subpage.


Use Cases
---------


Assuming a use case approach is used, the following can be used as a model.


### Use Case: Bob calls Alice


Actor: Alice  

Actor: Bob


Scenario:


* Bob picks up his phone. He dials Alice's extension.
* Bob hears a ringing indication.
* Alice's phone rings.
* Alice picks up her phone.
* Both Bob and Alice's phones stop ringing.
* Both Bob and Alice can talk to each other and hear the other person.


User Stories
------------


Assuming a user story approach is used, the following can be used as a model.


* As a user of a SIP phone, I want to be able to pick up my SIP phone, dial an extension, and hear a ringing indication while I wait for the other phone to be picked up.
* As a user of a SIP phone, I want to be able to speak with another user using a SIP phone if they answer when I call them.


Configuration
-------------


### project.conf


#### [general]




|  Parameter  |  Description  |  Type  |  Default Value  |
| --- | --- | --- | --- |
|  foo  |  Turns feature foo on or off  |  Boolean  |  True  |
|  bar  |  A comma delineated list of bar items (pun intended?)  |  String  |   |


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




|  Test  |  Level  |  Description  |
| --- | --- | --- |
|  sip\_basic\_call  |  Integration  |  Test a basic call scenario between two SIP UAs and Asterisk  |
|  sip\_uri\_parse\_nominal  |  Unit  |  Nominal parsing of SIP URIs  |
|  sip\_uri\_parse\_off\_nominal  |  Unit  |  Tests that ensure that off nominal SIP URIs are handled properly  |
|  sip\_invite\_request\_test\_nominal  |  Unit  |  Test INVITE request handling  |


Project Planning
================


Provide links to the appropriate JIRA issues tracking work related to the project using the {jiraissues} macro (for more information on its usage, see [JIRA Issues Macro](https://confluence.atlassian.com/display/DOC/JIRA+Issues+Macro)). The sample below uses a public Triage filter - you will need to set up a JIRA issue filter for the macro to pull issues from that is shared with the **Public** group.


JIRA Issues
-----------



The configuration of Jira/Confluence still needs a few tweaks to show the issues in the macro below. --Matt


true
Contributors
------------




|  Name  |  E-mail Address  |
| --- | --- |
|  Matt Jordan  |  mjordan@digium.com  |


Reference Information
=====================


Include links to code reviews, asterisk-dev mailing list discussions, and any other related information.

