---
title: Asterisk Backups
pageid: 28315834
---

Backing up Asterisk Data
========================

Backing up Asterisk is not a complex task. Mostly, you just need to know where the files are and then employ common tools for archiving and storing those files somewhere.

Files to consider for backup
----------------------------

* [Asterisk configuration](/Fundamentals/Directory-and-File-Structure)
* [Asterisk internal DB](/Fundamentals/Asterisk-Internal-Database)
* [Other database used by Asterisk](/Configuration/Interfaces/Back-end-Database-and-Realtime-Connectivity)
* Asterisk [logs](/Logging-Configuration) and [reports](/Configuration/Reporting)

The  [Directory and File structure](/Fundamentals/Directory-and-File-Structure) page should direct you to where most of these files reside. Otherwise check the individual wiki pages for information on the location of their output.

Other than just using **tar** to archive and compress the files, you might set up a [cron job](http://en.wikipedia.org/wiki/Cron) in Linux to regularly perform that process and send the files off-site. In general, use whatever backup processes you use for any other Linux applications that you manage.

Restoring a Backup
==================

Restoring a backup, in most cases should be as simple as placing the files back in [their original locations](/Fundamentals/Directory-and-File-Structure) and [starting Asterisk](/Operation/Running-Asterisk).

When restoring a backup to a new major version of Asterisk you'll need to take the same steps as if you were [upgrading Asterisk](/Updating-or-Upgrading-Asterisk). That is because a [new major version](/About-the-Project/Asterisk-Versions) may include changes to the format or syntax of configuration, required database schema, or applications and functions could be deprecated, removed or just have different behavior.

