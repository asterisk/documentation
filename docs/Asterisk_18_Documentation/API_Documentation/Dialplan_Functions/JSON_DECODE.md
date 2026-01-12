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

JSON_DECODE(varname,item[,separator[,options]])
```
##### Arguments


* `varname` - The name of the variable containing the JSON string to parse.<br>

* `item` - The name of the key whose value to return.<br>
Multiple keys can be listed separated by a hierarchy delimeter, which will recursively index into a nested JSON string to retrieve a specific subkey's value.<br>

* `separator` - A single character that delimits a key hierarchy for nested indexing. Default is a period (.)<br>
This value should not appear in the key or hierarchy of keys itself, except to delimit the hierarchy of keys.<br>

* `options`

    * `c` - For keys that reference a JSON array, return the number of items in the array.<br>
This option has no effect on any other type of value.<br>


### See Also

* [Dialplan Functions CURL](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/CURL)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 