---
search:
  boost: 0.5
title: MWIGet
---

# MWIGet

### Synopsis

Get selected mailboxes with message counts.

### Description

Get a list of mailboxes with their message counts.<br>


### Syntax


```


Action: MWIGet
ActionID: <value>
Mailbox: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Mailbox` - Mailbox ID in the form of / _regex_/ for all mailboxes matching the regular expression. Otherwise it is for a specific mailbox.<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 