---
title: Dial Channel Variables
pageid: 4620432
---

* ${DIALEDPEERNAME}  - Dialed peer name
* ${DIALEDPEERNUMBER}  - Dialed peer number
* ${DIALEDTIME}  - Time for the call (seconds). Is only set if call was answered.
* ${ANSWEREDTIME}  - Time from answer to hangup (seconds)
* ${DIALSTATUS}  - Status of the call, one of: (CHANUNAVAIL | CONGESTION | BUSY | NOANSWER | ANSWER | CANCEL | DONTCALL | TORTURE)
* ${DYNAMIC\_FEATURES}  - The list of features (from the applicationmap section of features.conf) to activate during the call, with feature names separated by '#' characters
* ${LIMIT\_PLAYAUDIO\_CALLER} - Soundfile for call limits
* ${LIMIT\_PLAYAUDIO\_CALLEE} - Soundfile for call limits
* ${LIMIT\_WARNING\_FILE} - Soundfile for call limits
* ${LIMIT\_TIMEOUT\_FILE} - Soundfile for call limits
* ${LIMIT\_CONNECT\_FILE} - Soundfile for call limits
* ${OUTBOUND\_GROUP} - Default groups for peer channels (as in SetGroup) \* See "show application dial" for more information

### Variables present in Asterisk 16.4.0 and forward:

* ${RINGTIME} - Time in seconds between creation of the dialing channel and receiving the first RINGING signal
* ${RINGTIME\_MS} - Time in milliseconds between creation of the dialing channel and receiving the first RINGING signal
* ${PROGRESSTIME} - Time in seconds between creation of the dialing channel and receiving the first PROGRESS signal
* ${PROGRESSTIME\_MS} - Time in milliseconds between creation of the dialing channel and receiving the first PROGRESS signal
* ${DIALEDTIME\_MS} - Time for the call (milliseconds). Is only set if the call was answered.
* ${ANSWEREDTIME\_MS} - Time from answer to hangup (milliseconds)
