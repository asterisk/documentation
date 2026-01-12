---
search:
  boost: 0.5
title: SendSF
---

# SendSF()

### Synopsis

Sends arbitrary SF digits on the current or specified channel.

### Since

16.24.0, 18.10.0, 19.2.0

### Description

It will send all digits or terminate if it encounters an error.<br>


### Syntax


```

SendSF(digits,[frequency,[channel]])
```
##### Arguments


* `digits` - List of digits 0-9 to send; w for a half-second pause, also f or F for a flash-hook if the channel supports flash-hook, h or H for 250 ms of 2600 Hz, and W for a wink if the channel supports wink.<br>

* `frequency` - Frequency to use. (defaults to 2600 Hz).<br>

* `channel` - Channel where digits will be played<br>

### See Also

* [Dialplan Applications SendDTMF](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/SendDTMF)
* [Dialplan Applications SendMF](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/SendMF)
* [Dialplan Applications ReceiveMF](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/ReceiveMF)
* [Dialplan Applications ReceiveSF](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/ReceiveSF)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 