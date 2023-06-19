---
title: ConfBridge AMI Actions
pageid: 34014261
---

ConfbridgeList
--------------

Lists all users in a particular ConfBridge conference. ConfbridgeList will follow as separate events, followed by a final event called ConfbridgeListComplete

**Example**




---

  
  


```

Action: ConfbridgeList
Conference: 1111

Response: Success
EventList: start
Message: Confbridge user list will follow

Event: ConfbridgeList
Conference: 1111
CallerIDNum: malcolm
CallerIDName: malcolm
Channel: SIP/malcolm-00000000
Admin: No
MarkedUser: No

Event: ConfbridgeListComplete
EventList: Complete
ListItems: 1


```



---


On This PageConfbridgeListRooms
-------------------

Lists data about all active conferences. ConfbridgeListRooms will follow as separate events, followed by a final event called ConfbridgeListRoomsComplete.

**Example**




---

  
  


```

Action: ConfbridgeListRooms

Response: Success
EventList: start
Message: Confbridge conferences will follow

Event: ConfbridgeListRooms
Conference: 1111
Parties: 1
Marked: 0
Locked: No

Event: ConfbridgeListRoomsComplete
EventList: Complete
ListItems: 1


```



---


ConfbridgeMute
--------------

Mutes a specified user in a specified conference.

**Example**




---

  
  


```

Action: ConfbridgeMute
Conference: 1111
Channel: SIP/mypeer-00000001

Response: Success
Message: User muted


```



---


ConfbridgeUnmute
----------------

Unmutes a specified user in a specified conference.

**Example**




---

  
  


```

Action: ConfbridgeUnmute
Conference: 1111
Channel: SIP/mypeer-00000001

Response: Success
Message: User unmuted


```



---


ConfbridgeKick
--------------

Removes a specified user from a specified conference.

**Example**




---

  
  


```

Action: ConfbridgeKick
Conference: 1111
Channel: SIP/mypeer-00000001

Response: Success
Message: User kicked


```



---


ConfbridgeLock
--------------

Locks a specified conference.

**Example**




---

  
  


```

Action: ConfbridgeLock
Conference: 1111

Response: Success
Message: Conference locked


```



---


ConfbridgeUnlock
----------------

Unlocks a specified conference.

**Example**




---

  
  


```

Action: ConfbridgeUnlock
Conference: 1111

Response: Success
Message: Conference unlocked


```



---


ConfbridgeStartRecord
---------------------

Starts recording a specified conference, with an optional filename. If recording is already in progress, an error will be returned. If RecordFile is not provided, the default record\_file as specified in the conferences Bridge Profile will be used. If record\_file is not specified, a file will automatically be generated in Asterisk's monitor directory.

**Example**




---

  
  


```

Action: ConfbridgeStartRecord
Conference: 1111

Response: Success
Message: Conference Recording Started.

Event: VarSet
Privilege: dialplan,all
Channel: ConfBridgeRecorder/conf-1111-uid-1653801660
Variable: MIXMONITOR\_FILENAME
Value: /var/spool/asterisk/monitor/confbridge-1111-1303309869.wav
Uniqueid: 1303309869.6


```



---


ConfbridgeStopRecord
--------------------

Stops recording a specified conference.

**Example**




---

  
  


```

Action: ConfbridgeStopRecord
Conference: 1111

Response: Success
Message: Conference Recording Stopped.

Event: Hangup
Privilege: call,all
Channel: ConfBridgeRecorder/conf-1111-uid-1653801660
Uniqueid: 1303309869.6
CallerIDNum: <unknown>
CallerIDName: <unknown>
Cause: 0
Cause-txt: Unknown


```



---


ConfbridgeSetSingleVideoSrc
---------------------------

This action sets a conference user as the single video source distributed to all other video-capable participants.

**Example**




---

  
  


```

Action: ConfbridgeSetSingleVideoSrc
Conference: 1111
Channel: SIP/mypeer-00000001

Response: Success
Message: Conference single video source set.


```



---


