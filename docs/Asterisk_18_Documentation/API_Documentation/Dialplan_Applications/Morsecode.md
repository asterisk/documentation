---
search:
  boost: 0.5
title: Morsecode
---

# Morsecode()

### Synopsis

Plays morse code.

### Description

Plays the Morse code equivalent of the passed string.<br>

This application does not automatically answer and should be preceeded by an application such as Answer() or Progress().<br>

This application uses the following variables:<br>


* `MORSEDITLEN` - Use this value in (ms) for length of dit<br>

* `MORSETONE` - The pitch of the tone in (Hz), default is 800<br>

* `MORSESPACETONE` - The pitch of the spaces in (Hz), default is 0<br>

* `MORSETYPE` - The code type to use (AMERICAN for standard American Morse or INTERNATIONAL for international code. Default is INTERNATIONAL).<br>

### Syntax


```

Morsecode(string)
```
##### Arguments


* `string` - String to playback as morse code to channel<br>

### See Also

* [Dialplan Applications SayAlpha](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/SayAlpha)
* [Dialplan Applications SayPhonetic](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/SayPhonetic)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 