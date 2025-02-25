---
search:
  boost: 0.5
title: MailboxStatus
---

# MailboxStatus

### Synopsis

Check mailbox.

### Description

Checks a voicemail account for status.<br>

Returns whether there are messages waiting.<br>

Message: Mailbox Status.<br>

Mailbox: _mailboxid_.<br>

Waiting: '0' if messages waiting, '1' if no messages waiting.<br>


### Syntax


```


    Action: MailboxStatus
    ActionID: <value>
    Mailbox: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Mailbox` - Full mailbox ID _mailbox_@_vm-context_.<br>

### See Also

* [AMI Actions MailboxCount](/Asterisk_16_Documentation/API_Documentation/AMI_Actions/MailboxCount)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 