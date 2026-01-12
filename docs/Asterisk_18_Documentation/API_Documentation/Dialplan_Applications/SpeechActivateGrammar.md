---
search:
  boost: 0.5
title: SpeechActivateGrammar
---

# SpeechActivateGrammar()

### Synopsis

Activate a grammar.

### Description

This activates the specified grammar to be recognized by the engine. A grammar tells the speech recognition engine what to recognize, and how to portray it back to you in the dialplan. The grammar name is the only argument to this application.<br>

Hangs up the channel on failure. If this is not desired, use TryExec.<br>


### Syntax


```

SpeechActivateGrammar(grammar_name)
```
##### Arguments


* `grammar_name`


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 