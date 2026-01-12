---
search:
  boost: 0.5
title: MinivmRecord
---

# MinivmRecord()

### Synopsis

Receive Mini-Voicemail and forward via e-mail.

### Description

This application is part of the Mini-Voicemail system, configured in *minivm.conf*<br>

MiniVM records audio file in configured format and forwards message to e-mail and pager.<br>

If there's no user account for that address, a temporary account will be used with default options.<br>

The recorded file name and path will be stored in **MVM\_FILENAME** and the duration of the message will be stored in **MVM\_DURATION**<br>


/// note
If the caller hangs up after the recording, the only way to send the message and clean up is to execute in the 'h' extension. The application will exit if any of the following DTMF digits are received and the requested extension exist in the current context.
///


* `MVM_RECORD_STATUS` - This is the status of the record operation<br>

    * `SUCCESS`

    * `USEREXIT`

    * `FAILED`

### Syntax


```

MinivmRecord(username@domain,[options])
```
##### Arguments


* `mailbox`

    * `username` **required** - Voicemail username<br>

    * `domain` **required** - Voicemail domain<br>

* `options`

    * `0` - Jump to the 'o' extension in the current dialplan context.<br>


    * `*` - Jump to the 'a' extension in the current dialplan context.<br>


    * `g(gain)` - Use the specified amount of gain when recording the voicemail message. The units are whole-number decibels (dB).<br>

        * `gain` - Amount of gain to use<br>



### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 