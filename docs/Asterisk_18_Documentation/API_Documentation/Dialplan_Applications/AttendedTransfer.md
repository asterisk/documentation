---
search:
  boost: 0.5
title: AttendedTransfer
---

# AttendedTransfer()

### Synopsis

Attended transfer to the extension provided and TRANSFER_CONTEXT

### Description

Queue up attended transfer to the specified extension in the 'TRANSFER\_CONTEXT'.<br>

Note that the attended transfer only work when two channels have answered and are bridged together.<br>

Make sure to set Attended Transfer DTMF feature 'atxfer' and attended transfer is permitted.<br>

The result of the application will be reported in the **ATTENDEDTRANSFERSTATUS** channel variable:<br>


* `ATTENDEDTRANSFERSTATUS`

    * `SUCCESS` - Transfer successfully queued.

    * `FAILURE` - Transfer failed.

    * `NOTPERMITTED` - Transfer not permitted.

### Syntax


```

AttendedTransfer(exten)
```
##### Arguments


* `exten` - Specify extension.<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 