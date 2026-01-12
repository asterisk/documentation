---
search:
  boost: 0.5
title: SendDTMF
---

# SendDTMF()

### Synopsis

Sends arbitrary DTMF digits

### Description

It will send all digits or terminate if it encounters an error.<br>


### Syntax


```

SendDTMF(digits,[timeout_ms,[duration_ms,[channel,[options]]]])
```
##### Arguments


* `digits` - List of digits 0-9,*#,a-d,A-D to send also w for a half second pause, W for a one second pause, and f or F for a flash-hook if the channel supports flash-hook.<br>

* `timeout_ms` - Amount of time to wait in ms between tones. (defaults to .25s)<br>

* `duration_ms` - Duration of each digit<br>

* `channel` - Channel where digits will be played<br>

* `options`

    * `a` - Answer the channel specified by the 'channel' parameter if it is not already up. If no 'channel' parameter is provided, the current channel will be answered.<br>


### See Also

* [Dialplan Applications Read](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/Read)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 