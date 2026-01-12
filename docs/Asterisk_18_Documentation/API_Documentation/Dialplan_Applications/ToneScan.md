---
search:
  boost: 0.5
title: ToneScan
---

# ToneScan()

### Synopsis

Wait for period of time while scanning for call progress tones

### Since

16.23.0, 18.9.0, 19.1.0

### Description

Waits for a a distinguishable call progress tone and then exits. Unlike a conventional scanner, this is not currently capable of scanning for modem carriers.<br>


* `TONESCANSTATUS`

    * `RINGING` - Audible ringback tone

    * `BUSY` - Busy tone

    * `SIT` - Special Information Tones

    * `VOICE` - Human voice detected

    * `DTMF` - DTMF digit

    * `FAX` - Fax (answering)

    * `MODEM` - Modem (answering)

    * `DIALTONE` - Dial tone

    * `NUT` - UK Number Unobtainable tone

    * `TIMEOUT` - Timeout reached before any positive detection

    * `HANGUP` - Caller hung up before any positive detection

### Syntax


```

ToneScan([zone,[timeout,[threshold,[options]]]])
```
##### Arguments


* `zone` - Call progress zone. Default is the system default.<br>

* `timeout` - Maximum amount of time, in seconds, to wait for call progress or signal tones. Default is forever.<br>

* `threshold` - DSP threshold required for a match. A higher number will require a longer match and may reduce false positives, at the expense of false negatives. Default is 1.<br>

* `options`

    * `f` - Enable fax machine detection. By default, this is disabled.<br>


    * `v` - Enable voice detection. By default, this is disabled.<br>


### See Also

* [Dialplan Applications WaitForTone](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/WaitForTone)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 