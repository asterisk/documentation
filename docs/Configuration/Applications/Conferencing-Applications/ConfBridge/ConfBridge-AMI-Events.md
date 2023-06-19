---
title: ConfBridge AMI Events
pageid: 34014263
---

ConfbridgeStart
---------------

This event is sent when the first user requests a conference and it is instantiated

**Example**




---

  
  


```

Event: ConfbridgeStart
Privilege: call,all
Conference: 1111


```



---


On This PageConfbridgeJoin
--------------

This event is sent when a user joins a conference - either one already in progress or as the first user to join a newly instantiated bridge.

**Example**




---

  
  


```

Event: ConfbridgeJoin
Privilege: call,all
Channel: SIP/mypeer-00000001
Uniqueid: 1303309562.3
Conference: 1111
CallerIDnum: 1234
CallerIDname: mypeer


```



---


ConfbridgeLeave
---------------

This event is sent when a user leaves a conference.

**Example**




---

  
  


```

Event: ConfbridgeLeave
Privilege: call,all
Channel: SIP/mypeer-00000001
Uniqueid: 1303308745.0
Conference: 1111
CallerIDnum: 1234
CallerIDname: mypeer


```



---


ConfbridgeEnd
-------------

This event is sent when the last user leaves a conference and it is torn down.

**Example**




---

  
  


```

Event: ConfbridgeEnd
Privilege: call,all
Conference: 1111


```



---


ConfbridgeTalking
-----------------

This event is sent when the conference detects that a user has either begin or stopped talking.

**Start talking Example**




---

  
  


```

Event: ConfbridgeTalking
Privilege: call, all
Channel: SIP/mypeer-00000001
Uniqueid: 1303308745.0
Conference: 1111
TalkingStatus: on


```



---


**Stop talking Example**




---

  
  


```

Event: ConfbridgeTalking
Privilege: call, all
Channel: SIP/mypeer-00000001
Uniqueid: 1303308745.0
Conference: 1111
TalkingStatus: off


```



---


