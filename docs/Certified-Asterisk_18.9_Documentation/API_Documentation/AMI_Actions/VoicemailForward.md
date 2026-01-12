---
search:
  boost: 0.5
title: VoicemailForward
---

# VoicemailForward

### Synopsis

Forward Voicemail from one mailbox folder to another between given users.

### Description

Forward a given Voicemail from a user's Mailbox Folder to another user's Mailbox Folder. Can be used to copy between Folders within a mailbox by specifying the to context and user as the same as the from.<br>


### Syntax


```


Action: VoicemailForward
ActionID: <value>
Context: <value>
Mailbox: <value>
Folder: <value>
ID: <value>
ToContext: <value>
ToMailbox: <value>
ToFolder: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Context` - The context of the Voicemail you want to move.<br>

* `Mailbox` - The mailbox of the Voicemail you want to move.<br>

* `Folder` - The Folder containing the Voicemail you want to move.<br>

* `ID` - The ID of the Voicemail you want to move.<br>

* `ToContext` - The context you want to move the Voicemail to.<br>

* `ToMailbox` - The mailbox you want to move the Voicemail to.<br>

* `ToFolder` - The Folder you want to move the Voicemail to.<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 