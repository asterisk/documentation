---
search:
  boost: 0.5
title: SpeechCreate
---

# SpeechCreate()

### Synopsis

Create a Speech Structure.

### Description

This application creates information to be used by all the other applications. It must be called before doing any speech recognition activities such as activating a grammar. It takes the engine name to use as the argument, if not specified the default engine will be used.<br>

Sets the ERROR channel variable to 1 if the engine cannot be used.<br>


### Syntax


```

SpeechCreate(engine_name)
```
##### Arguments


* `engine_name`


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 