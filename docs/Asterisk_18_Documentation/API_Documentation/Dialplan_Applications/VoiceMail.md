---
search:
  boost: 0.5
title: VoiceMail
---

# VoiceMail()

### Synopsis

Leave a Voicemail message.

### Description

This application allows the calling party to leave a message for the specified list of mailboxes. When multiple mailboxes are specified, the greeting will be taken from the first mailbox specified. Dialplan execution will stop if the specified mailbox does not exist.<br>

The Voicemail application will exit if any of the following DTMF digits are received:<br>


* `0` - Jump to the 'o' extension in the current dialplan context.<br>

* `*` - Jump to the 'a' extension in the current dialplan context.<br>
This application will set the following channel variable upon completion:<br>


* `VMSTATUS` - This indicates the status of the execution of the VoiceMail application.<br>

    * `SUCCESS`

    * `USEREXIT`

    * `FAILED`

### Syntax


```

VoiceMail(mailbox1&[mailbox2[&...]],[options])
```
##### Arguments


* `mailboxs`

    * `mailbox1` **required**

        * `mailbox` **required**

        * `context`

    * `mailbox2[,mailbox2...]`

        * `mailbox` **required**

        * `context`

* `options`

    * `b` - Play the 'busy' greeting to the calling party.<br>


    * `d(c)` - Accept digits for a new extension in context _c_, if played during the greeting. Context defaults to the current context.<br>

        * `c`


    * `e` - Play greetings as early media -- only answer the channel just before accepting the voice message.<br>


    * `g(#)` - Use the specified amount of gain when recording the voicemail message. The units are whole-number decibels (dB). Only works on supported technologies, which is DAHDI only.<br>

        * `#` **required**


    * `s` - Skip the playback of instructions for leaving a message to the calling party.<br>


    * `S` - Skip the playback of instructions for leaving a message to the calling party, but only if a greeting has been recorded by the mailbox user.<br>


    * `t(x)` - Play a custom beep tone to the caller instead of the default one. If this option is used but no file is specified, the beep is suppressed.<br>

        * `x`


    * `u` - Play the 'unavailable' greeting.<br>


    * `U` - Mark message as 'URGENT'.<br>


    * `P` - Mark message as 'PRIORITY'.<br>


### See Also

* [Dialplan Applications VoiceMailMain](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/VoiceMailMain)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 