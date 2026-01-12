---
search:
  boost: 0.5
title: ReceiveMF
---

# ReceiveMF()

### Synopsis

Detects MF digits on a channel and saves them to a variable.

### Since

16.21.0, 18.7.0, 19.0.0

### Description

Reads a ST, STP, ST2P, or ST3P-terminated string of MF digits from the user in to the given _variable_.<br>

This application does not automatically answer the channel and should be preceded with 'Answer' or 'Progress' as needed.<br>


* `RECEIVEMFSTATUS` - This is the status of the read operation.<br>

    * `START`

    * `ERROR`

    * `HANGUP`

    * `MAXDIGITS`

    * `TIMEOUT`

### Syntax


```

ReceiveMF(variable,[timeout,[options]])
```
##### Arguments


* `variable` - The input digits will be stored in the given _variable_ name.<br>

* `timeout` - The number of seconds to wait for all digits, if greater than '0'. Can be floating point. Default is no timeout.<br>

* `options`

    * `d` - Delay audio by a frame to try to extra quelch.<br>


    * `l` - Receive digits even if a key pulse (KP) has not yet been received. By default, this application will ignore all other digits until a KP has been received.<br>


    * `k` - Do not return a character for the KP digit.<br>


    * `m` - Mute conference.<br>


    * `n` - Maximum number of digits, regardless of the sequence.<br>


    * `o` - Enable override. Repeated KPs will clear all previous digits.<br>


    * `q` - Quelch MF from in-band.<br>


    * `r` - "Radio" mode (relaxed MF).<br>


    * `s` - Do not return a character for ST digits.<br>


### See Also

* [Dialplan Applications Read](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/Read)
* [Dialplan Applications SendMF](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/SendMF)
* [Dialplan Applications ReceiveSF](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/ReceiveSF)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 