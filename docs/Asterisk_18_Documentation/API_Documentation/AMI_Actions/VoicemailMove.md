---
search:
  boost: 0.5
title: VoicemailMove
---

# VoicemailMove

### Synopsis

Move Voicemail between mailbox folders of given user.

### Description

Move a given Voicemail between Folders within a user's Mailbox.<br>


### Syntax


```


Action: VoicemailMove
ActionID: <value>
Context: <value>
Mailbox: <value>
Folder: <value>
ID: <value>
ToFolder: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Context` - The context of the Voicemail you want to move.<br>

* `Mailbox` - The mailbox of the Voicemail you want to move.<br>

* `Folder` - The Folder containing the Voicemail you want to move.<br>

* `ID` - The ID of the Voicemail you want to move.<br>

* `ToFolder` - The Folder you want to move the Voicemail to.<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 