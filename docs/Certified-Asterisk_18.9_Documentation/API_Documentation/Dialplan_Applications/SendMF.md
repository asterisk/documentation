---
search:
  boost: 0.5
title: SendMF
---

# SendMF()

### Synopsis

Sends arbitrary MF digits

### Description

It will send all digits or terminate if it encounters an error.<br>


### Syntax


```

SendMF(digits,[timeout_ms,[duration_ms,[duration_ms_kp,[duration_ms_st,[channel]]]]])
```
##### Arguments


* `digits` - List of digits 0-9,*#ABC to send; also f or F for a flash-hook if the channel supports flash-hook, and w or W for a wink if the channel supports wink.<br>
Key pulse and start digits are not included automatically. * is used for KP, # for ST, A for STP, B for ST2P, and C for ST3P.<br>

* `timeout_ms` - Amount of time to wait in ms between tones. (defaults to 50ms).<br>

* `duration_ms` - Duration of each numeric digit (defaults to 55ms).<br>

* `duration_ms_kp` - Duration of KP digits (defaults to 120ms).<br>

* `duration_ms_st` - Duration of ST, STP, ST2P, and ST3P digits (defaults to 65ms).<br>

* `channel` - Channel where digits will be played<br>

### See Also

* [Dialplan Applications SendDTMF](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/SendDTMF)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 