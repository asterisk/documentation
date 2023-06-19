---
title: Git Usage
pageid: 32375061
---

Overview
========

This page documents:

* Asterisk's various Git repositories, and their intended purposes.
* Policies for using Git and Gerrit with Asterisk.
* Useful commands.

Git Repositories
================

Gerrit: <https://gerrit.asterisk.org>
-------------------------------------

Asterisk uses [Gerrit](http://code.google.com/p/gerrit/) as its primary repository and for for code review. Users who are looking to clone or contribute patches back to Asterisk should work the repositories on Gerrit. Please see the [Gerrit Usage](/Gerrit-Usage) documentation for more information.

Gitolite: <https://git.asterisk.org>
------------------------------------

The repositories on <https://git.asterisk.org> mirror the repositories on Gerrit, and provide source tree browsing.

GitHub: <https://github.com/asterisk>
-------------------------------------

The repositories on GitHub mirror the repositories on Gerrit, also provide source tree browsing, and exist because of GitHub's popularity.

**Pull requests on GitHub WILL be ignored.**

On This Page


Gerrit Access
=============

Anyone may clone repositories from Gerrit anonymously.

Users may participate in code reviews or contribute patches if they have signed a [Contributor License Agreement](https://github.com/asterisk/asterisk/issues/jira/secure/DigiumLicense.jspa). Access to Gerrit is performed using your JIRA (Atlassian) username/password. You may create an account at <https://signup.asterisk.org>, and sign a CLA in [JIRA](https://github.com/asterisk/asterisk/issues/jira). Note that you will not be able to log into Gerrit if a CLA is not associated with your JIRA account.




---

**Note:**  When submitting a patch to Gerrit, you are explicitly doing so under the terms and conditions of the [Contributor License Agreement](https://github.com/asterisk/asterisk/issues/jira/secure/DigiumLicense.jspa). If you do not wish to contribute a patch back to the Asterisk project, please do not push a patch up to Gerrit.

  



---


Gerrit Policies
===============

Code Reviews
------------

* A `-2` should only be used if the current implementation requires a complete rewrite to be acceptable, or if the change should not be made under any implementation.




---

**Note:**  If you use a `-2`, please be prepared to justify its usage.

  



---
* A `+2` should generally not be given unless someone has already given the review a `+1`.
* Related to the previous, users who provide a `+2` should generally not provide it to a change that they provided the `+1` on.
* Please read the Asterisk project [Coding Guidelines](/Coding-Guidelines) prior to submitting patches. When performing code reviews, please refer to the [Code Review Checklist](/Code-Review-Checklist).

Topics
------

* Please use the `-t` option with `git review`, specifying the ASTERISK issue the change should be associated with:




---

  
  


```

$ git review -t ASTERISK-12345

```



---


This helps to tie Gerrit reviews to the JIRA issue that necessitated the change.

Cherry-Picking
--------------

* All branches that require the change should have the change cherry-picked to that branch, and submitted for review. See [Software Configuration Management Policies](/Software-Configuration-Management-Policies) for which patch types are appropriate for what branches. See [Gerrit Usage](/Gerrit-Usage) for instructions on cherry-picking.
* The same Gerrit `Change Id` must be present in all cherry-picked commits.
* The same topic (ASTERISK issue) must be used in all reviews.
* Test Suite test reviews should use the same topic (ASTERISK issue) as the code change reviews.

Useful Commands and Tips
========================

* `git clean`: When switching between major release branches there are often whole directories that are in one branch but not another.  '`git clean -fd`' will clean out the working directory.  Just make sure any files you want to keep are either checked in or ignored.
* If you use an IDE or other tools that need configuration files in the working directory but their names don't match an entry in .gitignore, you can add them to git/info/exclude to ignore them locally without updating the checked-in .gitignore.
* `git log`:  This is one of the more useful tools there is.  Here are some examples:Show the commit difference between 13.8 and 13.9


	+ Show the difference between the 13.8 and 13.9 branches:  
	
	
	
	
	
	---
	
	  
	  
	
	
	```
	
	$ git log --graph --decorate --no-merges -E --grep="^(realtime: Add database scripts for|ChangeLog:|Release summaries:|[.])" \
	$ --invert-grep --pretty=format:'%Cred %h %C(yellow) %d %Creset %<(60,trunc) %s %Cgreen(%cr)' 13.8..13.9
	\* d27ee3b res\_sorcery\_astdb: Fix creation of retrieved objects. (11 days ago)
	\* 15c427c Use doubles instead of floats for conversions when compari.. (11 days ago)
	\* e702b9f pjproject\_bundled: Disable PJSIP\_UNESCAPE\_IN\_PLACE (3 weeks ago)
	\* b470aab func\_odbc: Check connection status before executing queries. (3 weeks ago)
	<snip>
	$
	
	```
	
	
	
	---
	
	
	 Both are branches so you'll see the diff between their current states with the merge and housekeeping commits excluded.
	+ That's a lot to type so add an alias:  
	
	
	
	
	
	---
	
	  
	  
	
	
	```
	
	$ git config --global --add alias.cdiff "log --graph --decorate --no-merges \
	 -E --grep='^(realtime: Add database scripts for|ChangeLog:|Release summaries:|[.])' \
	 --invert-grep --pretty=format:'%Cred %h %C(yellow) %d %Creset %<(60,trunc) %s %Cgreen(%cr)'"
	$
	
	```
	
	
	
	---
	+ Show the commits added to 13.9 after up to 13.9.1  
	
	
	
	
	
	---
	
	  
	  
	
	
	```
	
	$ git cdiff 13.9..13.9.1
	$
	
	```
	
	
	
	---
	
	
	 Wait, that didn't show anything!  That's because 13.9.1 is a tag on 13.9 and nothing's been added to 13.9 since then so they're equal. What you probably want is:
	
	
	
	
	---
	
	  
	  
	
	
	```
	
	$ git cdiff 13.9.0..13.9.1
	\* d27ee3b res\_sorcery\_astdb: Fix creation of retrieved objects. (11 days ago)
	\* 15c427c Use doubles instead of floats for conversions when compari.. (11 days ago)
	<snip>
	$
	
	```
	
	
	
	---
	+ Now things get a little complicated. Let's say 13.8 is closed but certified/13.8 is still open. So, what's in certified/13.8 but not 13.8? You might be tempted to use the `'..'` operator between the 2 branches as before but because `'..'` is a range operator it doesn't work well when the 2 branches overlap, especially when we're cherry-picking; you'll wind up showing commits that are in both branches. Instead, you need to use the `'...'` operator and the `--cherry-pick` flag.
	
	
	
	
	---
	
	  
	  
	
	
	```
	
	$ git cdiff --cherry-pick --right-only 13.8...certified/13.8
	\* b9a28cc udptl: Don't eat sequence numbers until OK is received (5 days ago)
	| \* f85c77a chan\_sip: Prevent extra Session-Expires headers from bein.. (6 days ago)
	|/ 
	\* 8bf050b config\_transport: Tell pjproject to allow all SSL/TLS pro.. (10 days ago)
	\* 4fc2c98 res\_pjsip\_authenticator\_digest: Don't use source port in n.. (2 weeks ago)
	\* 4e7791d file: Ensure nativeformats remains valid for lifetime of u.. (3 weeks ago)
	\* c4426f1 res\_pjsip: disable multi domain to improve realtime perfor.. (3 weeks ago)
	<snip>
	$
	
	```
	
	
	
	---
	+ Finally, things get even more complicated when trying to compare 13 and master.  Because of the cherry-picking and the fact that these 2 branches started in subversion, there is no single git command that will show the differences reliably. The only way to do this is to pick a point in time as a starting reference, list the log from both branches, sort them, then compare them.  It would be nice if git could do the matching on the gerrit change id but it can't so we're left with matching on subject
	
	
	
	
	---
	
	  
	  
	
	
	```
	
	$ git log --date=short --pretty=format:"master %h %cd %s" --since='2015/04/11' --no-merges master > /tmp/master
	$ git log --date=short --pretty=format:"13 %h %cd %s" --since='2015/04/11' --no-merges 13 > /tmp/13
	$ sort -k4 /tmp/13 /tmp/master | uniq -u --skip-fields=3
	master 64b2046 2016-01-06 Add sipp-sendfax.xml and spandspflow2pcap.py to contrib/scripts.
	master 2415a14 2015-05-15 Add X.509 subject alternative name support to TLS certificate verification.
	master 57386dc 2015-05-12 Allow command-line options to override asterisk.conf.
	master 62e9506 2015-04-13 AMI: Fix improper handling of lines that are exactly 1025 bytes long.
	13 1d3d20d 2015-12-21 app\_amd: Correct documentation to reflect functionality
	master ca39416 2015-12-21 app\_amd: Correct maximum\_number\_of\_words functionality & documentation
	master 8c14b91 2015-11-19 app\_bridgeaddchan: ability to barge into existing call
	<snip>
	$
	
	```
	
	
	
	---
	
	
	April 11 2015 was the migration from subversion to git.  Also note that the 2 app\_amd commits are probably the same but we have no way to tell.

  
