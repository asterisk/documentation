---
search:
  boost: 0.5
title: StoreDTMF
---

# StoreDTMF()

### Synopsis

Stores DTMF digits transmitted or received on a channel.

### Since

16.20.0, 18.6.0, 19.0.0

### Description

The StoreDTMF function can be used to obtain digits sent in the 'TX' or 'RX' direction of any channel.<br>

The arguments are:<br>

var_name: Name of variable to which to append digits.<br>

max_digits: The maximum number of digits to store in the variable. Defaults to 0 (no maximum). After reading maximum digits, no more digits will be stored.<br>

``` title="Example: Store digits in CDR variable"

same => n,StoreDTMF(TX,CDR(digits))


```
``` title="Example: Store up to 24 digits"

same => n,StoreDTMF(RX,testvar,24)


```
``` title="Example: Disable digit collection"

same => n,StoreDTMF(remove)


```

### Syntax


```

StoreDTMF(direction)
```
##### Arguments


* `direction` - Must be 'TX' or 'RX' to store digits, or 'remove' to disable.<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 