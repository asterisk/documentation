---
search:
  boost: 0.5
title: MailboxExists
---

# MailboxExists()

### Synopsis

Check to see if Voicemail mailbox exists.

### Description


/// note
DEPRECATED. Use VM\_INFO(mailbox\[@context\],exists) instead.
///

Check to see if the specified _mailbox_ exists. If no voicemail _context_ is specified, the 'default' context will be used.<br>

This application will set the following channel variable upon completion:<br>


* `VMBOXEXISTSSTATUS` - This will contain the status of the execution of the MailboxExists application. Possible values include:<br>

    * `SUCCESS`

    * `FAILED`

### Syntax


```

MailboxExists(mailbox@[context],[options])
```
##### Arguments


* `mailbox`

    * `mailbox` **required**

    * `context`

* `options` - None options.<br>

### See Also

* [Dialplan Functions VM_INFO](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/VM_INFO)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 