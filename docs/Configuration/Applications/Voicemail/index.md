---
title: Overview
pageid: 5242963
---

The Asterisk voicemail module provides two key applications for dealing with voice mail.



The **[VoiceMail()](/latest_api/API_Documentation/Dialplan_Applications/VoiceMail)** application takes two parameters:

1. **Mailbox**
	* This parameter specifies the mailbox in which the voice mail message should be left. It should be a mailbox number and a voice mail context concatenated with an at-sign (**@**), like **6001@default**. (Voice mail boxes are divided out into various voice mail context, similar to the way that extensions are broken up into dialplan contexts.) If the voice mail context is omitted, it will default to the **default** voice mail context.
2. **Options**
	* One or more options for controlling the mailbox greetings. The most popular options include the u option to play the unavailable message, the **b** option to play the busy message, and the **s** option to skip the system-generated instructions.



The **[VoiceMailMain()](/latest_api/API_Documentation/Dialplan_Applications/VoiceMailMain)** application allows the owner of a voice mail box to retrieve their messages, as well as set mailbox options such as greetings and their PIN number. The **VoiceMailMain()** application takes two parameters:

1. **Mailbox** - This parameter specifies the mailbox to log into. It should be a mailbox number and a voice mail context, concatenated with an at-sign (@), like 6001@default. If the voice mail context is omitted, it will default to the default voice mail context. If the mailbox number is omitted, the system will prompt the caller for the mailbox number.
2. **Options** - One or more options for controlling the voicemail system. The most popular option is the s option, which skips asking for the PIN number






!!! warning Direct Access to Voicemail
    Please exercise extreme caution when using the s option! With this option set, anyone which has access to this extension can retrieve voicemail messages without entering the mailbox passcode.

      
[//]: # (end-warning)



