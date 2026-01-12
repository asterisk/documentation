---
search:
  boost: 0.5
title: DB_EXISTS
---

# DB_EXISTS()

### Synopsis

Check to see if a key exists in the Asterisk database.

### Description

This function will check to see if a key exists in the Asterisk database. If it exists, the function will return '1'. If not, it will return '0'. Checking for existence of a database key will also set the variable DB\_RESULT to the key's value if it exists.<br>


### Syntax


```

DB_EXISTS(family/key)
```
##### Arguments


* `family`

* `key`

### See Also

* [Dialplan Functions DB](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/DB)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 