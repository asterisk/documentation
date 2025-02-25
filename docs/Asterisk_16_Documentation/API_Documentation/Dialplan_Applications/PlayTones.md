---
search:
  boost: 0.5
title: PlayTones
---

# PlayTones()

### Synopsis

Play a tone list.

### Description

Plays a tone list. Execution will continue with the next step in the dialplan immediately while the tones continue to play.<br>

See the sample *indications.conf* for a description of the specification of a tonelist.<br>


### Syntax


```

PlayTones(arg)
```
##### Arguments


* `arg` - Arg is either the tone name defined in the *indications.conf* configuration file, or a directly specified list of frequencies and durations.<br>

### See Also

* [Dialplan Applications StopPlayTones](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/StopPlayTones)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 