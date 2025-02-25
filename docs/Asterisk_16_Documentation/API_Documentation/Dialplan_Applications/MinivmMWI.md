---
search:
  boost: 0.5
title: MinivmMWI
---

# MinivmMWI()

### Synopsis

Send Message Waiting Notification to subscriber(s) of mailbox.

### Description

This application is part of the Mini-Voicemail system, configured in *minivm.conf*.<br>

MinivmMWI is used to send message waiting indication to any devices whose channels have subscribed to the mailbox passed in the first parameter.<br>


### Syntax


```

MinivmMWI(username@domain,urgent,new,old)
```
##### Arguments


* `mailbox`

    * `username` **required** - Voicemail username<br>

    * `domain` **required** - Voicemail domain<br>

* `urgent` - Number of urgent messages in mailbox.<br>

* `new` - Number of new messages in mailbox.<br>

* `old` - Number of old messages in mailbox.<br>


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 