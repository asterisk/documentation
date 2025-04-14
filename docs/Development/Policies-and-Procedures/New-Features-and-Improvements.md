---
title: New Features and Improvements
pageid: 47874728
---

Overview
========

This page documents the new feature and improvements acceptance policy in Asterisk.

On This Page

Policy
======

Asterisk allows new features and improvements to be placed into current supported branches, including master, if they maintain ABI compatibility. If ABI compatibility can not be maintained then they are only eligible to be included in master for the next major release of Asterisk. Exceptions to this policy may be provided if the new feature or improvement is substantially important to the project (for example implementing a newly mandated specification). All new features and improvements must include test coverage (through unit tests if applicable and the Asterisk testsuite) if possible including changes applicable only to master.

New Features And Improvements Against Deprecated Modules
========================================================

If a module is marked as deprecated in the future and scheduled for removal then new features and improvements will not be accepted against it. These new features and improvements should be done against the module which is replacing it, if available and applicable, instead.

Decision Not To Accept A New Feature Or Improvement
===================================================

While we understand that contributors prefer that new features and improvements they create become part of Asterisk, it is not always possible for the Asterisk project to accept them. This may be because the feature or improvement is extremely specialized, or because it would see little to no use by others. Having a specialized or limited use feature or improvement in Asterisk makes the project responsible for all aspects of the feature or improvement and will consume time that would be otherwise used on non-specialized or widely used capabilities. Therefore, the Asterisk project may choose not to accept a new feature or improvement. Such decisions are not taken lightly and are done in consultation with the asterisk-dev mailing list.

!!! note 
    If a new feature or improvement patch is submitted for review on Gerrit without prior discussion, and a reviewer voices an opinion to not allow the new feature or improvement, or desires more discussion about it then the review may be suspended (given a -2), and the submitter will be required to create a new post to initiate further discussion on the asterisk-dev mailing list about the change, and why it should be allowed in.

[//]: # (end-note)

If the discussion concludes in acceptance, then the new feature or improvement, even if specialized or of limited use, will be accepted. If the discussion concludes in the new feature or improvement not being accepted then as a courtesy a JIRA issue can remain open for the new feature or improvement with patch attached to allow others to download and use it. If the JIRA issue sees comments indicating it has become a widely used feature or improvement the decision can be revisited by posting to the asterisk-dev mailing list. If you have ideas for module additions that might make Asterisk more useful for a smaller subset of the user base, consider creating a GitHub repository of your own that builds those modules out-of-tree (as opposed to a fork of Asterisk). If your changes become popular we can consider including them in the base Asterisk distribution at a later date when contributed using the normal contribution method.

Regressions
===========

If a new feature or improvement causes a regression the project may choose to revert the change in question instead of fixing it at the time of regression. To include the change again into the tree the regression would need to be fixed by the original contributor, or another individual.

Large Number Of Commits
=======================

If an overall change consists of a large number of commits (such as across the tree spelling fixes or doxygen fixes) please reach out to the [asterisk-dev mailing list](https://groups.io/g/asterisk-dev) for guidance on the best way to put the change up for review before doing so. Depending on the number of commits you may be asked to squash them into a single commit for a review, instead.

Changes In Review When Branch Goes Security Fix Only
====================================================

When a branch goes into a security fix only status any changes up for review that are up against the specific branch can remain and be reviewed, or be abandoned at the discretion of the contributor or the project. New cherry picks into the branch, even if a review against a different branch was present before the security fix only date, are not permitted unless to resolve a security related issue.
