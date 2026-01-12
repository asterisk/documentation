---
search:
  boost: 0.5
title: SCRAMBLE
---

# SCRAMBLE()

### Synopsis

Scrambles audio on a channel.

### Since

16.21.0, 18.7.0, 19.0.0

### Description

Scrambles audio on a channel using whole spectrum inversion. This is not intended to be used for securely scrambling audio. It merely renders obfuscates audio on a channel to render it unintelligible, as a privacy enhancement.<br>


### Syntax


```

SCRAMBLE([direction])
```
##### Arguments


* `direction` - Must be 'TX' or 'RX' to limit to a specific direction, or 'both' for both directions. 'remove' will remove an existing scrambler.<br>

### See Also

* [Dialplan Applications ChanSpy](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/ChanSpy)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 