---
search:
  boost: 0.5
title: Events
---

# Events

### Synopsis

Control Event Flow.

### Description

Enable/Disable sending of events to this manager client.<br>


### Syntax


```


Action: Events
ActionID: <value>
EventMask: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `EventMask`

    * `on` - If all events should be sent.<br>

    * `off` - If no events should be sent.<br>

    * `system,call,log,...` - To select which flags events should have to be sent.<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 