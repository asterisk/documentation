---
title: Release Management
pageid: 52069717
---

Overview
========

For the most part, the user-visible Asterisk release process will not change.  All release tarballs, signatures, patches and change logs will continue to be available at <https://downloads.asterisk.org/pub/telephony/asterisk/>.   The releases will also be available via GitHub at [https://github.com/asterisk/asterisk/releases](https://github.com/asterisk/asterisk/releases). Specific artifacts can be retrieved with URLs like https://github.com/asterisk/asterisk/releases/download/<version>/asterisk-<version>.tar.gz.  You are encouraged to use the GitHub links to benefit from their CDN.

New Change Log Artifacts
========================

* The CHANGES and ChangeLog files that used to appear in the top level distribution directory are no longer produced.
* The UPGRADE.txt file that appears in the top level distribution directory is no longer updated and will be removed in a future release.
* A new ChangeLogs directory now appears in the top level distribution directory.  It contains a separate ChangeLog file for each release, for example `ChangeLogs/ChangeLog-20.3.0-rc1.md`.
* The new ChangeLog files will contain notes that would formerly be added to the UPGRADE.txt file.
* A symbolic link in the top level distribution directory named `CHANGES.md` will point to the specific ChangeLog for the release.

New ChangeLog and Release Announcement Format
=============================================

The release change logs and release announcements will have a new format.  Here's a sample:

```
Change Log for Release 20.3.0-rc1
========================================

Summary:
----------------------------------------

- .github: Add AsteriskReleaser
- chan_pjsip: also return all codecs on empty re-INVITE for late offers
- cel: add local optimization begin event
- core: Cleanup gerrit and JIRA references. (#57)
- .github: Fix CherryPickTest to only run when it should
- .github: Fix reference to CHERRY_PICK_TESTING_IN_PROGRESS
- .github: Remove separate set labels step from new PR
- .github: Refactor CP progress and add new PR test progress
- res_pjsip: mediasec: Add Security-Client headers after 401

User Notes:
----------------------------------------

- ### cel: add local optimization begin event
 The new AST_CEL_LOCAL_OPTIMIZE_BEGIN can be used
 by itself or in conert with the existing
 AST_CEL_LOCAL_OPTIMIZE to book-end local channel optimizaion.

- ### chan_dahdi: Add dialmode option for FXS lines.
 A "dialmode" option has been added which allows
 specifying, on a per-channel basis, what methods of
 subscriber dialing (pulse and/or tone) are permitted.
 Additionally, this can be changed on a channel
 at any point during a call using the CHANNEL
 function.

- ### res_http_media_cache: Introduce options and customize
 The res_http_media_cache module now attempts to load
 configuration from the res_http_media_cache.conf file.
 The following options were added:
 * timeout_secs
 * user_agent
 * follow_location
 * max_redirects
 * protocols
 * redirect_protocols
 * dns_cache_timeout_secs


Upgrade Notes:
----------------------------------------

- ### cel: add local optimization begin event
 The existing AST_CEL_LOCAL_OPTIMIZE can continue
 to be used as-is and the AST_CEL_LOCAL_OPTIMIZE_BEGIN event
 can be ignored if desired.


Closed Issues:
----------------------------------------

 - #35: [New Feature]: chan_dahdi: Allow disabling pulse or tone dialing
 - #39: [Bug]: Remove .gitreview from repository.
 - #43: [Bug]: Link to trademark policy is no longer correct
 - #48: [bug]: res_pjsip: Mediasec requires different headers on 401 response
 - #52: [improvement]: Add local optimization begin cel event

Commits By Author:
----------------------------------------

- ### Fabrice Fontaine (2):
 - main/iostream.c: fix build with libressl
 - configure: fix detection of re-entrant resolver functions

- ### George Joseph (12):
 - make_version: Strip svn stuff and suppress ref HEAD errors
 - test.c: Fix counting of tests and add 2 new tests
 - Initial GitHub Issue Templates
 - Initial GitHub PRs

- ### Henning Westerholt (2):
 - chan_pjsip: fix music on hold continues after INVITE with replaces
 - chan_pjsip: also return all codecs on empty re-INVITE for late offers

Detail:
----------------------------------------

- ### .github: Add AsteriskReleaser
 Author: George Joseph 
 Date: 2023-05-05 


- ### chan_pjsip: also return all codecs on empty re-INVITE for late offers
 Author: Henning Westerholt 
 Date: 2023-05-03 

 We should also return all codecs on an re-INVITE without SDP for a
 call that used late offer (e.g. no SDP in the initial INVITE, SDP
 in the ACK). Bugfix for feature introduced in ASTERISK-30193
 (https://github.com/asterisk/asterisk/issues/jira/browse/ASTERISK-30193)

 Migration from previous gerrit change that was not merged.


- ### cel: add local optimization begin event
 Author: Mike Bradeen 
 Date: 2023-05-02 

 The current AST_CEL_LOCAL_OPTIMIZE event is and has been
 triggered on a local optimization end to serve as a flag
 indicating the event occurred. This change adds a second
 AST_CEL_LOCAL_OPTIMIZE_BEGIN event for further detail.

 Resolves: #52

 UpgradeNote: The existing AST_CEL_LOCAL_OPTIMIZE can continue
 to be used as-is and the AST_CEL_LOCAL_OPTIMIZE_BEGIN event
 can be ignored if desired.

 UserNote: The new AST_CEL_LOCAL_OPTIMIZE_BEGIN can be used
 by itself or in conert with the existing
 AST_CEL_LOCAL_OPTIMIZE to book-end local channel optimizaion.

```

To keep the Release Announcements posted to the mailing lists and community forums brief, they won't contain the detail commit section.

Branching Changes
=================

In the past, a new branch was created for each minor release, for example `18.1, 18.2, 18.3, etc`.  These branches were fairly useless once a release was cut because the only contained the tags for the current release and didn't really show the true release commit history.  Instead we now have a "release" branch for each major release, like `releases/20` which will have the full-tagged commit history for the major release back to the date to the migration to GitHub (2023-04-29).  The commit history itself will go back to the start of time of course, it's just the tags that will go back as far as them migration date.









