---
search:
  boost: 0.5
title: BASENAME
---

# BASENAME()

### Synopsis

Return the name of a file.

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

* [Dialplan Functions DIRNAME](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/DIRNAME)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 