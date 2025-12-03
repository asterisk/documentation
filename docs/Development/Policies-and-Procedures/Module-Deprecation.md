---
title: Module Deprecation
pageid: 44800471
---

Overview
========

This page documents the module deprecation process in Asterisk. This allows a module to be deprecated with notice and to eventually be removed.

On This Page

Policy
======

Asterisk follows a 2 year module deprecation process. A module is initially marked as deprecated and set not to be built by default in a standard release which is carried over to the next long term supported release. This provides a period of 2 releases and thus 2 years where the module is marked as deprecated. In the next standard release the module is then removed from the source code tree entirely which is carried over to the next long term supported release. As an example (note that this has not occurred),

1. The app_alarmreceiver is marked as deprecated in master and set not to build by default
2. Previous version branches (such as 16 and 18) are updated with the version in which app_alarmreceiver is to be deprecated (19) and the version it is to be removed (21) to display it to the user
3. The Asterisk 19 (standard release) branch is created from master with app_alarmreceiver marked as deprecated and set not to build by default
4. The Asterisk 20 (long term supported release) branch is created from master with app_alarmreceiver marked as deprecated and set not to build by default
5. The app_alarmreceiver module is removed from master
6. The Asterisk 21 (standard release) branch is created from master with app_alarmreceiver removed
7. The Asterisk 22 (long term supported release) branch is created from master with app_alarmreceiver removed

During the time at which the module is deprecated in both a standard and long term supported release feedback is taken from the community as to the continued use of the module, through forum posts, mailing list posts, and issues. Notice of deprecation and removal is given as part of the release notes for the respective versions, as well as release notes and warnings in older releases. This serves to give as much notice as possible to the community that a module is being deprecated.

Marking A Module As Deprecated For Standard Release
===================================================

!!! note 
    Reminder: Module deprecation practices within the tree are only eligible to be done in master when the next release is a standard release. No module deprecation can be done during the development of a long term supported release.

[//]: # (end-note)

#### The following instructions are for the master branch in which the module is to be deprecated.

1. Before a module can be marked as deprecated a discussion needs to occur on the [asterisk-dev mailing list](https://groups.io/g/asterisk-dev/). Depending on the result of this it would also be wise to reach out the [community forums](https://community.asterisk.org/) to ensure that the module is not seeing widespread usage. If you feel uncomfortable doing so reach out to unknown user and he can assist in doing so.
2. Create a new issue in the [Asterisk project issue tracker](https://github.com/asterisk/asterisk/issues/) using the "Deprecation" issue type. Ensure the issue summary is descriptive as it will go into release notes.
3. Obtain the Asterisk source code from [GitHub](https://github.com/asterisk/asterisk). Since you'll need to put your patch up for review, make an account in GitHub as well, following the instructions on [Code Contribution](/Development/Policies-and-Procedures/Code-Contribution).
4. Create a new Git branch for your deprecation change.
5. Edit the module MODULEINFO and set the "support_level" field in the XML to "deprecated".
6. Edit the module AST_MODULE_INFO at the bottom and set the "support_level" field to "AST_MODULE_SUPPORT_DEPRECATED".
7. Edit the module MODULEINFO and set the "defaultenabled" field in the XML to "no".
8. Edit the module MODULEINFO and set the "deprecated_in" field in the XML to the version it has been deprecated in.
9. Edit the module MODULEINFO and set the "removed_in" field in the XML to the version it will be removed in.
10. Add an UPGRADE.txt document stating that the module has been deprecated, will no longer be built by default, and state the version it is scheduled to be removed in.
11. Write a commit message describing the change and referencing the Asterisk issue you created as part of step 1.
12. Submit the patch to Gerrit.
13. Update the [Asterisk Module Deprecations](/Development/Asterisk-Module-Deprecations) wiki page and add the module to the "Deprecated Modules" list with appropriate versions.

#### The following instructions are for the previous still supported branches to notify users that a module will be deprecated in an upcoming version.

!!! info ""
    Setting these values in the MODULEINFO XML will cause Asterisk to output a warning at startup with the information to inform the user that in a future new version of Asterisk deprecation and then removal will occur.

[//]: # (end-info)

1. Obtain the Asterisk source code from [GitHub](https://github.com/asterisk/asterisk). Since you'll need to put your patch up for review, make an account in GitHub as well, following the instructions on [Code Contribution](/Development/Policies-and-Procedures/Code-Contribution).
2. Create a new Git branch for your deprecation notice change.
3. Edit the module MODULEINFO and set the "deprecated_in" field in the XML to the version it has been deprecated in.
4. Edit the module MODULEINFO and set the "removed_in" field in the XML to the version it will be removed in.
5. Add an UPGRADE.txt document stating that the module has been deprecated, will no longer be built by default, and state the version it is scheduled to be removed in.
6. Write a commit message describing the change and referencing the Asterisk issue you created as part of deprecating the module in master.
7. Submit the patch to Gerrit.
8. Cherry pick the change to other appropriate branches.

!!! note 
    A single commit can be used to update multiple modules, but each module will need its own JIRA issue.

[//]: # (end-note)

Recording A Module For Future Deprecation
=========================================

During development of a long term supported release modules are not eligible to be marked as deprecated in the source code, however you can still record that a module is to be deprecated in the future.

1. Update the [Asterisk Module Deprecations](/Development/Asterisk-Module-Deprecations) wiki page and add the module to the "Proposed Modules To Deprecate In Future" list with appropriate versions. Set the "Deprecated Version" to the next standard release.
2. After creation of the long term supported release the wiki page will be reviewed for any modules that should be marked as deprecated.

Removing A Module
=================

!!! note 
    Reminder: Module removal is only eligible to be done in master when the next release is a standard release. No module removal can be done during the development of a long term supported release.

[//]: # (end-note)

1. Only remove a module if it has not been reverted from being deprecated.
2. Create a new issue in the [Asterisk project issue tracker](https://github.com/asterisk/asterisk/issues/) using the "Deprecation" issue type. Ensure the issue summary is descriptive as it will go into release notes.
3. Obtain the Asterisk source code from [GitHub](https://github.com/asterisk/asterisk). Since you'll need to put your patch up for review, make an account in GitHub as well, following the instructions on [Code Contribution](/Development/Policies-and-Procedures/Code-Contribution).
4. Create a new Git branch for your removal change.
5. Remove the module and any other source files for it from the tree using "git rm".
6. Remove any logic in the respective Makefile for the module if it exists.
7. Remove any sample configuration files.
8. Remove any logic from configure.ac
9. Remove any mention from makeopts.in
10. Remove any mention from build_tools/menuselect-deps.in
11. Remove any dependency from the contrib/scripts/install-prereq script
12. Add an UPGRADE.txt document stating that the module has been removed.
13. Write a commit message describing the change and referencing the Asterisk issue you created as part of step 1.
14. Submit the patch to Gerrit.
15. Update the [Asterisk Module Deprecations](/Development/Asterisk-Module-Deprecations) wiki page and move the module to the "Removed Modules" list.

Module Maintainership
=====================

If an individual has a special interest in a deprecated module they may become maintainer of it. The module will remain in a deprecated state but will not be removed. A warning message will continue to be provided to users that the module is deprecated and may be removed. If the maintainer leaves the project or no longer wishes to maintain the module it will then be removed in the next standard release.
