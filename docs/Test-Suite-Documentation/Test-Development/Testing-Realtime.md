---
title: Testing Realtime
pageid: 22773918
---

Background
----------

As many individuals know realtime is an API within Asterisk for allowing "realtime" access to certain objects using different engines. It is commonly used by configuration mechanisms and providers to allow instant updates to be reflected within their architecture. Unfortunately due to the use of external applications testing realtime has proved difficult in an automated fashion.

Realtime can be broken up into the following testable interactions:

1. Interaction between Asterisk realtime configuration engine and engine itself.

2. Interaction between realtime API calls and realtime configuration engine.

3. Interaction between realtime user and realtime API calls.

This page aims to describe an approach for testing #2 and #3 in an automated fashion.

Configuration Engine
--------------------

To allow the tests to operate in an automated fashion without configuration the res_config_sqlite3 realtime configuration engine should be used. As sqlite3 is simply a file based database no host details or persistent daemons are required. Each test should have a clean database with a table using the desired schema.

Testsuite
---------

As the Asterisk testsuite uses Python primarily the sqlite3 module for Python can be used to examine the state of rows within a table while Asterisk is in operation or after it has been terminated. The module can also be used to create the tables or to insert arbitrary rows. If this is not required the database can be created when the test is being written and copied into the expected location before Asterisk starts. This reduces the amount of work done by the test itself, since only verification may be required.

Asterisk
--------

Every test will require the extconfig.conf configuration file to contain the appropriate family mapping to the sqlite3 config engine with database.
