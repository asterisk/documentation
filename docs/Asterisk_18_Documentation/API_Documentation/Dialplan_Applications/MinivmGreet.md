---
search:
  boost: 0.5
title: MinivmGreet
---

# MinivmGreet()

### Synopsis

Play Mini-Voicemail prompts.

### Description

This application is part of the Mini-Voicemail system, configured in minivm.conf.<br>

MinivmGreet() plays default prompts or user specific prompts for an account.<br>

Busy and unavailable messages can be choosen, but will be overridden if a temporary message exists for the account.<br>


* `MVM_GREET_STATUS` - This is the status of the greeting playback.<br>

    * `SUCCESS`

    * `USEREXIT`

    * `FAILED`

### Syntax


```

MinivmGreet(username@domain,[options])
```
##### Arguments


* `mailbox`

    * `username` **required** - Voicemail username<br>

    * `domain` **required** - Voicemail domain<br>

* `options`

    * `b` - Play the 'busy' greeting to the calling party.<br>


    * `s` - Skip the playback of instructions for leaving a message to the calling party.<br>


    * `u` - Play the 'unavailable' greeting.<br>



### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 