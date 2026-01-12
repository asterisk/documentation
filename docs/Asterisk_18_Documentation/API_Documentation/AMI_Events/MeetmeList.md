---
search:
  boost: 0.5
title: MeetmeList
---

# MeetmeList

### Synopsis

Raised in response to a MeetmeList command.

### Syntax


```


Event: MeetmeList
Conference: <value>
UserNumber: <value>
CallerIDNum: <value>
CallerIDName: <value>
ConnectedLineNum: <value>
ConnectedLineName: <value>
Channel: <value>
Admin: <value>
Role: <value>
MarkedUser: <value>
Muted: <value>
Talking: <value>

```
##### Arguments


* `Conference` - Conference ID.<br>

* `UserNumber` - User ID.<br>

* `CallerIDNum` - Caller ID number.<br>

* `CallerIDName` - Caller ID name.<br>

* `ConnectedLineNum` - Connected Line number.<br>

* `ConnectedLineName` - Connected Line name.<br>

* `Channel` - Channel name<br>

* `Admin` - Whether or not the user is an admin.<br>

* `Role` - User role. Can be "Listen only", "Talk only", or "Talk and listen".<br>

* `MarkedUser` - Whether or not the user is a marked user.<br>

* `Muted` - Whether or not the user is currently muted.<br>

* `Talking` - Whether or not the user is currently talking.<br>

### Class

CALL
### See Also

* [AMI Actions MeetmeList](/Asterisk_18_Documentation/API_Documentation/AMI_Actions/MeetmeList)
* [Dialplan Applications MeetMe](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/MeetMe)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 