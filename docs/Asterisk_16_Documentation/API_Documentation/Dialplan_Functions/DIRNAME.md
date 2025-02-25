---
search:
  boost: 0.5
title: DIRNAME
---

# DIRNAME()

### Synopsis

Return the directory of a file.

### Since

16.21.0, 18.7.0, 19.0.0

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

* [Dialplan Functions BASENAME](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/BASENAME)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 