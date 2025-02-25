---
search:
  boost: 0.5
title: SpeechBackground
---

# SpeechBackground()

### Synopsis

Play a sound file and wait for speech to be recognized.

### Description

This application plays a sound file and waits for the person to speak. Once they start speaking playback of the file stops, and silence is heard. Once they stop talking the processing sound is played to indicate the speech recognition engine is working. Once results are available the application returns and results (score and text) are available using dialplan functions.<br>

The first text and score are $\{SPEECH\_TEXT(0)\} AND $\{SPEECH\_SCORE(0)\} while the second are $\{SPEECH\_TEXT(1)\} and $\{SPEECH\_SCORE(1)\}.<br>

The first argument is the sound file and the second is the timeout integer in seconds.<br>

Hangs up the channel on failure. If this is not desired, use TryExec.<br>


### Syntax


```

SpeechBackground(sound_file,[timeout,[options]])
```
##### Arguments


* `sound_file`

* `timeout` - Timeout integer in seconds. Note the timeout will only start once the sound file has stopped playing.<br>

* `options`

    * `n` - Don't answer the channel if it has not already been answered.<br>



### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 