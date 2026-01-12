---
search:
  boost: 0.5
title: PITCH_SHIFT
---

# PITCH_SHIFT()

### Synopsis

Pitch shift both tx and rx audio streams on a channel.

### Description

Examples:<br>

exten => 1,1,Set(PITCH\_SHIFT(tx)=highest); raises pitch an octave<br>

exten => 1,1,Set(PITCH\_SHIFT(rx)=higher) ; raises pitch more<br>

exten => 1,1,Set(PITCH\_SHIFT(both)=high) ; raises pitch<br>

exten => 1,1,Set(PITCH\_SHIFT(rx)=low) ; lowers pitch<br>

exten => 1,1,Set(PITCH\_SHIFT(tx)=lower) ; lowers pitch more<br>

exten => 1,1,Set(PITCH\_SHIFT(both)=lowest) ; lowers pitch an octave<br>

exten => 1,1,Set(PITCH\_SHIFT(rx)=0.8) ; lowers pitch<br>

exten => 1,1,Set(PITCH\_SHIFT(tx)=1.5) ; raises pitch<br>


### Syntax


```

PITCH_SHIFT(channel direction)
```
##### Arguments


* `channel direction` - Direction can be either 'rx', 'tx', or 'both'. The direction can either be set to a valid floating point number between 0.1 and 4.0 or one of the enum values listed below. A value of 1.0 has no effect. Greater than 1 raises the pitch. Lower than 1 lowers the pitch.<br>
The pitch amount can also be set by the following values<br>

    * `highest`

    * `higher`

    * `high`

    * `low`

    * `lower`

    * `lowest`


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 