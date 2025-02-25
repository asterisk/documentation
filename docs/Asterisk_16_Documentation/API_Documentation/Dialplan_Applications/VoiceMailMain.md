---
search:
  boost: 0.5
title: VoiceMailMain
---

# VoiceMailMain()

### Synopsis

Check Voicemail messages.

### Description

This application allows the calling party to check voicemail messages. A specific _mailbox_, and optional corresponding _context_, may be specified. If a _mailbox_ is not provided, the calling party will be prompted to enter one. If a _context_ is not specified, the 'default' context will be used.<br>

The VoiceMailMain application will exit if the following DTMF digit is entered as Mailbox or Password, and the extension exists:<br>


* `*` - Jump to the 'a' extension in the current dialplan context.<br>

### Syntax


```

VoiceMailMain([mailbox@[context]],[options])
```
##### Arguments


* `mailbox`

    * `mailbox`

    * `context`

* `options`

    * `p` - Consider the _mailbox_ parameter as a prefix to the mailbox that is entered by the caller.<br>


    * `g(#)` - Use the specified amount of gain when recording a voicemail message. The units are whole-number decibels (dB).<br>

        * `#` **required**


    * `r` - "Read only". Prevent user from deleting any messages.<br>
This applies only to specific executions of VoiceMailMain, NOT the mailbox itself.<br>


    * `s` - Skip checking the passcode for the mailbox.<br>


    * `a(folder)` - Skip folder prompt and go directly to _folder_ specified. Defaults to 'INBOX' (or '0').<br>

        * `folder` **required**

        * `0` - INBOX<br>

        * `1` - Old<br>

        * `2` - Work<br>

        * `3` - Family<br>

        * `4` - Friends<br>

        * `5` - Cust1<br>

        * `6` - Cust2<br>

        * `7` - Cust3<br>

        * `8` - Cust4<br>

        * `9` - Cust5<br>


### See Also

* [Dialplan Applications VoiceMail](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/VoiceMail)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 