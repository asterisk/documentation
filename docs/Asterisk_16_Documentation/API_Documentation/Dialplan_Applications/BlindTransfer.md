---
search:
  boost: 0.5
title: BlindTransfer
---

# BlindTransfer()

### Synopsis

Blind transfer channel(s) to the extension and context provided

### Description

Redirect all channels currently bridged to the caller channel to the specified destination.<br>

The result of the application will be reported in the **BLINDTRANSFERSTATUS** channel variable:<br>


* `BLINDTRANSFERSTATUS`

    * `SUCCESS` - Transfer succeeded.

    * `FAILURE` - Transfer failed.

    * `INVALID` - Transfer invalid.

    * `NOTPERMITTED` - Transfer not permitted.

### Syntax


```

BlindTransfer(exten,[context])
```
##### Arguments


* `exten` - Specify extension.<br>

* `context` - Optionally specify a context. By default, Asterisk will use the caller channel context.<br>


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 