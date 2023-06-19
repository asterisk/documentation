---
title: Keepalives
pageid: 20185821
---

Been doing some mucking around with cisco phones. Things found out about keepalives documented here.


It appears the minimum keepalive is 10. Any setting below this reverts to the the device setting 10 seconds.


Keepalive timings seem to vary by device type (and probably firmware).




|  Device  |  F/Ware  |  Proto  |  1st KA  |  Behavior w/ no response  |
| --- | --- | --- | --- | --- |
|  7960  |  7.2(3.0)  |  6  |  15 Sec  |  KA, KA, KA, UNREG  |
|  7961  |  8.5.4(1.6  |  17  |  As set  |  KA, KA\*2, KA\*2, UNREG  |
|  7920  |  4.0-3-2  |  5  |  As set  |  KA, KA, KA, KA+Reset Conn  |


For example, with keepalive set to 20:


* the 7960 will UNREG in 75 sec (ka@15, ka@35, ka@55, unreg@75) (straight after registration); or
* the 7960 will UNREG in 80 sec (ka@20, ka@40, ka@60, unreg@80) (after 1 keepalive ack sent);
* the 7961 will UNREG in 120 sec (ka@20, ka@60, ka@100, unreg@120).


Other info:


* Devices appear to consider themselves still registered (with no indication provided to user) until the unregister/reset conn occurs.
* Devices generally do not respond to keepalives or reset their own timings (see below for exception)
* After unregister (but no reset obviously) keepalives are still sent, further, the device now responds to keepalives with a keepalive\_ack, but this doesn't affect the timing of their own keepalives.


chan\_skinny impact:


* need to revise keepalive timing with is currently set to unregister at 1.1 \* keepalive time


Testing wifi (7920 with keepalive set to 20), immediately after a keepalive:


* removed from range for 55 secs - at 58 secs 3 keepalives received, connection remains.
* removed from range for 65 secs - at about 80 secs, connection reset and device reloads.
* server set to ignore 2 keepalives - 3rd keepalive at just under 60secs, connection remains.
* server set to ignore 3 keepalives - 4th keepalive at just under 80secs, connection reset by device anyway.
* looks like timing should be about 3\*keepalive (ie 60secs), maybe 5\*keepalive for 7961 (v17?)


More on ignoring keepalives at the server (with the 7920) (table below)


* if keepalive is odd, the time used is rounded up to the next even number (ie 15 will result in 16 secs)
* the first keepalive is delayed by 1 sec if keepalive is less than 30, 15 secs if less than 120, else 105 secs
* these two lead to some funny numbers
* if set to 119, the first will be at 135 secs (119 rounded up + 15), and subsequent each 120 secs
* if set to 120, the first will be at 225 secs (120 not rounded + 105), and subsequent each 120 secs
* similarly if set to 29, the first will be 31 then 30, where if set to 30 the first will be 45 then 30
* only tested out to 600 secs (where the first is still delayed by 105 secs)
* device resets the connection 20 secs after the 3rd unreplied keepalive
* keepalives below 20 seem unreliable in that they do not reset the connection
* above 20secs and after the first keepalive, the device will reset at (TRUNC((KA+1)/2)\*2)\*3+20
* before the first keepalive, add 1 if KA<30, add 15 if KA<120, else add 105
* actually, about a second earlier. After the first missed KA, the next will be about a second early
* not valid for other devices




| Set  | First (s)  | Then (s)  | Packets (#)  | Reset (s)  |
| --- | --- | --- | --- | --- |
| 20  | 21  | 20  | 3  | 20  |
| 25  | 27  | 26  | 3  | 20  |
| 26  | 27  | 26  | 3  | 20  |
| 29  | 31  | 30  | 3  | 20  |
| 30  | 45  | 30  | 3  | 20  |
| 60  | 75  | 60  | 3  | 20  |
| 90  | 105  | 90  | 3  | 20  |
| 119  | 135  | 120  | 3  | 20  |
| 120  | 225  | 120  | 3  | 20  |
| 600  | 705  | 600  | 3  | 20  |


