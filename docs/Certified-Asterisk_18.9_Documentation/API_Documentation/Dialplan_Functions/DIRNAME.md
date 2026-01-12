---
search:
  boost: 0.5
title: DIRNAME
---

# DIRNAME()

### Synopsis

Return the directory of a file.

### Description

Return the directory of a file, given a full file path.<br>

``` title="Example: Directory name"

same => n,Set(dirname=${DIRNAME(/etc/asterisk/extensions.conf)})
same => n,NoOp(${dirname}) ; outputs /etc/asterisk


```

### Syntax


```

DIRNAME(filename)
```
##### Arguments


* `filename`

### See Also

* [Dialplan Functions BASENAME](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/BASENAME)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 