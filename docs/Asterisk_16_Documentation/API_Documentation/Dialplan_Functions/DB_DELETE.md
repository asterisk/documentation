---
search:
  boost: 0.5
title: DB_DELETE
---

# DB_DELETE()

### Synopsis

Return a value from the database and delete it.

### Description

This function will retrieve a value from the Asterisk database and then remove that key from the database. **DB\_RESULT** will be set to the key's value if it exists.<br>


/// note
If 'live\_dangerously' in 'asterisk.conf' is set to 'no', this function can only be read from the dialplan, and not directly from external protocols. It can, however, be executed as a write operation ('DB\_DELETE(family, key)=ignored')
///


### Syntax


```

DB_DELETE(family/key)
```
##### Arguments


* `family`

* `key`

### See Also

* [Dialplan Applications DBdel](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/DBdel)
* [Dialplan Functions DB](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/DB)
* [Dialplan Applications DBdeltree](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/DBdeltree)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 