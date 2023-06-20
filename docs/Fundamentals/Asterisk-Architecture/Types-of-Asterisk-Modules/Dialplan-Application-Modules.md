---
title: Dialplan Application Modules
pageid: 4817489
---

The application modules provide call functionality to the system. These applications are then scripted sequentially in the dialplan. For example, a call might come into Asterisk dialplan, which might use one application to answer the call, another to play back a sound prompt from disk, and a third application to allow the caller to leave voice mail in a particular mailbox.

For more information on dialplan applications, see [Applications](/Configuration/Applications).

All application modules have file names that looks like **app\_xxxxx.so**, such as **app\_voicemail.so**, however applications and functions can also be provided by the core and other modules. Modules like res\_musiconhold and res\_xmpp provide applications related to their own functionality.

