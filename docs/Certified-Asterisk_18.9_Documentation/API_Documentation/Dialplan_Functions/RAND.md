---
search:
  boost: 0.5
title: RAND
---

# RAND()

### Synopsis

Choose a random number in a range.

### Description

Choose a random number between _min_ and _max_. _min_ defaults to '0', if not specified, while _max_ defaults to 'RAND\_MAX' (2147483647 on many systems).<br>

Example: Set(junky=$\{RAND(1,8)\}); Sets junky to a random number between 1 and 8, inclusive.<br>


### Syntax


```

RAND(min,max)
```
##### Arguments


* `min`

* `max`


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 