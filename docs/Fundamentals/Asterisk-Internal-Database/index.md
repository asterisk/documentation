---
title: Overview
pageid: 27200271
---

Asterisk comes with a database that is used internally and made available for Asterisk programmers and administrators to use as they see fit.

Asterisk versions up to 1.8 used the Berkeley DB, and **in version 10** the project moved to the **SQLite3 database**. You can read about database migration between those major versions in the section [SQLite3 astdb back-end](/Fundamentals/Asterisk-Internal-Database/SQLite3-astdb-back-end).

Purpose of the internal database
--------------------------------

The database really has two purposes:

1. Asterisk uses it to store information that needs to persist between reloads/restarts. Various modules use it for this purpose automatically.
2. Users can use it to store arbitrary data. This is done using a variety of dialplan applications and functions such as:
	* Functions:
		+ [DB](/Latest_API/API_Documentation/Dialplan_Functions/DB)
		+ [DB_DELETE](/Latest_API/API_Documentation/Dialplan_Functions/DB_DELETE)
		+ [DB_EXISTS](/Latest_API/API_Documentation/Dialplan_Functions/DB_EXISTS)
		+ [DB_KEYS](/Latest_API/API_Documentation/Dialplan_Functions/DB_KEYS)
	* Application: [DBdeltree](/Latest_API/API_Documentation/Dialplan_Applications/DBdeltree)

The functions and applications for Asterisk 11 are linked above, but you should look at the documentation for the version you have deployed.

Database commands on the CLI
----------------------------

Sub-commands under the command "database" allow a variety of functions to be performed on or with the database.

```
\*CLI> core show help database
database del -- Removes database key/value
database deltree -- Removes database keytree/values
database get -- Gets database value
database put -- Adds/updates database value
database query -- Run a user-specified query on the astdb
database show -- Shows database contents
database showkey -- Shows database contents

```

