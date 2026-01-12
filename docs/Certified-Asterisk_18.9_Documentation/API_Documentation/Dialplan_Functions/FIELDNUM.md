---
search:
  boost: 0.5
title: FIELDNUM
---

# FIELDNUM()

### Synopsis

Return the 1-based offset of a field in a list

### Description

Search the variable named _varname_ for the string _value_ delimited by _delim_ and return a 1-based offset as to its location. If not found or an error occured, return '0'.<br>

The delimiter may be specified as a special or extended ASCII character, by encoding it. The characters '\n', '\r', and '\t' are all recognized as the newline, carriage return, and tab characters, respectively. Also, octal and hexadecimal specifications are recognized by the patterns '\0nnn' and '\xHH', respectively. For example, if you wanted to encode a comma as the delimiter, you could use either '\054' or '\x2C'.<br>

Example: If $\{example\} contains 'ex-amp-le', then $\{FIELDNUM(example,-,amp)\} returns 2.<br>


### Syntax


```

FIELDNUM(varname,delim,value)
```
##### Arguments


* `varname`

* `delim`

* `value`


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 