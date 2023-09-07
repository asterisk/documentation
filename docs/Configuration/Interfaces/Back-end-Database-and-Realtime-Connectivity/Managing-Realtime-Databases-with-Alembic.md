---
title: Managing Realtime Databases with Alembic
---

Overview
========

Asterisk 12 now uses [Alembic](https://pypi.python.org/pypi/alembic) to help manage Asterisk Realtime Database schemas. This includes creation of SQL scripts for a variety of database vendors, but also much more. Alembic is a full database migration tool, with support for upgrading the schemas of existing databases, versioning of schemas, creation of new tables and databases, and a whole lot more. This page covers basic configuration of the Alembic configuration file for usage with Asterisk Realtime as well as basic usage of Alembic. While a full description of Alembic is beyond the scope of this page, the information on this page should help an Asterisk administrator create or upgrade an Asterisk installation.

Alembic makes upgrading less painfulAs Asterisk changes and new fields are made controllable via realtime, new Alembic change scripts are added so you will be able to simply run the Alembic upgrade command again in order to modify your database.

While Alembic helps with database migrations within a release series (e.g., Asterisk 13.x.x) it does not work very well when jumping to a different release series (e.g., jumping from Asterisk 13.x.x to Asterisk 15.x.x).  Data loss is possible when jumping to a different release series.  Before a new series (e.g., Asterisk 15.0.0) is initially released breaking changes can be introduced that can result in data loss.

Always exercise due diligence and backup your database before upgrading.  Tables can be fixed easily.  Repopulating the data if it's lost however isn't.

Please read the CHANGES file and the applicable UPGRADE files for important information about what changed between revisions.

Before you Begin
----------------

This tutorial assumes you already have some experience in setting up Realtime configuration with Asterisk for other modules. This page will not describe how to set up backend database connectors, and is written under the assumption that you will be using ODBC to connect to your database since the ODBC adaptor is capable of connecting to most commonly used database servers. For more information on configuring and setting up Asterisk Realtime, see Asterisk Realtime Database configuration.

Installing Alembic
==================

If you don't already have Alembic installed, perform the following:

This does assume that you have pip installed. If you do not have pip installed, easy\_install should work just as well. If you don't have [pip](https://github.com/pypa/pip) or easy\_install (or Python), then you should probably install those first.

$ pip install alembicAnd that's it!

Building the Database Tables
============================

Alembic scripts were added to Asterisk in Asterisk 12, and will allow you to automatically populate your database with tables for most of the commonly used configuration options. The scripts are located in the [Asterisk contrib/ast-db-manage](http://svn.asterisk.org/svn/asterisk/trunk/contrib/ast-db-manage/) folder:

$ cd contrib/ast-db-manageFor the rest of this tutorial, we will assume that operations will be taken in the context of that directory.

Configuring Alembic
-------------------

Within this directory, you will find a configuration sample file, `config.ini.sample`, which will need to be edited to connect to your database of choice. Open this file in your text editor of choice and then save a copy of this sample file as `config.ini` - this will serve as the configuration file you actually use with Alembic.

There are two different parameters in `config.ini` that require review: `sqlalchemy.url` and `script_location`. The first specifies the database to upgrade; the second which upgrades to perform.

1. Update `sqlalchemy.url` to the URL for your database. An example is shown below for a MySQL database:

sqlalchemy.url = mysql://root:password@localhost/asteriskThis would connect to a MySQL database as user `root` with password `password`. The database is `asterisk`, located on `localhost`. Different databases will require different URL schemas; however, they should in general follow the format outlined above. Alembic supports many different database technologies, including `oracle`, `postgresql`, and `mssql`.

For more information, see the Alembic documentation on SQLAlchemy URLs: <http://docs.sqlalchemy.org/en/rel_0_8/core/engines.html#database-urls>
2. Update `script_location` to the schema to update. Asterisk currently supports two sets of schemas:
	1. `config` - the set of schemas for Asterisk Realtime databases
	2. `voicemail` - the schema for ODBC VoiceMail

Executing the database upgrade
------------------------------

I'm sorry Dave, I'm afraid I can't let you do that.Using config.ini for Alembic will populate tables for all of the configuration objects that can be populated this way, so if you really don't want a table for sip peers, iax friends, voicemail, meetme, and music on hold, you may need to exercise a little fine control. Back up your database before continuing and be prepared to delete tables that you don't want when you are finished.

Your config.ini should be ready for use at this point, so close your text editor and return to the terminal. Then run:

$ alembic -c config.ini upgrade headAt this point, if you configured your config.ini to connect to the database properly, your tables should be ready.

Troubleshooting the upgrade
---------------------------

**Symptom:** Running 'alembic -c config.ini upgrade head' fails with a traceback:

Traceback (most recent call last):
 File "/usr/local/bin/alembic", line 9, in <module>
 load\_entry\_point('alembic==0.7.5.post2', 'console\_scripts', 'alembic')()
<snip>
 File "/usr/local/lib/python2.7/dist-packages/sqlalchemy/dialects/mysql/mysqldb.py", line 92, in dbapi
 return \_\_import\_\_('MySQLdb')
ImportError: No module named MySQLdb**Solution**: You probably need the Python interface to MySQL installed.

For example, with Ubuntu, install the following package and then re-run your Alembic upgrade.

# apt-get install python-mysqldb 

 

 

