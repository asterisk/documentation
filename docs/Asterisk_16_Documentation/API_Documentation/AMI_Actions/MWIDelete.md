---
search:
  boost: 0.5
title: MWIDelete
---

# MWIDelete

### Synopsis

Delete selected mailboxes.

### Description

Delete the specified mailboxes.<br>


### Syntax


```


    Action: MWIDelete
    ActionID: <value>
    Mailbox: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Mailbox` - Mailbox ID in the form of / _regex_/ for all mailboxes matching the regular expression. Otherwise it is for a specific mailbox.<br>


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 