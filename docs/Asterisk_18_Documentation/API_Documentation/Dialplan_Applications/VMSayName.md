---
search:
  boost: 0.5
title: VMSayName
---

# VMSayName()

### Synopsis

Play the name of a voicemail user

### Description

This application will say the recorded name of the voicemail user specified as the argument to this application. If no context is provided, 'default' is assumed.<br>

Similar to the Background() application, playback of the recorded name can be interrupted by entering an extension, which will be searched for in the current context.<br>


### Syntax


```

VMSayName([mailbox@[context]])
```
##### Arguments


* `mailbox`

    * `mailbox`

    * `context`


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 