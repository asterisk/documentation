---
search:
  boost: 0.5
title: VM_INFO
---

# VM_INFO()

### Synopsis

Returns the selected attribute from a mailbox.

### Description

Returns the selected attribute from the specified _mailbox_. If _context_ is not specified, defaults to the 'default' context. Where the _folder_ can be specified, common folders include 'INBOX', 'Old', 'Work', 'Family' and 'Friends'.<br>


### Syntax


```

VM_INFO(mailbox,attribute[,folder])
```
##### Arguments


* `mailbox`

    * `mailbox` **required**

    * `context`

* `attribute`

    * `count` - Count of messages in specified _folder_. If _folder_ is not specified, defaults to 'INBOX'.<br>


    * `email` - E-mail address associated with the mailbox.<br>


    * `exists` - Returns a boolean of whether the corresponding _mailbox_ exists.<br>


    * `fullname` - Full name associated with the mailbox.<br>


    * `language` - Mailbox language if overridden, otherwise the language of the channel.<br>


    * `locale` - Mailbox locale if overridden, otherwise global locale.<br>


    * `pager` - Pager e-mail address associated with the mailbox.<br>


    * `password` - Mailbox access password.<br>


    * `tz` - Mailbox timezone if overridden, otherwise global timezone<br>


* `folder` - If not specified, 'INBOX' is assumed.<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 