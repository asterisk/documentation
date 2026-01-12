---
search:
  boost: 0.5
title: STACK_PEEK
---

# STACK_PEEK()

### Synopsis

View info about the location which called Gosub

### Description

Read the calling 'c'ontext, 'e'xtension, 'p'riority, or 'l'abel, as specified by _which_, by going up _n_ frames in the Gosub stack. If _suppress_ is true, then if the number of available stack frames is exceeded, then no error message will be printed.<br>


### Syntax


```

STACK_PEEK(n,which[,suppress])
```
##### Arguments


* `n`

* `which`

* `suppress`


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 