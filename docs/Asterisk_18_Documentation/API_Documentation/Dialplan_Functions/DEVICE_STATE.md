---
search:
  boost: 0.5
title: DEVICE_STATE
---

# DEVICE_STATE()

### Synopsis

Get or Set a device state.

### Description

The DEVICE\_STATE function can be used to retrieve the device state from any device state provider. For example:<br>

NoOp(SIP/mypeer has state $\{DEVICE\_STATE(SIP/mypeer)\})<br>

NoOp(Conference number 1234 has state $\{DEVICE\_STATE(MeetMe:1234)\})<br>

The DEVICE\_STATE function can also be used to set custom device state from the dialplan. The 'Custom:' prefix must be used. For example:<br>

Set(DEVICE\_STATE(Custom:lamp1)=BUSY)<br>

Set(DEVICE\_STATE(Custom:lamp2)=NOT\_INUSE)<br>

You can subscribe to the status of a custom device state using a hint in the dialplan:<br>

exten => 1234,hint,Custom:lamp1<br>

The possible values for both uses of this function are:<br>

UNKNOWN | NOT\_INUSE | INUSE | BUSY | INVALID | UNAVAILABLE | RINGING | RINGINUSE | ONHOLD<br>


### Syntax


```

DEVICE_STATE(device)
```
##### Arguments


* `device`


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 