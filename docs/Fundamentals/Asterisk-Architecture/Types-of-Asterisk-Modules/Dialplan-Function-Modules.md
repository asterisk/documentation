---
title: Dialplan Function Modules
pageid: 4817487
---

Dialplan functions are somewhat similar to dialplan applications, but instead of doing work on a particular channel or call, they simply retrieve or set a particular setting on a channel, or perform text manipulation. For example, a dialplan function might retrieve the Caller ID information from an incoming call, filter some text, or set a timeout for caller input.

For more information on dialplan functions, see [PBX Features](/PBX-Features).

All dialplan function modules have file names that looks like **func\_xxxxx.so**, such as **func\_callerid.so**, however applications and functions can also be provided by the core and other modules. Modules like res\_musiconhold and res\_xmpp provide applications related to their own functionality.

