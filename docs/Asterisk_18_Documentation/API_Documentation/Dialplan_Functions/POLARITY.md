---
search:
  boost: 0.5
title: POLARITY
---

# POLARITY()

### Synopsis

Set or get the polarity of a DAHDI channel.

### Description

The POLARITY function can be used to set the polarity of a DAHDI channel.<br>

Applies only to FXS channels (using FXO signalling) with supporting hardware.<br>

The polarity can be set to the following numeric or named values:<br>


* `0`

* `idle`

* `1`

* `reverse`
However, when read, the function will always return 0 or 1.<br>

``` title="Example: Set idle polarity"

same => n,Set(POLARITY()=0)


```
``` title="Example: Set reverse polarity"

same => n,NoOp(Current Polarity: ${POLARITY()})
same => n,Set(POLARITY()=reverse)
same => n,NoOp(New Polarity: ${POLARITY()})


```
``` title="Example: Reverse the polarity from whatever it is currently"

same => n,Set(POLARITY()=${IF($[ "${POLARITY()}" = "1" ]?0:1)})


```

### Syntax


```

POLARITY()
```
##### Arguments


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 