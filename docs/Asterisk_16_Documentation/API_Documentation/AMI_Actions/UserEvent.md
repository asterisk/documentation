---
search:
  boost: 0.5
title: UserEvent
---

# UserEvent

### Synopsis

Send an arbitrary event.

### Description

Send an event to manager sessions.<br>


### Syntax


```


    Action: UserEvent
    ActionID: <value>
    UserEvent: <value>
    Header1: <value>
    HeaderN: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `UserEvent` - Event string to send.<br>

* `Header1` - Content1.<br>

* `HeaderN` - ContentN.<br>

### See Also

* [AMI Events UserEvent](/Asterisk_16_Documentation/API_Documentation/AMI_Events/UserEvent)
* [Dialplan Applications UserEvent](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/UserEvent)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 