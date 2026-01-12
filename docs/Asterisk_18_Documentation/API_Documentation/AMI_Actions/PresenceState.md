---
search:
  boost: 0.5
title: PresenceState
---

# PresenceState

### Synopsis

Check Presence State

### Description

Report the presence state for the given presence provider.<br>

Will return a 'Presence State' message. The response will include the presence state and, if set, a presence subtype and custom message.<br>


### Syntax


```


Action: PresenceState
ActionID: <value>
Provider: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Provider` - Presence Provider to check the state of<br>

### See Also

* [AMI Events PresenceStatus](/Asterisk_18_Documentation/API_Documentation/AMI_Events/PresenceStatus)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 