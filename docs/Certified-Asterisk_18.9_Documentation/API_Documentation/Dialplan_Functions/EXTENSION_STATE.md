---
search:
  boost: 0.5
title: EXTENSION_STATE
---

# EXTENSION_STATE()

### Synopsis

Get an extension's state.

### Description

The EXTENSION\_STATE function can be used to retrieve the state from any hinted extension. For example:<br>

NoOp(1234@default has state $\{EXTENSION\_STATE(1234)\})<br>

NoOp(4567@home has state $\{EXTENSION\_STATE(4567@home)\})<br>

The possible values returned by this function are:<br>

UNKNOWN | NOT\_INUSE | INUSE | BUSY | INVALID | UNAVAILABLE | RINGING | RINGINUSE | HOLDINUSE | ONHOLD<br>


### Syntax


```

EXTENSION_STATE(extension@context)
```
##### Arguments


* `extension`

* `context` - If it is not specified defaults to 'default'.<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 