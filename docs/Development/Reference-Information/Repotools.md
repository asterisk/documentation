---
title: Repotools
pageid: 22085730
---

Merge Tools
===========


The repotools Makefile installs the merge tools which are useful for simplifying the merging process for commits to Asterisk's various branches.  

Installation requires that you have repotools checked out (or otherwise available) and that you have expect. On Ubuntu/Debian, expect can be  

installed trivially with apt-get (usually with default repositories)


bash$ sudo apt-get install expect
Once expect is installed, the mergetools can be installed with the following steps:


bash$ svn co http://svn.asterisk.org/svn/repotools
$ cd repotools
$ ./configure
$ sudo make install
Other Requirements
==================


In addition to the mergetools, there are a number of scripts in repotools that we use for a variety of purposes. Some examples are automated  

commit message template generators, an IRC bot that reacts to JIRA issue names and spits out descriptions, and a tool for generated release  

notes. Some of these tools require some additional dependencies.


jira-python
-----------


Scripts that retrieve issue information from JIRA now require the jira-python module. This is most easily obtained by using pip, which is  

basically a python-specific package manager. Like expect, it is usually obtainable through default repositories if you use Ubuntu or Debian.


bash$ sudo apt-get install python-pip
Once pip is installed, installing jira-python is simple (and similar)


bash$ sudo pip install jira-python
pysvn, diffstat, and links2
---------------------------


If you want to run the release summary building script, these tools are necessary. Like with most tools mentioned here, getting them with  

your default package manager is usually simplest. Ubuntu/Debian example:


bash$ sudo apt-get install python-svn diffstat links2