---
search:
  boost: 0.5
title: PresenceStateList
---

# PresenceStateList

### Synopsis

List the current known presence states.

### Description

This will list out all known presence states in a sequence of _PresenceStateChange_ events. When finished, a _PresenceStateListComplete_ event will be emitted.<br>


### Syntax


```


Action: PresenceStateList
ActionID: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

### See Also

* [AMI Actions PresenceState](/Asterisk_18_Documentation/API_Documentation/AMI_Actions/PresenceState)
* [AMI Events PresenceStatus](/Asterisk_18_Documentation/API_Documentation/AMI_Events/PresenceStatus)
* [Dialplan Functions PRESENCE_STATE](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/PRESENCE_STATE)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 