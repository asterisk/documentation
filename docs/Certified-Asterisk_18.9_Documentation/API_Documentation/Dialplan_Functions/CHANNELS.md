---
search:
  boost: 0.5
title: CHANNELS
---

# CHANNELS()

### Synopsis

Gets the list of channels, optionally filtering by a regular expression.

### Description

Gets the list of channels, optionally filtering by a _regular\_expression_. If no argument is provided, all known channels are returned. The _regular\_expression_ must correspond to the POSIX.2 specification, as shown in *regex(7)*. The list returned will be space-delimited.<br>


### Syntax


```

CHANNELS(regular_expression)
```
##### Arguments


* `regular_expression`


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 