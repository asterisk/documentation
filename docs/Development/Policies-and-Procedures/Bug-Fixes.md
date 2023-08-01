---
title: Bug Fixes
pageid: 47874733
---





Overview
========

This page documents the policy surrounding bug fixes.

On This Page



Policy
======

Bug fixes are to be put up for review against each currently supported branch (for example 18) that they are applicable to. Tests (unit tests, Asterisk testsuite tests, or both) should be included if possible to ensure that a regression does not occur in the future.

Regressions
===========

If a bug fix causes a regression the project may choose to revert the change in question instead of fixing it at the time of regression. To include the bug fix again into the tree the regression would need to be fixed by the original contributor, or another individual.

Bug Fixes Against Deprecated Modules
====================================

While bug fixes are permitted against deprecated modules, the project may choose not to accept them if it is determined that a risk of regression is too high.Changes In Review When Branch Goes Security Fix Only
====================================================

 When a branch goes into a security fix only status any changes up for review that are up against the specific branch can remain and be reviewed, or be abandoned at the discretion of the contributor or the project. New cherry picks into the branch, even if a review against a different branch was present before the security fix only date, are not permitted unless to resolve a security related issue.

