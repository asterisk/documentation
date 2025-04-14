---
search:
  boost: 0.2
title: Subversion Usage
pageid: 5243336
---

!!! info "Historical Page"
    The Asterisk project no longer uses Subversion for source control. It now uses Git. Instructions on using Git with Asterisk can be on the [Git Usage](/Development/Policies-and-Procedures/Historical-Policies-and-Procedures/Git-Usage) page.

    This page is being kept only for historical purposes.

[//]: # (end-info)

# Commit Access

## Configuration

The subversion server uses SSL client certificates to handle authentication of users. When you are granted commit access, you will be provided two files. These files should be placed in your `~/.subversion/` directory.

# [Digium_SVN-cacert-sha1.pem|http://svnview.digium.com/svn/repotools/Digium_SVN-cacert-sha1.pem]
# <name>-cert.p12

The following should be placed in the `~/.subversion/servers` file:

```
[groups]
digium = \*.digium.com

[digium]
ssl-client-cert-file = /home/<username>/.subversion/<name>-cert.p12

[global]
ssl-authority-files = /home/<username>/.subversion/Digium_SVN-cacert-sha1.pem

```

## SVN Checkouts

Checkouts that come from `http://svn.asterisk.org/` are read-only copies of the repositories. When doing a checkout that you intend to commit to, it must be from `https://origsvn.digium.com/`. For example:

```
$ svn co https://origsvn.digium.com/svn/asterisk/trunk
$ svn co https://origsvn.digium.com/svn/asterisk/branches/1.8

```

# Using `svnmerge` for Cross-Branch Merging

## Tools Installation

You must install `svnmerge` and the related wrappers from our `repotools` repository. The wrapper scripts use `expect`, so be sure to install that, too.

```
$ svn co http://svn.asterisk.org/svn/repotools
$ cd repotools
$ ./configure
$ sudo make install

```

## `svnmerge` Properties

If you do a `svn pl -v` while you are located in an svn checkout, you will see all the properties currently attached to the root directory. For instance, on a checked out copy of Asterisk trunk, you will see something like this:

```
 branch-1.8-blocked
 /branches/1.8:
 branch-1.8-merged
 /branches/1.8:1-279056,279113,279227,279273,279280,...............,286457
```
and on the 1.8 branch, you will see these sort of properties:

```
 branch-1.6.2-blocked
 /branches/1.6.2:279852,279883,280227,280556,280812,282668
 branch-1.6.2-merged
 /branches/1.6.2:1-279056,279207,279501,279561,279597,279609,....................,286268
```
These properties identify the following things:
# The branch changes are being merged from
    * `branch-<branch>-...`
# The revisions merged from that branch
    * `branch-<branch>-merged:/branches/<branch>:<revisions>`
# The revision explicitly not merged, or blocked, from that branch
    * `branch-<branch>-blocked:/branches/<branch>:<revisions>`

## Branch Merging Order

When committing a change that applies to more than one branch, the change should first go into the oldest branch and will then be merged up to the next one. If a branch is reached where the change should not be merged up, it should be explicitly blocked. The following diagram shows the current branch merge order.

The column on the right describes the scripts you will use to merge between versions or block specific versions from merging.

{section}
{column:width=25%}
{flowchart}
"/svn/asterisk/branches/1.8" -> "/svn/asterisk/branches/11"
"/svn/asterisk/branches/11" -> "/svn/asterisk/branches/12"
"/svn/asterisk/branches/12" -> "/svn/asterisk/branches/13"
"/svn/asterisk/branches/13" -> "/svn/asterisk/branches/trunk"
{flowchart}
{column}
{column:width=75%}
* 1.8 -> 11
    * `merge811 _<revision>_`
    * `block811 _<revision>_`

* 11 -> 12
    * `merge1112 _<revision>_`
    * `block1112 _<revision>_`
* 12 -> 13
    * `merge1213 _<revision>_`
    * `block1213 _<revision>_`
* 13 -> trunk
    * `merge13trunk _<revision>_`
    * `block13trunk _<revision>_`

The <revision> number passed to each script should be the revision resulting from the commit to an older branch. The script would be run from the checkout directory for the Asterisk version you are merging \*to\*.

For example if you have committed a change to 13 and that needs to be merged through to trunk, the commands would look similar to the following:

```
/svn-asterisk-13$ svn commit -F ../commit_msg
Sending apps/app_voicemail.c
Transmitting file data .
Committed revision 376262.
/svn-asterisk-13$ cd ../svn-asterisk-trunk
/svn-asterisk-trunk$ merge13trunk 376262
```
Then you would proceed with committing the merged changes.

{tip}
All of these scripts create a commit message for you in the file `../merge.msg`. Run "`svn commit`" and use that commit message with the following command:

```
$ svn commit -F ../merge.msg

```
{tip}

{tip}
Sometimes when you go to commit your changes after merging from another branch, you will end up with a conflict. The conflict will typically be against `.` (period). To resolve the conflict, run "`svn resolved .`" prior to committing.
{tip}

{column}
{section}

## Backporting Changes

Sometimes a change is made in a branch and later it is decided that it should be backported to an older branch. For example, a change may have gone into the 11 branch and later needs to be backported to the 1.8 branch. To handle this, first manually make the change and commit to the 1.8 branch. Then, there is another wrapper similar to `merge811` and `block811` to record that the code from a revision already exists in the 11 branch. The wrapper is `record811`.

```
$ cd 11
$ record811 <revision>
$ svn commit -F ../merge.msg

```

# Developer Branches

{info}
If you have been granted workspace on the server, you will have read and [electronically signed the Open Source Contributor License|https://github.com/asterisk/asterisk/issues/] found at https://github.com/asterisk/asterisk/issues (upon signing in) and have been given an SSL client certificate.
{info}

Developer branches are stored in the `/team/<name>` directory of each project repository (and `/team/<name>/private` for private branches). 

## Creating a Developer Branch

Use the following commands to create a branch and prepare it for future merge tracking of the branch you created it from. This example creates a branch off of Asterisk trunk.

```
$ svn copy https://origsvn.digium.com/svn/asterisk/trunk https://origsvn.digium.com/svn/asterisk/team/jdoe/my-fun-branch
$ svn checkout https://origsvn.digium.com/svn/asterisk/team/jdoe/my-fun-branch
$ cd my-fun-branch
$ svnmerge init
$ svn commit -F svnmerge-commit-message.txt

```

## Deleting a Developer Branch

To delete a developer branch after you are done with it use the SVN command shown below for your branch name.

```
$ svn delete https://origsvn.digium.com/svn/asterisk/team/jdoe/my-fun-branch

```

## Group Branches

Group branches are developer branches intended to be worked on by more than one developer. Instead of putting them in `/team/<name>`, they go in the `/team/group` directory, instead. Otherwise, they're managed in the exact same way as other developer branches.

## Automatically Keeping Branches Up to Date Using `automerge`

Our subversion server provides the ability to automatically keep developer branches up to date with their parent. To enable this feature, set the `automerge` and `automerge-email` properties on the root directory. Changes from the parent branch will be periodically (once an hour) merged into your branch. If a change from upstream conflicts with changes in the branch, the `automerge` process will stop and the address(es) listed in the `automerge-email` property will be notified.

{note}
Running `svnmerge init` and committing those properties is a prerequisite for `automerge` to work for a developer branch.
{note} 

Use the following commands to enable automerge on a developer branch:

```
$ cd my-fun-branch
$ svn ps automerge '\*' .
$ svn ps automerge-email 'me@example.com' .
$ svn commit -m "initialize automerge"

```

### Setting `automerge-email` on a Group Branch

For a branch with multiple developers working on it, it may be useful to have automerge emails sent to more than one email address. To do so, just separate the email addresses in the property with commas. The value of this property is literally used as the content for the `To:` header of the email.

```
$ svn ps automerge-email 'me@example.com,you@example.com,him@example.com' .

```

### Resolving `automerge` Conflicts

If your developer branch goes into conflict with `automerge` on, and the `automerge-email` property has been set, you will receive an email notifying you of the conflict and `automerge` will be disabled. To resolve it, use the following commands:

```
$ cd my-branch
$ svn update
$ svnmerge merge

```

Running the `svnmerge` tool will merge in the changes that cause your branch to go into conflict into your local copy. Edit the files that are in conflict to resolve the problems as appropriate. Finally, tell SVN that you have resolved the problem, re-enable automerge, and commit.

```
$ svn resolved path/to/conflicted/file
$ svn ps automerge '\*' .
$ svn commit -m "resolve conflict, enable automerge"

```

## Private Branches

A private developer branch is only visible to Digium and the branch owner. Management of a private branch is exactly the same as any other developer branch. The only difference is branch location. Instead of putting the branch in `/team/<name>/` the branch goes in `/team/<name>/private/`.

## Merging a Developer Branch into `trunk`

{info}
If your branch contains new functionality, please make sure you have made the appropriate modifications to `CHANGES` and/or `UPGRADE.txt`.
{info}

If a developer has a branch that is ready to be merged back into the trunk, here is the process:

```
$ svn co https://origsvn.digium.com/svn/asterisk/trunk
$ cd trunk
$ svn merge --ignore-ancestry https://origsvn.digium.com/svn/asterisk/trunk https://origsvn.digium.com/svn/asterisk/team/jdoe/bug12345 .
# Check the diff to see if it merged properly
$ svn diff | less

```

Be sure to check the resulting diff to make sure that the merge doesn't overwrite any changes in trunk. If it does, you will have to specify the specific revisions merge needs to base its diff off of.

```
# The last change to bug12345 was at r2500.
# trunk r2400 was merged into bug12345@2500.
$ svn merge --ignore-ancestry https://origsvn.digium.com/svn/asterisk/trunk@2400 https://origsvn.digium.com/svn/asterisk/team/jdoe/bug12345@2500 .

```

{note}
This is NOT using the svnmerge script; this is just a normal SVN merge.
{note}

Once this is done, the working copy will contain the trunk plus the changes from the developer branch. If you follow the above instructions for creating branches, you have probably introduced properties to the root of the branch that need to be removed.

```
$ svn revert .

```

If you are purposely introducing new properties, or purposely introducing new values for existing properties, then you might do the following instead, so as not to destroy your properties:

```
$ svn pd svnmerge-integrated .
$ svn pd automerge .
$ svn pd automerge-email .

```

If everything merged cleanly, you can test compile and then:

```
$ svn commit -m "Merge branch for issue 12345"

```

Once the contents of your branch has been merged, please use `svn remove` to remove it from the repository. It will still be accessible if needed by looking back in the repository history if needed.
