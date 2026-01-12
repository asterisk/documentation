---
search:
  boost: 0.5
title: MinivmAccMess
---

# MinivmAccMess()

### Synopsis

Record account specific messages.

### Description

This application is part of the Mini-Voicemail system, configured in *minivm.conf*.<br>

Use this application to record account specific audio/video messages for busy, unavailable and temporary messages.<br>

Account specific directories will be created if they do not exist.<br>


* `MVM_ACCMESS_STATUS` - This is the result of the attempt to record the specified greeting.<br>
FAILED is set if the file can't be created.<br>

    * `SUCCESS`

    * `FAILED`

### Syntax


```

MinivmAccMess(username@domain,[options])
```
##### Arguments


* `mailbox`

    * `username` **required** - Voicemail username<br>

    * `domain` **required** - Voicemail domain<br>

* `options`

    * `u` - Record the 'unavailable' greeting.<br>


    * `b` - Record the 'busy' greeting.<br>


    * `t` - Record the temporary greeting.<br>


    * `n` - Account name.<br>



### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 