---
search:
  boost: 0.5
title: MeetmeList
---

# MeetmeList

### Synopsis

List participants in a conference.

### Description

Lists all users in a particular MeetMe conference. MeetmeList will follow as separate events, followed by a final event called MeetmeListComplete.<br>


### Syntax


```


    Action: MeetmeList
    ActionID: <value>
    [Conference:] <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Conference` - Conference number.<br>


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 