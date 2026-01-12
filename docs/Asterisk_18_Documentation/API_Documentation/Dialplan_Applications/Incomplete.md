---
search:
  boost: 0.5
title: Incomplete
---

# Incomplete()

### Synopsis

Returns AST_PBX_INCOMPLETE value.

### Description

Signals the PBX routines that the previous matched extension is incomplete and that further input should be allowed before matching can be considered to be complete. Can be used within a pattern match when certain criteria warrants a longer match.<br>


### Syntax


```

Incomplete([n])
```
##### Arguments


* `n` - If specified, then Incomplete will not attempt to answer the channel first.<br>

    /// note
Most channel types need to be in Answer state in order to receive DTMF.
///



### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 