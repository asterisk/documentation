---
search:
  boost: 0.5
title: FIELDQTY
---

# FIELDQTY()

### Synopsis

Count the fields with an arbitrary delimiter

### Description

The delimiter may be specified as a special or extended ASCII character, by encoding it. The characters '\n', '\r', and '\t' are all recognized as the newline, carriage return, and tab characters, respectively. Also, octal and hexadecimal specifications are recognized by the patterns '\0nnn' and '\xHH', respectively. For example, if you wanted to encode a comma as the delimiter, you could use either '\054' or '\x2C'.<br>

``` title="Example: Prints 3"

exten => s,1,Set(example=ex-amp-le)
same => n,NoOp(${FIELDQTY(example,-)})


```

### Syntax


```

FIELDQTY(varname,delim)
```
##### Arguments


* `varname`

* `delim`


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 