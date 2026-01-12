---
search:
  boost: 0.5
title: BASENAME
---

# BASENAME()

### Synopsis

Return the name of a file.

### Since

16.21.0, 18.7.0, 19.0.0

### Description

Return the base file name, given a full file path.<br>

``` title="Example: Directory name"

same => n,Set(basename=${BASENAME(/etc/asterisk/extensions.conf)})
same => n,NoOp(${basename}) ; outputs extensions.conf


```

### Syntax


```

BASENAME(filename)
```
##### Arguments


* `filename`

### See Also

* [Dialplan Functions DIRNAME](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/DIRNAME)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 