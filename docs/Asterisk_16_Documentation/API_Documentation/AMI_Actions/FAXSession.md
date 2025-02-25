---
search:
  boost: 0.5
title: FAXSession
---

# FAXSession

### Synopsis

Responds with a detailed description of a single FAX session

### Description

Provides details about a specific FAX session. The response will include a common subset of the output from the CLI command 'fax show session <session\_number>' for each technology. If the FAX technolgy used by this session does not include a handler for FAXSession, then this action will fail.<br>


### Syntax


```


    Action: FAXSession
    ActionID: <value>
    SessionNumber: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `SessionNumber` - The session ID of the fax the user is interested in.<br>


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 