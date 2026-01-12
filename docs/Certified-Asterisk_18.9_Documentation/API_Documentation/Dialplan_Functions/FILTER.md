---
search:
  boost: 0.5
title: FILTER
---

# FILTER()

### Synopsis

Filter the string to include only the allowed characters

### Description

Permits all characters listed in _allowed-chars_, filtering all others outs. In addition to literally listing the characters, you may also use ranges of characters (delimited by a '-'<br>

Hexadecimal characters started with a '\x'(i.e. \x20)<br>

Octal characters started with a '\0' (i.e. \040)<br>

Also '\t','\n' and '\r' are recognized.<br>


/// note
If you want the '-' character it needs to be prefixed with a '\'
///


### Syntax


```

FILTER(allowed-chars,string)
```
##### Arguments


* `allowed-chars`

* `string`


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 