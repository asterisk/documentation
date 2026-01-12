---
search:
  boost: 0.5
title: ConfbridgeListRooms
---

# ConfbridgeListRooms

### Synopsis

Raised as part of the ConfbridgeListRooms action response list.

### Syntax


```


Event: ConfbridgeListRooms
Conference: <value>
Parties: <value>
Marked: <value>
Locked: <value>
Muted: <value>

```
##### Arguments


* `Conference` - The name of the Confbridge conference.<br>

* `Parties` - Number of users in the conference.<br>
This includes both active and waiting users.<br>

* `Marked` - Number of marked users in the conference.<br>

* `Locked` - Is the conference locked?<br>

    * `Yes`

    * `No`

* `Muted` - Is the conference muted?<br>

    * `Yes`

    * `No`

### Class

REPORTING

### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 