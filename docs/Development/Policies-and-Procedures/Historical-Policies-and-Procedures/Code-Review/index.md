---
title: Overview
pageid: 27820111
---

Overview
========

The Asterisk project is dedicated to ensuring that the changes made to it are of the best possible quality. Code reviews are one way the project helps to ensure that the changes made are well understood and do not have adverse effects. As an open source project, it is up to all of us to ensure that the changes made to Asterisk improve the project for the good of everyone.

Code Reviews
============

Code reviews are done through [Gerrit](https://gerrit.asterisk.org). Everyone who wishes to submit a patch back to the Asterisk project are encouraged to submit the patch to Gerrit for code review. Patches submitted in this fashion are typically merged much faster than patches that are simply attached to a JIRA issue.

Git-specific code review policies can be found on the [Git Usage](/Development/Policies-and-Procedures/Historical-Policies-and-Procedures/Git-Usage) page. Instructions for using Gerrit can be found at [Gerrit Usage](/Development/Policies-and-Procedures/Historical-Policies-and-Procedures/Code-Review/Gerrit-Usage).




!!! note Licensing and Attribution
    By posting a patch to Gerrit, you agree that you are the author of the patch and that you have the license to contribute the code to the Asterisk project per the [Digium License Agreement](/Development/Policies-and-Procedures/Historical-Policies-and-Procedures/Patch-Contribution-Process/Digium-License-Agreement). If you are not the author of the patch, please arrange for the author to either post the patch themselves or comment on the respective JIRA issue that you have permission to contribute the patch to the project.  
[//]: # (end-note)



On This PageAdditional Information 

Review Workflow
---------------

1. The patch author posts the patch to Gerrit. Note that your commit message is part of the review, and will be reviewed in accordance with the project guidelines on [Commit Messages](/Development/Policies-and-Procedures/Commit-Messages).
2. The author should then cherry-picks the code change to all supported branches appropriate for the change.
	* The cherry-picks are reviewed in addition to the original patch. All cherry-picks, plus the original patch, must be reviewed and approved.
	* See [Software Configuration Management Policies](/Development/Policies-and-Procedures/Software-Configuration-Management-Policies) for instructions on which branches are appropriate for different change types, and [Gerrit Usage](/Development/Policies-and-Procedures/Historical-Policies-and-Procedures/Code-Review/Gerrit-Usage) for instructions on cherry-picking.
3. Other developers will review the patch. See the [Code Review Checklist](/Development/Policies-and-Procedures/Historical-Policies-and-Procedures/Code-Review/Code-Review-Checklist) for common items that developers will look for.
	* If there are findings, the patch author should resolve them. Commits should be squashed to preserve the overall commit for the entire patch.
	* When all findings are resolved, the patch author should re-submit the patch to the same review. See [Gerrit Usage](/Development/Policies-and-Procedures/Historical-Policies-and-Procedures/Code-Review/Gerrit-Usage) for instructions on updating a review.
4. When at least developer gives the review a `+1`, and no developers have given the review a `-1` or `-2`, a submitter will give the patch a `+2` and submit the patch.

Watching Code Reviews
---------------------

You can watch all code reviews that occur in the Asterisk project by subscribing to the [asterisk-code-review](http://lists.digium.com) mailing list. All submitted patches are sent to the [asterisk-commits](https://lists.digium.com) mailing list. If you are the author of a patch or you have been listed in the **Reviewers** field, you will be automatically e-mailed whenever a change occurs in a code review.

Unresolved Code Reviews
-----------------------

If a review has unresolved findings or a negative score for more than four weeks, your review will be closed out. This is to try and help peer reviewers find active reviews and not be distracted by code reviews that are no longer being actively supported by their author. If you find that your review is closed, you may always re-open it when you are able to resolve the findings.

New features that are abandoned in such a fashion will be closed as Suspended.

A Final Note on Code Reviews
============================

Often, as developers, we take a personal pride in our work. This is a Good Thing: we should be proud of the work that we do. Submitting your work for peer review will subject your work to criticism. This is not a bad thing.

The Asterisk project is bigger than any one developer. Ensuring quality for the project is the goal for everyone who participates in it, and sometimes that may result in findings against your code. It is not personal: the developers who participate in the Asterisk project are passionate about the success of the project and want the very best to go into it.

When participating in a code review, please remember the [Asterisk Community Code of Conduct](/Asterisk-Community/Asterisk-Community-Code-of-Conduct), and remember that we're all trying to make Asterisk the best possible open source communications engine.

