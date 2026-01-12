---
search:
  boost: 0.5
title: VMAuthenticate
---

# VMAuthenticate()

### Synopsis

Authenticate with Voicemail passwords.

### Description

This application behaves the same way as the Authenticate application, but the passwords are taken from *voicemail.conf*. If the _mailbox_ is specified, only that mailbox's password will be considered valid. If the _mailbox_ is not specified, the channel variable **AUTH\_MAILBOX** will be set with the authenticated mailbox.<br>

The VMAuthenticate application will exit if the following DTMF digit is entered as Mailbox or Password, and the extension exists:<br>


* `*` - Jump to the 'a' extension in the current dialplan context.<br>

### Syntax


```

VMAuthenticate([mailbox@[context]],[options])
```
##### Arguments


* `mailbox`

    * `mailbox`

    * `context`

* `options`

    * `s` - Skip playing the initial prompts.<br>



### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 