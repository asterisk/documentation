---
search:
  boost: 0.2
title: CHANGES and UPGRADE.txt
pageid: 41454547
---

Overview
========

Up until early 2019, anyone contributing to Asterisk probably came across a change that required an addition to the CHANGES or UPGRADE.txt files. If you're one of those people, then you probably also know how frustrating it was having to deal with merge conflicts if another person had touched this file in one of their reviews. Because of this, a new process has been added that will ease the pains of having to document something in these files.

What Changed?
=============

A couple of things. You no longer need to add anything to the CHANGES and UPGRADE.txt files themselves. By removing this, there should not be any merge conflicts (at least, none relating to these files!). Instead, two new directories have been created under the doc/ directory: CHANGES-staging and UPGRADE-staging. Any code you add that is considered a new feature or an enhancement of an existing feature should be documented in the CHANGES-staging directory. Changes that would break existing behavior should be documented under the UPGRADE-staging directory. The format is similar to how things were done in the past, but you no longer need to worry about typing out dashes and asterisks to separate things. That's all done for you!

The release process is what handles updating the CHANGES and UPGRADE.txt files now. Whenever a release is being made, everything in the staging directories is taken and added to the beginning of the corresponding file. Everything that has the same subject (e.g, "res_pjsip") will be grouped under one section and separated by asterisks, exactly how it has been done in the past. The directories will then be cleaned up and the commit will be pushed in along with everything else. Easy as that!

Here's an example of what one of these directories might look like before a release:

```
someone@justanexample:/path/to/asterisk/doc/CHANGES-staging# ls
core_relevant_title.txt
README.md
res_pjsip_relevant_title.txt
res_rtp_relevant_title.txt

```

!!! note 
    These files must be ".txt" files in order to be parsed. The only exception to this is the README.md file, which should never be modified or removed.

[//]: # (end-note)

Inside of one of these files (say, the first one), it should follow the format of subject lines, headers, blank line, then a description of the change. It could look something like this:

```
Subject: res_pjsip
Subject: Core

Obviously this is just an example and when you write a description it should be way better than this.

But you get the idea!

```

!!! note 
    The "Subject: res_pjsip" line is considered a special header and is case sensitive. This is what the script uses to determine what goes where and what content belongs to. Other headers can be added in the future this way, following the subject header.

[//]: # (end-note)

Viola! That's all there is to it. One thing to note is that changes will be sorted alphabetically, and then sorted by commit timestamp (in epoch). The reasoning will be explained below.

Mainline Branches vs Master
===========================

Releases from mainline branches (16.2.0 -> 16.3.0) work as expected following the above rules. The changes are fetched from the staging directory, put in their individual categories, and then sorted. This is all fine until we get to master. Master does not get a release for 16.2.0 -> 16.3.0. Because of this, things need to be done a little differently. Ordinarily when a release was done, the changes would be cherry picked to the master CHANGES and UPGRADE.txt files as well, and upon doing a release of a new version of Asterisk from master, a new UPGRADE.txt file would be created. Now, there will only be one UPGRADE.txt file. When releasing 17, there will be 2 new sections added to the file: a "new in 17" section and a "changes from 16 to 17" section. CHANGES will behave in a similar way.

Changes that are master-only need a special header to denote them as such. This won't cause any weird issues with cherry-picking either, since the changes will only be going into the master branch. You will need to add "Master-Only" under the "Subject:" header, like so:

```
Subject: res_ari
Master-Only: True

A master only change!

```

!!! info ""
    The value for "Master-Only" can be "True" or "true", but will NEVER be false. This header should only be present in the master branch and is used to distinguish between the other changes that build up over time from other release branches.

[//]: # (end-info)

These changes will be separated into a different storage structure and added BEFORE the other changes, so that the new stuff is seen first!
