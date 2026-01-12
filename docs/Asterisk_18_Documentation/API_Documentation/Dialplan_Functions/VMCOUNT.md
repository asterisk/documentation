---
search:
  boost: 0.5
title: VMCOUNT
---

# VMCOUNT()

### Synopsis

Count the voicemails in a specified mailbox or mailboxes.

### Description

Count the number of voicemails in a specified mailbox, you could also specify the mailbox _folder_.<br>

``` title="Example: Mailbox folder count"

exten => s,1,Set(foo=${VMCOUNT(125@default)})


```
An ampersand-separated list of mailboxes may be specified to count voicemails in multiple mailboxes. If a folder is specified, this will apply to all mailboxes specified.<br>

``` title="Example: Multiple mailbox inbox count"

same => n,NoOp(${VMCOUNT(1234@default&1235@default&1236@default,INBOX)})


```

### Syntax


```

VMCOUNT(vmbox[,folder])
```
##### Arguments


* `vmbox` - A mailbox or list of mailboxes<br>

* `folder` - If not specified, defaults to 'INBOX'<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 