---
search:
  boost: 0.5
title: KEYPADHASH
---

# KEYPADHASH()

### Synopsis

Hash the letters in string into equivalent keypad numbers.

### Description

``` title="Example: Returns 537"

exten => s,1,Return(${KEYPADHASH(Les)})


```

### Syntax


```

KEYPADHASH(string)
```
##### Arguments


* `string`


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 