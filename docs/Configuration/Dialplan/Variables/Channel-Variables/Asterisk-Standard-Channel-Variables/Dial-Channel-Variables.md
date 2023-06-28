---
title: Dial Channel Variables
pageid: 4620432
---

* ${DIALEDPEERNAME}  - Dialed peer name
* ${DIALEDPEERNUMBER}  - Dialed peer number
* ${DIALEDTIME}  - Time for the call (seconds). Is only set if call was answered.
* ${ANSWEREDTIME}  - Time from answer to hangup (seconds)
* ${DIALSTATUS}  - Status of the call, one of: (CHANUNAVAIL | CONGESTION | BUSY | NOANSWER | ANSWER | CANCEL | DONTCALL | TORTURE)
* ${DYNAMIC_FEATURES}  - The list of features (from the [applicationmap](/applicationmap) section of features.conf) to activate during the call, with feature names separated by '#' characters
* ${LIMIT_PLAYAUDIO_CALLER} - Soundfile for call limits
* ${LIMIT_PLAYAUDIO_CALLEE} - Soundfile for call limits
* ${LIMIT_WARNING_FILE} - Soundfile for call limits
* ${LIMIT_TIMEOUT_FILE} - Soundfile for call limits
* ${LIMIT_CONNECT_FILE} - Soundfile for call limits
* ${OUTBOUND_GROUP} - Default groups for peer channels (as in SetGroup) \* See "show application dial" for more information

### Variables present in Asterisk 16.4.0 and forward:

* ${RINGTIME} - Time in seconds between creation of the dialing channel and receiving the first RINGING signal
* ${RINGTIME_MS} - Time in milliseconds between creation of the dialing channel and receiving the first RINGING signal
* ${PROGRESSTIME} - Time in seconds between creation of the dialing channel and receiving the first PROGRESS signal
* ${PROGRESSTIME_MS} - Time in milliseconds between creation of the dialing channel and receiving the first PROGRESS signal
* ${DIALEDTIME_MS} - Time for the call (milliseconds). Is only set if the call was answered.
* ${ANSWEREDTIME_MS} - Time from answer to hangup (milliseconds)
