---
title: IMAP Server Implementations
pageid: 5242978
---

There are various IMAP server implementations, each supports a potentially different set of features.


##### UW IMAP-2005 or earlier


UIDPLUS is currently NOT supported on these versions of UW-IMAP. Please note that without UID_EXPUNGE, Asterisk voicemail will expunge ALL messages marked for deletion when a user exits the voicemail system (hangs up the phone).   

This version is **not recommended for Asterisk.**


##### UW IMAP-2006


This version supports UIDPLUS, which allows UID_EXPUNGE capabilities. This feature allow the system to expunge ONLY pertinent messages, instead of the default behavior, which is to expunge ALL messages marked for deletion when EXPUNGE is called. The IMAP storage mechanism is this version of Asterisk will check if the UID_EXPUNGE feature is supported by the server, and use it if possible.   

This version is **not recommended for Asterisk.**


##### UW IMAP-2007


This is the currently recommended version for use with Asterisk.


##### Cyrus IMAP


Cyrus IMAP server v2.3.3 has been tested using a hierarchy delimiter of '/'.

