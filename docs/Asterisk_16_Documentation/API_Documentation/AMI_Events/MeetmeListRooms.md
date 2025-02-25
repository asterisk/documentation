---
search:
  boost: 0.5
title: MeetmeListRooms
---

# MeetmeListRooms

### Synopsis

Raised in response to a MeetmeListRooms command.

### Syntax


```


    Event: MeetmeListRooms
    Conference: <value>
    Parties: <value>
    Marked: <value>
    Activity: <value>
    Creation: <value>
    Locked: <value>

```
##### Arguments


* `Conference` - Conference ID.<br>

* `Parties` - Number of parties in the conference.<br>

* `Marked` - Number of marked users in the conference.<br>

* `Activity` - Total duration of conference in HH:MM:SS format.<br>

* `Creation` - How the conference was created: "Dyanmic" or "Static".<br>

* `Locked` - Whether or not the conference is locked.<br>

### Class

CALL
### See Also

* [AMI Actions MeetmeListRooms](/Asterisk_16_Documentation/API_Documentation/AMI_Actions/MeetmeListRooms)
* [Dialplan Applications MeetMe](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/MeetMe)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 