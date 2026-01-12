---
search:
  boost: 0.5
title: ICONV
---

# ICONV()

### Synopsis

Converts charsets of strings.

### Description

Converts string from _in-charset_ into _out-charset_. For available charsets, use 'iconv -l' on your shell command line.<br>


/// note
Due to limitations within the API, ICONV will not currently work with charsets with embedded NULLs. If found, the string will terminate.
///


### Syntax


```

ICONV(in-charset,out-charset,string)
```
##### Arguments


* `in-charset` - Input charset<br>

* `out-charset` - Output charset<br>

* `string` - String to convert, from _in-charset_ to _out-charset_<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 