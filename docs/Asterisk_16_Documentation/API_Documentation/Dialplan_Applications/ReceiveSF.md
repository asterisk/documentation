---
search:
  boost: 0.5
title: ReceiveSF
---

# ReceiveSF()

### Synopsis

Detects SF digits on a channel and saves them to a variable.

### Since

16.24.0, 18.10.0, 19.2.0

### Description

Reads SF digits from the user in to the given _variable_.<br>

This application does not automatically answer the channel and should be preceded with 'Answer' or 'Progress' as needed.<br>


* `RECEIVESFSTATUS` - This is the status of the read operation.<br>

    * `START`

    * `ERROR`

    * `HANGUP`

    * `MAXDIGITS`

    * `TIMEOUT`

### Syntax


```

ReceiveSF(variable,[digits,[timeout,[frequency,[options]]]])
```
##### Arguments


* `variable` - The input digits will be stored in the given _variable_ name.<br>

* `digits` - Maximum number of digits to read. Default is unlimited.<br>

* `timeout` - The number of seconds to wait for all digits, if greater than '0'. Can be floating point. Default is no timeout.<br>

* `frequency` - The frequency for which to detect pulsed digits. Default is 2600 Hz.<br>

* `options`

    * `d` - Delay audio by a frame to try to extra quelch.<br>


    * `e` - Allow receiving extra pulses 11 through 16.<br>


    * `m` - Mute conference.<br>


    * `q` - Quelch SF from in-band.<br>


    * `r` - "Radio" mode (relaxed SF).<br>


### See Also

* [Dialplan Applications ReceiveMF](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/ReceiveMF)
* [Dialplan Applications SendMF](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/SendMF)
* [Dialplan Applications SendSF](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/SendSF)
* [Dialplan Applications Read](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/Read)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 