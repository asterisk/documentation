---
search:
  boost: 0.5
title: ENUMLOOKUP
---

# ENUMLOOKUP()

### Synopsis

General or specific querying of NAPTR records for ENUM or ENUM-like DNS pointers.

### Description

For more information see *doc/AST.pdf*.<br>


### Syntax


```

ENUMLOOKUP(number,method-type,options,record#,zone-suffix)
```
##### Arguments


* `number`

* `method-type` - If no _method-type_ is given, the default will be 'sip'.<br>

* `options`

    * `c` - Returns an integer count of the number of NAPTRs of a certain RR type.<br>
Combination of 'c' and Method-type of 'ALL' will return a count of all NAPTRs for the record or -1 on error.<br>


    * `u` - Returns the full URI and does not strip off the URI-scheme.<br>


    * `s` - Triggers ISN specific rewriting.<br>


    * `i` - Looks for branches into an Infrastructure ENUM tree.<br>


    * `d` - for a direct DNS lookup without any flipping of digits.<br>


* `record#` - If no _record#_ is given, defaults to '1'.<br>

* `zone-suffix` - If no _zone-suffix_ is given, the default will be 'e164.arpa'<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 