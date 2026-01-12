---
search:
  boost: 0.5
title: FAXSessions
---

# FAXSessions

### Synopsis

Lists active FAX sessions

### Description

Will generate a series of FAXSession events with information about each FAXSession. Closes with a FAXSessionsComplete event which includes a count of the included FAX sessions. This action works in the same manner as the CLI command 'fax show sessions'<br>


### Syntax


```


Action: FAXSessions
ActionID: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 