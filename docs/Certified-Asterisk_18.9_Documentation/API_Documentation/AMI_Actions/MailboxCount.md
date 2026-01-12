---
search:
  boost: 0.5
title: MailboxCount
---

# MailboxCount

### Synopsis

Check Mailbox Message Count.

### Description

Checks a voicemail account for new messages.<br>

Returns number of urgent, new and old messages.<br>

Message: Mailbox Message Count<br>

Mailbox: _mailboxid_<br>

UrgentMessages: _count_<br>

NewMessages: _count_<br>

OldMessages: _count_<br>


### Syntax


```


Action: MailboxCount
ActionID: <value>
Mailbox: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Mailbox` - Full mailbox ID _mailbox_@_vm-context_.<br>

### See Also

* [AMI Actions MailboxStatus](/Certified-Asterisk_18.9_Documentation/API_Documentation/AMI_Actions/MailboxStatus)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 