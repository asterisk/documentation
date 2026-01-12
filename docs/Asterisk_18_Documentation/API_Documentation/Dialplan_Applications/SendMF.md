---
search:
  boost: 0.5
title: SendMF
---

# SendMF()

### Synopsis

Sends arbitrary MF digits on the current or specified channel.

### Since

16.21.0, 18.7.0, 19.0.0

### Description

It will send all digits or terminate if it encounters an error.<br>


### Syntax


```

SendMF(digits,[timeout_ms,[duration_ms,[duration_ms_kp,[duration_ms_st,[channel]]]]])
```
##### Arguments


* `digits` - List of digits 0-9,*#ABC to send; w for a half-second pause, also f or F for a flash-hook if the channel supports flash-hook, h or H for 250 ms of 2600 Hz, and W for a wink if the channel supports wink.<br>
Key pulse and start digits are not included automatically. * is used for KP, # for ST, A for STP, B for ST2P, and C for ST3P.<br>

* `timeout_ms` - Amount of time to wait in ms between tones. (defaults to 50ms).<br>

* `duration_ms` - Duration of each numeric digit (defaults to 55ms).<br>

* `duration_ms_kp` - Duration of KP digits (defaults to 120ms).<br>

* `duration_ms_st` - Duration of ST, STP, ST2P, and ST3P digits (defaults to 65ms).<br>

* `channel` - Channel where digits will be played<br>

### See Also

* [Dialplan Applications ReceiveMF](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/ReceiveMF)
* [Dialplan Applications SendSF](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/SendSF)
* [Dialplan Applications SendDTMF](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/SendDTMF)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 