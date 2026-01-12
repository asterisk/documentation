---
search:
  boost: 0.5
title: SpeechDestroy
---

# SpeechDestroy()

### Synopsis

End speech recognition.

### Description

This destroys the information used by all the other speech recognition applications. If you call this application but end up wanting to recognize more speech, you must call SpeechCreate() again before calling any other application.<br>

Hangs up the channel on failure. If this is not desired, use TryExec.<br>


### Syntax


```

SpeechDestroy()
```
##### Arguments


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 