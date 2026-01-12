---
search:
  boost: 0.5
title: WaitEvent
---

# WaitEvent

### Synopsis

Wait for an event to occur.

### Description

This action will elicit a 'Success' response. Whenever a manager event is queued. Once WaitEvent has been called on an HTTP manager session, events will be generated and queued.<br>


### Syntax


```


Action: WaitEvent
ActionID: <value>
Timeout: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Timeout` - Maximum time (in seconds) to wait for events, '-1' means forever.<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 