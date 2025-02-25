---
search:
  boost: 0.5
title: MWIUpdate
---

# MWIUpdate

### Synopsis

Update the mailbox message counts.

### Description

Update the mailbox message counts.<br>


### Syntax


```


    Action: MWIUpdate
    ActionID: <value>
    Mailbox: <value>
    OldMessages: <value>
    NewMessages: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Mailbox` - Specific mailbox ID.<br>

* `OldMessages` - The number of old messages in the mailbox. Defaults to zero if missing.<br>

* `NewMessages` - The number of new messages in the mailbox. Defaults to zero if missing.<br>


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 