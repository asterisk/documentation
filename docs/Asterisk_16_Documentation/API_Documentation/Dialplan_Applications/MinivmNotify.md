---
search:
  boost: 0.5
title: MinivmNotify
---

# MinivmNotify()

### Synopsis

Notify voicemail owner about new messages.

### Description

This application is part of the Mini-Voicemail system, configured in minivm.conf.<br>

MiniVMnotify forwards messages about new voicemail to e-mail and pager. If there's no user account for that address, a temporary account will be used with default options (set in *minivm.conf*).<br>

If the channel variable **MVM\_COUNTER** is set, this will be used in the message file name and available in the template for the message.<br>

If no template is given, the default email template will be used to send email and default pager template to send paging message (if the user account is configured with a paging address.<br>


* `MVM_NOTIFY_STATUS` - This is the status of the notification attempt<br>

    * `SUCCESS`

    * `FAILED`

### Syntax


```

MinivmNotify(username@domain,[options])
```
##### Arguments


* `mailbox`

    * `username` **required** - Voicemail username<br>

    * `domain` **required** - Voicemail domain<br>

* `options`

    * `template` - E-mail template to use for voicemail notification<br>



### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 