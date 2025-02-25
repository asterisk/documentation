---
search:
  boost: 0.5
title: JSON_DECODE
---

# JSON_DECODE()

### Synopsis

Returns the string value of a JSON object key from a string containing a JSON array.

### Since

16.24.0, 18.10.0, 19.2.0

### Description

The JSON\_DECODE function retrieves the value of the given variable name and parses it as JSON, returning the value at a specified key. If the key cannot be found, an empty string is returned.<br>


### Syntax


```

JSON_DECODE(varname,item)
```
##### Arguments


* `varname` - The name of the variable containing the JSON string to parse.<br>

* `item` - The name of the key whose value to return.<br>

### See Also

* [Dialplan Functions CURL](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/CURL)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 