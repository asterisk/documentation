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

SpeechBackground(sound_file&[sound_file2[&...]],[timeout,[options]])
```
##### Arguments


* `sound_file` - Ampersand separated list of filenames. If the filename is a relative filename (it does not begin with a slash), it will be searched for in the Asterisk sounds directory. If the filename is able to be parsed as a URL, Asterisk will download the file and then begin playback on it. To include a literal '&' in the URL you can enclose the URL in single quotes.<br>

    * `sound_file` **required**

    * `sound_file2[,sound_file2...]`

* `timeout` - Timeout integer in seconds. Note the timeout will only start once the sound file has stopped playing.<br>

* `options`

    * `n` - Don't answer the channel if it has not already been answered.<br>


    * `p` - Return partial results when backend is terminated by timeout.<br>



### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 