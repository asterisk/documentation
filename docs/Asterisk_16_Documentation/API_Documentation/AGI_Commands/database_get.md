---
search:
  boost: 0.5
title: DATABASE GET
---

# DATABASE GET

### Synopsis

Gets database value

### Description

Retrieves an entry in the Asterisk database for a given _family_ and _key_.<br>

Returns '0' if _key_ is not set. Returns '1' if _key_ is set and returns the variable in parenthesis.<br>

Example return code: 200 result=1 (testvariable)<br>


### Syntax


```

DATABASE GET FAMILY KEY 
```
##### Arguments


* `family`

* `key`

### See Also

* [AGI Commands database_put](/Asterisk_16_Documentation/API_Documentation/AGI_Commands/database_put)
* [AGI Commands database_del](/Asterisk_16_Documentation/API_Documentation/AGI_Commands/database_del)
* [AGI Commands database_deltree](/Asterisk_16_Documentation/API_Documentation/AGI_Commands/database_deltree)
* [Dialplan Applications AGI](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/AGI)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 