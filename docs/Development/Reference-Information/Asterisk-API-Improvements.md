---
title: Asterisk API Improvements
pageid: 30278926
---

Overview
========

Asterisk's APIs generally use [Semantic Versioning](http://semver.org/). This means that changes to the APIs that are not backwards compatible (such as renaming a field, fixing casing, etc.) necessitate a major version bump.

This page serves as a collection of minor improvements that should be done to the APIs when it is decided to create a new major version. These improvements should be proposed and made at that time.

AMI Improvements
================

* The QueueMember event raised as a result of a QueueStatus AMI action still refers to the channel name using the field `Location` instead of the new `Interface` field name.
* The GetConfig action response event violates the AMI protocol when there are no requested categories found.  It emits "No categories found" on a line by its own without a header.  It should be "Error: No categories found" so that the line starts with a header.
* The ListCategories action response case when there are no categories found should be changed from "Error: no categories found" to "Error: No categories found".
* The AMI actions that generate a list of events should send a capitalized "Start" value instead of the lowercase "start" for the EventList header.  Currently, all list actions but the FaxSessions action uses lowercase start.  To make the capitalization consistent the *astman_send_listack()* function should have the *listflag* parameter removed and internally supply "Start".
* Unify responses for AMI actions 'ModuleLoad' (when used to reload) and 'Reload'. Currently the text for each action's responses is inconsistent with the other and 'Reload' doesn't differentiate output between reloading all modules and just reloading a single module.
* Remove the `Version` field from the `ModuleCheck` Action (see `manager_modulecheck`).
* `res_pjsip_outbound_registration.c:ami_register()`  Copy/paste error "Failed to queue unregistration" message given when failed to queue the register action.  The message should be "Failed to queue registration".
