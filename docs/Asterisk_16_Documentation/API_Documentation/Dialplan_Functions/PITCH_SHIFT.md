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

``` title="Example: Raises pitch an octave"

exten => 1,1,Set(PITCH_SHIFT(tx)=highest)


```
``` title="Example: Raises pitch more"

exten => 1,1,Set(PITCH_SHIFT(rx)=higher)


```
``` title="Example: Raises pitch"

exten => 1,1,Set(PITCH_SHIFT(both)=high)


```
``` title="Example: Lowers pitch"

exten => 1,1,Set(PITCH_SHIFT(rx)=low)


```
``` title="Example: Lowers pitch more"

exten => 1,1,Set(PITCH_SHIFT(tx)=lower)


```
``` title="Example: Lowers pitch an octave"

exten => 1,1,Set(PITCH_SHIFT(both)=lowest)


```
``` title="Example: Lowers pitch"

exten => 1,1,Set(PITCH_SHIFT(rx)=0.8)


```
``` title="Example: Raises pitch"

exten => 1,1,Set(PITCH_SHIFT(tx)=1.5)


```

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

This documentation was generated from Asterisk branch 16 using version GIT 