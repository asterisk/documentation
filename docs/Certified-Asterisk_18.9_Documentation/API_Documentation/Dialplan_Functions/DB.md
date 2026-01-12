---
search:
  boost: 0.5
title: DB
---

# DB()

### Synopsis

Read from or write to the Asterisk database.

### Description

This function will read from or write a value to the Asterisk database. On a read, this function returns the corresponding value from the database, or blank if it does not exist. Reading a database value will also set the variable DB\_RESULT. If you wish to find out if an entry exists, use the DB\_EXISTS function.<br>


### Syntax


```

DB(family/key)
```
##### Arguments


* `family`

* `key`

### See Also

* [Dialplan Applications DBdel](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/DBdel)
* [Dialplan Functions DB_DELETE](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/DB_DELETE)
* [Dialplan Applications DBdeltree](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/DBdeltree)
* [Dialplan Functions DB_EXISTS](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/DB_EXISTS)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 