---
search:
  boost: 0.2
title: Issue Tracker Workflow
pageid: 3702839
---

Overview
========

This document describes how issues move through the [Asterisk Issue Tracker on GitHub](https://github.com/asterisk/asterisk/issues). It is most beneficial for Asterisk bug marshals; however, it is also good reading for anyone who may be filing issues or wondering how the Asterisk Open Source project moves issues from filing to completion.

!!! warning 
    Security vulnerability issues must NEVER be reported as regular bugs in the issue tracker. Instead they must be reported at [Security Vulnerabilities](https://github.com/asterisk/asterisk/security/advisories/new). You can reach this page by navigating to <https://github.com/asterisk/asterisk> and clicking the "Security" tab at the top of the page.

[//]: # (end-warning)

On This Page

Issue Tracker Workflow
======================

The workflow in the issue tracker is handled in the following way:

1. A bug is reported and is automatically placed in the **Triage** status.
2. The Bug Marshall team should go through bugs in the **Triage** status to determine whether the report is valid (not a duplicate, hasn't already been fixed, not a tech support issue, etc.). Invalid reports should be set to 'Closed' with the appropriate resolution set. Categories and descriptions should be corrected at this point.

!!! note 
    Issues should also have enough information for a developer to either reproduce the issue or determine where an issue exists (or both). If this is not the case then the issue should be moved to 'Waiting for Feedback' with the appropriate information requested. See [Asterisk Issue Guidelines](/Asterisk-Community/Asterisk-Issue-Guidelines) for more information on what an issue should have before it is accepted.

[//]: # (end-note)

3. If a patch has been created for the issue, it is acceptable to modify the summary with the text "[patch]" to indicate that a patch is available for the issue. If a patch has been included with the issue, it should be submitted for [Code Review](/Development/Policies-and-Procedures/Historical-Policies-and-Procedures/Code-Review) on [Gerrit](https://gerrit.asterisk.org).
4. The next step is to determine whether the report is about a bug or a submission of a new feature:
	* BUG: A bug should be moved into the **Open** status by clicking *Acknowledge* if enough information has been provided by the reporter to either reproduce the issue or clearly see where an issue may lie. The bug may also be assigned to a developer for the creation of the initial patch, or review of the issue.
	* FEATURE: New features must be filed with a patch. As such, the issues can be immediately moved into the **Open** status by clicking *Acknowledge*. For more information on submitting new features to the Asterisk project, see the [New Feature Guidelines](/Development/Policies-and-Procedures/Historical-Policies-and-Procedures/Patch-Contribution-Process/New-Feature-Guidelines) guidelines. Note that new features that are not put up for code review by the author are likely to be closed as "Suspended."
5. If at any point in the workflow, an issue requires feedback from the original poster of the issue, the status should be changed to **Waiting for Feedback**. Once the required information has been provided, it should be placed back in the appropriate point of the workflow by using the *Send Back* button.
6. If at any point in the workflow, a developer or bug marshal would like to take responsibility for doing the work that is necessary to progress an issue, the issue can be assigned to that developer and the issue moved into the **In Progress** state. At that point the developer assigned to the issue will be responsible for moving the issue to completion.

Workflow Summary
================

The following is a list of valid statuses and what they mean to the work flow.

Triage
------

This issue is awaiting review or in review by bug marshals. Categorization of the issue, summary, description, version, and other related information should be fixed as appropriate. See the [Asterisk Issue Guidelines](/Asterisk-Community/Asterisk-Issue-Guidelines) for more information.

### Waiting for Feedback

This issue requires feedback from the poster of the issue before any additional progress in the workflow can be made. This may include providing additional [debugging](/Operation/Logging/Collecting-Debug-Information) information, or a [backtrace](/Development/Debugging/Getting-a-Backtrace-Asterisk-versions-13.14.0-and-14.3.0) with `DONT_OPTIMIZE` enabled, for example.

### Open

This is a submitted bug or new feature (with patch!) which has yet to be worked either by an Asterisk developer, but appears to be a valid bug or new feature based on the description and provided debugging information.

!!! info "**  An issue can also be in the **Reopen** state, indicating that it was closed but reopened for some reason. This state is semantically the same as **Open"
    .

[//]: # (end-info)

### In Progress

This is an issue which is currently being actively worked by an assigned developer. At this stage, it would be appropriate to have a patch being developed or attached to the issue for review.

### Closed

The issue has been resolved, and a patch has either been committed or the issue has been rejected for some reason.

Severity Levels
===============

Severity levels can be selected for an issue and may be viewed by bug marshals as a way to categorize issues for priority; however, a high priority does not necessarily entail that any bug marshal will treat that issue with any greater urgency.

!!! warning 
    The **Blocker** severity may be used by bug marshals as a way to indicate that the Asterisk developer community has decided that an issue is of such critical importance that it should prevent release of a new version of Asterisk in the affected branches. In general, this status should be used sparingly and may warrant discussion on the issue tracker if assigned to an issue. Issue reporters should not select the **Blocker** severity.

[//]: # (end-warning)

Notes
=====

1. Using the filters in Jira - such as the [Triage (Supported)](https://github.com/asterisk/asterisk/issues/jira/secure/IssueNavigator.jspa?mode=hide&requestId=11493) filter is - useful for finding issues that need attention quickly.
2. The issue tracker now has the ability to monitor the commits list, and if the [commit message](/Development/Policies-and-Procedures/Commit-Messages) contains the appropriate tag, e.g., "Fixes: #99999", the bug will automatically be linked then closed when the  pull request is merged.
