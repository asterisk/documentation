---
title: Asterisk 12 Bridging Test Plan
pageid: 22088052
---

"Vanilla" bridging tests
========================


These tests have no particular features they are testing, but rather they act as a baseline test


Baseline bridge test
--------------------


* Party A calls Party B using a configuration that does not allow for native bridging
* Ensure that a native bridge does not occur when Party B answers
* Party A hangs up.


Repeat the test with Party B hanging up.


Native bridge test
------------------


* Party A calls Party B using a configuration that allows for native bridging
* Ensure that a native bridge occurs after Party B answers
* Party A hangs up.


Note for this test, it is outside the scope of the bridging layer to ensure that media passes once a native bridge is established. It is only important to ensure a native bridge is attempted.


Repeat the test with Party B hanging up.


Mid-call events.
----------------


These tests are designed to ensure that bridges react properly to specific mid-call events. All tests in this configuration will use non-native bridging configuration.


### Connected Line update


* Party A calls Party B. Party B answers.
* Party A sends a connected line update to Party B.
* Party B sends a connected line update to Party A.
* Party A hangs up.


### Redirecting update


* Party A calls Party B. Party B answers.
* Party A sends a redirecting update to Party B.
* Party B sends a redirecting update to Party A.
* Party A hangs up.


### Timed call


#### Announcements


* Party A calls Party B with the L(5000:3000:1000) dial option in use.
* Ensure that warnings start with 3 seconds left in the call.
* Ensure warning is repeated every second.
* Ensure call ends after 5 seconds.  

(Note the important aspect of the test is not the timing of the events but that they actually occur at all)


#### Call Termination


* Party A calls Party B with the S(5000) dial option in use.
* Ensure call ends after 5 seconds.


Two-party features tests
========================


These tests are designed to test specific features of bridges that involve two parties.


DTMF disconnect
---------------


### Test 1:


* Party A dials Party B with the 'H' Dial option set.
* Party B attempts to disconnect the call using the configured disconnect key (this should fail)
* Party A presses the configured disconnect key in order to end the call.


### Test 2:


* Party A sets the BRIDGE_FEATURES channel variable to 'H'.
* Party A dials party B.
* Party B attempts to disconnect the call using the configured disconnect key (this should fail)
* Party A presses the configured disconnect key in order to end the call.


### Test 3:


* Party A dials Party B with the 'h' Dial option set.
* Party A attempts to disconnect the call using the configured disconnect key (this should fail)
* Party B presses the configured disconnect key in order to end the call.


### Test 4:


* Party A sets the BRIDGE_FEATURES channel variable to 'h'.
* Party A dials party B.
* Party A attempts to disconnect the call using the configured disconnect key (this should fail)
* Party B presses the configured disconnect key in order to end the call.


Auto-Monitor and Auto-MixMonitor
--------------------------------


The following tests are written using the 'W' and 'w' options and the word "Auto-Monitor". The tests should be run a second time with the 'X' and 'x' options and with "Auto-MixMonitor" though. The important thing to test is that the feature is detected and that the task is farmed out appropriately. The tests are not interested in the actual call recording process.


### Test 1:


* Party A dials Party B with the 'W' Dial option set.
* Party B attempts to record the call using the configured Auto-Monitor key (this should fail)
* Party A presses the configured Auto-Monitor key to record the call
* Party B attempts to end the recording using the configured Auto-Monitor key (this should fail)
* Party A presses the configured Auto-Monitor key to end the call recording
* Either party hangs up


### Test 2:


* Party A sets the BRIDGE_FEATURES channel variable to 'W'
* Party A dials Party B
* Party B attempts to record the call using the configured Auto-Monitor key (this should fail)
* Party A presses the configured Auto-Monitor key to record the call
* Party B attempts to end the recording using the configured Auto-Monitor key (this should fail)
* Party A presses the configured Auto-Monitor key to end the call recording  

Either party hangs up  

(NOTE: This test currently does not apply to the 'X' option for Auto-MixMonitor)


### Test 3:


* Party A dials Party B with the 'w' Dial option set.
* Party A attempts to record the call using the configured Auto-Monitor key (this should fail)
* Party B presses the configured Auto-Monitor key to record the call
* Party A attempts to end the recording using the configured Auto-Monitor key (this should fail)
* Party B presses the configured Auto-Monitor key to end the call recording  

Either party hangs up


### Test 4:


* Party A sets the BRIDGE_FEATURES channel variable to 'w'
* Party A dials Party B
* Party A attempts to record the call using the configured Auto-Monitor key (this should fail)
* Party B presses the configured Auto-Monitor key to record the call
* Party A attempts to end the recording using the configured Auto-Monitor key (this should fail)
* Party B presses the configured Auto-Monitor key to end the call recording  

Either party hangs up  

(NOTE: This test currently does not apply to the 'x' option for Auto-MixMonitor)


One touch parking
-----------------


Like with previous tests for DTMF features, the focus of this test is that the DTMF is recognized and the task is farmed out to the appropriate handler. There will be many more call parking tests described later. These will focus on the results of parking much more closely than this test will. They will also focus on off-nominal scenarios such as attempting to park a caller in a full lot.


### Test 1:


* Party A dials Party B with the 'K' Dial option set.
* Party B attempts to park the call using the configured one touch parking key (this should fail)
* Party A presses the configured one touch parking key to park the call
* Party A hangs up


### Test 2:


* Party A sets the BRIDGE_FEATURES channel variable to 'K'
* Party A dials Party B
* Party B attempts to park the call using the configured one touch parking key (this should fail)
* Party A presses the configured one touch parking key to park the call
* Party A hangs up


### Test 3:


* Party A dials Party B with the 'k' Dial option set.
* Party A attempts to park the call using the configured one touch parking key (this should fail)
* Party B presses the configured one touch parking key to park the call
* Party B hangs up


### Test 4:


* Party A sets the BRIDGE_FEATURES channel variable to 'k'
* Party A dials Party B
* Party A attempts to park the call using the configured one touch parking key (this should fail)
* Party B presses the configured one touch parking key to park the call
* Party B hangs up


Transfer tests
--------------


These tests are designed to test call transfers. The initial tests will be much like the two-party DTMF feature tests above: they will simply test that DTMF is recognized and that the task gets distributed to the proper handler. Follow-up tests will focus more on the transfer operation to ensure that behavior is as expected.


When testing transfers, keep in mind that multiple bridges will be involved. Therefore, the standard bridge checks need to be performed for each bridge involved. Blind transfers should all check the BLINDTRANSFER channel variable.


### Test 1:


* Party A dials Party B with the 'T' Dial option set.
* Party B attempts to transfer the call with the configured blind transfer key (this should fail)
* Party B attempts to transfer the call with the configured attended transfer key (this should fail)
* Party A attempts to transfer the call with the configured blind transfer key
* Party A waits until the time to dial the transfer target times out
* Party A attempts to transfer the call with the configured attended transfer key
* Party A waits until the time to dial the transfer target times out  

Either party hangs up.


### Test 2:


* Party A sets the BRIDGE_FEATURES channel variable to 'T'
* Party A dials Party B
* Party B attempts to transfer the call with the configured blind transfer key (this should fail)
* Party B attempts to transfer the call with the configured attended transfer key (this should fail)
* Party A attempts to transfer the call with the configured blind transfer key
* Party A waits until the time to dial the transfer target times out
* Party A attempts to transfer the call with the configured attended transfer key
* Party A waits until the time to dial the transfer target times out  

Either party hangs up.


### Test 3:


* Party A dials Party B with the 't' Dial option set.
* Party A attempts to transfer the call with the configured blind transfer key (this should fail)
* Party A attempts to transfer the call with the configured attended transfer key (this should fail)
* Party B attempts to transfer the call with the configured blind transfer key
* Party B waits until the time to dial the transfer target times out
* Party B attempts to transfer the call with the configured attended transfer key
* Party B waits until the time to dial the transfer target times out  

Either party hangs up.


### Test 4:


* Party A sets the BRIDGE_FEATURES channel variable to 't'
* Party A dials Party B
* Party A attempts to transfer the call with the configured blind transfer key (this should fail)
* Party A attempts to transfer the call with the configured attended transfer key (this should fail)
* Party B attempts to transfer the call with the configured blind transfer key
* Party B waits until the time to dial the transfer target times out
* Party B attempts to transfer the call with the configured attended transfer key
* Party B waits until the time to dial the transfer target times out  

Either party hangs up.


### Test 5:


* Party A dials Party B with the 'T' Dial option set
* Party A attempts to transfer the call with the configured blind transfer key to Party C, Party C answers
* Party C hangs up.


### Test 6:


The same as test 5 except that it is an attended transfer


### Test 7:


The same as test 5 except that it is a blonde transfer


### Test 8:


* Party A dials Party B with the 't' Dial option set
* Party B attempts to transfer the call with the configured blind transfer key to Party C, Party C answers
* Party C hangs up.


### Test 9:


The same as test 8 except that it is an attended transfer


### Test 10:


The same as test 8 except that it is a blonde transfer


### Test 11:


* Party A dials Party B with the 'T' Dial option set
* Party A attempts to transfer the call with the configured blind transfer key to a non-existent dialplan extension
* Party A hangs up


### Test 12:


Same as test 11 except that it is an attended transfer


### Test 13:


* Party A dials Party B with the 't' Dial option set
* Party B attempts to transfer the call with the configured blind transfer key to a non-existent dialplan extension
* Party B hangs up


### Test 14:


Same as test 13 except that it is an attended transfer


### Test 15:


* Party A dials Party B with the 'T' Dial option set
* Party A attempts to transfer the call with the configured blind transfer key to Party C, who is busy


### Test 16:


* Party A dials Party B with the 'T' Dial option set
* Party A attempts to transfer the call with the configured attended transfer key to Party C, who is busy
* After parties A and B are re-bridged, Party A hangs up


### Test 17:


* Party A dials Party B with the 'T' Dial option set
* Party A attempts a blonde transfer of the call with the configured attended transfer key to Party C, who does not answer within a time limit
* Party A should be called back. Party A answers.
* Party A hangs up.  

(NOTE: This test appears to fail in current Asterisk trunk. A gets called back, but once he answers, the call is immediately dropped)


### Test 18:


* Party A dials Party B with the 'T' Dial option set
* Party A attempts a blonde transfer of the call with the configured attended transfer key to Party C, who does not answer within a time limit
* Party A should be called back. Party A does not answer.


### Test 19:


* Party A dials Party B with the 't' Dial option set
* Party B attempts to transfer the call with the configured blind transfer key to Party C, who is busy


### Test 20:


* Party A dials Party B with the 't' Dial option set
* Party B attempts to transfer the call with the configured attended transfer key to Party C, who is busy
* After parties A and B are re-bridged, Party B hangs up


### Test 21:


* Party A dials Party B with the 't' Dial option set
* Party B attempts a blonde transfer of the call with the configured attended transfer key to Party C, who does not answer within a time limit
* Party B should be called back. Party B answers.
* Party B hangs up.  

(NOTE: This test appears to fail in current Asterisk trunk. B gets called back, but once he answers, the call is immediately dropped)


### Test 22:


* Party A dials Party B with the 't' Dial option set
* Party B attempts a blonde transfer of the call with the configured attended transfer key to Party C, who does not answer within a time limit
* Party B should be called back. Party B does not answer.


Call Parking
============


Call parking has four main elements to test:


1. The act of parking the call
2. The effect of allowing a parked call to time out
3. The features allowed on a retrieved parked call
4. Parking the call


All of the following tests should be run three times.


1. In the first run, no parking lot is configured.
2. In the second, a specific pre-configured parking lot is chosen using the PARKINGLOT channel variable.
3. In the third, a dynamically-created parking lot is used.


Some tests do not apply for specific runs, and they will be noted.


In addition, each test should be run with the parties reversed.


Basic Call Parking
------------------


### Test 1:


* Party A dials Party B with the 'T' Dial option set
* Party A transfers Party B to the parking extension using the configured blind transfer key


### Test 2:


* Party A dials Party B with the 'T' Dial option set
* Party A transfers Party B to the parking extension using the configured attended transfer key


### Tests 3 and 4:


Tests 1 and 2 are re-run but the parking lot is full


### Tests 5 and 6:


Tests 1 and 2 are re-run but with no configured parking extension


Allowing the parked call to time out
------------------------------------


All tests start with the precondition that there is a parked party and that the parked call timeout has been reached.


All tests should make sure after the timeout that the PARKINGSLOT, PARKEDLOT, and PARKER variables are set properly.


### Test 1:


* comebacktoorigin is set to yes.
* Parker is called back.
* Parker answers the call.
* Parker hangs up.


### Test 2:


* comebacktoorigin is set to yes.
* comebackdialtime is set to 3 seconds.
* Parker is called back.
* Parker does not answer the call within the configured time.
* Ensure the call moves on to park-dial,t,1 extension


### Test 3:


* comebacktoorigin is set to yes.
* Parker is called back, but is busy.
* Ensure the call moves on to park-dial,h,1 extension


### Test 4:


* comebacktoorigin is set to no.
* comebackcontext is set to "park_context"
* Ensure that extension corresponding to parker's channel name is called back.
* Parker answers the call, then hangs up.


### Test 5:


* comebacktoorigin is set to no.
* comebackcontext is set to "park_context"
* Ensure that extension corresponding to parker's channel name is called back.
* Parker does not answer


### Test 6:


* comebacktoorigin is set to no.
* comebackcontext is set to "park_context"
* Ensure that extension corresponding to parker's channel name is called back.
* Parker is busy


### Test 7:


* comebacktoorigin is set to no.
* comebackcontext is set to "park_context"
* There is no extension corresponding to parker's channel name.
* Ensure that 's' extension is called.


### Test 8:


* comebacktoorigin is set to no.
* comebackcontext is set to "park_context"
* There is no extension corresponding to parker's channel name.
* There is no 's' extension
* Ensure parked call is hung up properly


Feature Aftr Call Parking Retrieval
-----------------------------------


These tests have the precondition that a caller is parked


### Test 1:


* With default options set, Party A retrieves the parked call.
* Parties A and B both attempt blind and attended transfers. They should not work.
* Parties A and B both attempt one-touch recording. They should not work.
* Parties A and B both attempt one-touch parking. They should not work.
* Parties A and B both attempt DTMF hangup. They should not work.


### Test 2:


* parkedcalltransfers is set to caller
* Party A retrieves parked call.
* Party B attempts to transfer the call with blind and attended transfer keys. They should not work.
* Party A transfers party B to party C.


### Test 3:


Re-run Test 2 with parkedcalltransfers set to callee and reverse parties' roles.


### Test 4:


* parkedcalltransfers is set to both
* Party A retrieves parked call
* Party A transfers party B to party C


### Test 5:


Same as Test 4 but Party B makes the transfer


### Tests 6-9:


Same as tests 2-5, but applicable to the parkedcallhangup setting.


### Tests 10-13:


Same as tests 2-5, but applicable to the parkedcallreparking setting.


Tests 14-17:  

Same as tests 2-5, but applicable to the parkedcallrecording setting.


### Tests 18-33:


Same as tests 2-17, but instead of using features.conf settings, have settings inherited from the original bridge by using the h, H, k, K, w, W, x, and X settings for Dial.

