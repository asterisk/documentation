---
title: ConfBridge CLI Commands
pageid: 34014257
---

ConfBridge CLI Commands
=======================

ConfBridge offers several commands that may be invoked from the Asterisk CLI.

confbridge kick <conference> <channel>
--------------------------------------

Removes the specified channel from the conference, e.g.:




---

  
  


```

\*CLI> confbridge kick 1111 SIP/mypeer-00000000
Kicking SIP/mypeer-00000000 from confbridge 1111


```


On This Pageconfbridge list
---------------

Shows a summary listing of all bridges, e.g.:




---

  
  


```

\*CLI> confbridge list
Conference Bridge Name Users Marked Locked?
================================ ====== ====== ========
1111 1 0 unlocked


```


confbridge list <conference>
----------------------------

Shows a detailed listing of participants in a specified conference, e.g.:




---

  
  


```

\*CLI> confbridge list 1111
Channel User Profile Bridge Profile Menu
============================= ================ ================ ================
SIP/mypeer-00000001 default_user 1111 sample_user_menu 


```


confbridge lock <conference>
----------------------------

Locks a specified conference so that only Admin users can join, e.g.:




---

  
  


```

\*CLI> confbridge lock 1111
Conference 1111 is locked.


```


confbridge unlock <conference>
------------------------------

Unlocks a specified conference so that only Admin users can join, e.g.:




---

  
  


```

\*CLI> confbridge unlock 1111
Conference 1111 is unlocked.


```


confbridge mute <conference> <channel>
--------------------------------------

Mutes a specified user in a specified conference, e.g.:




---

  
  


```

\*CLI> confbridge mute 1111 SIP/mypeer-00000001
Muting SIP/mypeer-00000001 from confbridge 1111


```


confbridge unmute <conference> <channel>
----------------------------------------

Unmutes a specified user in a specified conference, e.g.:




---

  
  


```

\*CLI> confbridge unmute 1111 SIP/mypeer-00000001
Unmuting SIP/mypeer-00000001 from confbridge 1111


```


confbridge record start <conference> <file>
-------------------------------------------

Begins recording a conference. If "file" is specified, it will be used, otherwise, the Bridge Profile record_file will be used. If the Bridge Profile does not specify a record_file, one will be automatically generated in Asterisk's monitor directory. Usage:




---

  
  


```

\*CLI> confbridge record start 1111
Recording started
\*CLI> == Begin MixMonitor Recording ConfBridgeRecorder/conf-1111-uid-618880445


```


confbridge record stop <confererence>
-------------------------------------

Stops recording the specified conference, e.g.:




---

  
  


```

\*CLI> confbridge record stop 1111
Recording stopped.
\*CLI> == MixMonitor close filestream (mixed)
 == End MixMonitor Recording ConfBridgeRecorder/conf-1111-uid-618880445


```


confbridge show menus
---------------------

Shows a listing of Conference Menus as defined in confbridge.conf, e.g.:




---

  
  


```

\*CLI> confbridge show menus
--------- Menus -----------
sample_admin_menu
sample_user_menu


```


confbridge show menu <menu name>
--------------------------------

Shows a detailed listing of a named Conference Menu, e.g.:




---

  
  


```

\*CLI> confbridge show menu sample_admin_menu
Name: sample_admin_menu
\*9=increase_talking_volume
\*8=no_op
\*7=decrease_talking_volume
\*6=increase_listening_volume
\*4=decrease_listening_volume
\*3=admin_kick_last
\*2=admin_toggle_conference_lock
\*1=toggle_mute
\*=playback_and_continue(conf-adminmenu)


```


confbridge show profile bridges
-------------------------------

Shows a listing of Bridge Profiles as defined in confbridge.conf, e.g.:




---

  
  


```

\*CLI> confbridge show profile bridges
--------- Bridge Profiles -----------
1111
default_bridge


```


confbridge show profile bridge <bridge>
---------------------------------------

Shows a detailed listing of a named Bridge Profile, e.g.:




---

  
  


```

\*CLI> confbridge show profile bridge 1111 
--------------------------------------------
Name: 1111
Internal Sample Rate: 16000
Mixing Interval: 10
Record Conference: no
Record File: Auto Generated
Max Members: No Limit
sound_only_person: conf-onlyperson
sound_has_joined: conf-hasjoin
sound_has_left: conf-hasleft
sound_kicked: conf-kicked
sound_muted: conf-muted
sound_unmuted: conf-unmuted
sound_there_are: conf-thereare
sound_other_in_party: conf-otherinparty
sound_place_into_conference: conf-placeintoconf
sound_wait_for_leader: conf-waitforleader
sound_get_pin: conf-getpin
sound_invalid_pin: conf-invalidpin
sound_locked: conf-locked
sound_unlocked_now: conf-unlockednow
sound_lockednow: conf-lockednow
sound_error_menu: conf-errormenu


```


confbridge show profile users
-----------------------------

Shows a listing of User Profiles as defined in confbridge.conf, e.g.:




---

  
  


```

\*CLI> confbridge show profile users
--------- User Profiles -----------
awesomeusers
default_user


```


confbirdge show profile user <user>
-----------------------------------

Shows a detailed listing of a named Bridge Profile, e.g.:




---

  
  


```

\*CLI> confbridge show profile user default_user 
--------------------------------------------
Name: default_user
Admin: false
Marked User: false
Start Muted: false
MOH When Empty: enabled
MOH Class: default
Quiet: disabled
Wait Marked: disabled
END Marked: disabled
Drop_silence: enabled
Silence Threshold: 2500ms
Talking Threshold: 160ms
Denoise: disabled
Talk Detect Events: disabled
DTMF Pass Through: disabled
PIN: None
Announce User Count: enabled
Announce join/leave: enabled
Announce User Count all: enabled


```


