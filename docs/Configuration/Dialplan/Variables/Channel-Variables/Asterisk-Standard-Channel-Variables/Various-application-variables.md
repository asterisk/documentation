---
title: Various application variables
pageid: 4620405
---

* `${CURL`} - Resulting page content for `CURL()`
* `${ENUM`} - Result of application `EnumLookup()`
* `${EXITCONTEXT`} - Context to exit to in IVR menu (`Background()`) or in the `RetryDial()` application
* `${MONITOR`} - Set to "TRUE" if the channel is/has been monitored (app monitor())
* `${MONITOR_EXEC`} - Application to execute after monitoring a call
* `${MONITOR_EXEC_ARGS`} - Arguments to application
* `${MONITOR_FILENAME`} - File for monitoring (recording) calls in queue
* `${QUEUE_PRIO`} - Queue priority
* `${QUEUE_MAX_PENALTY`} - Maximum member penalty allowed to answer caller
* `${QUEUE_MIN_PENALTY`} - Minimum member penalty allowed to answer caller
* `${QUEUESTATUS`} - Status of the call, one of: (TIMEOUT | FULL | JOINEMPTY | LEAVEEMPTY | JOINUNAVAIL | LEAVEUNAVAIL)
* `${QUEUEPOSITION`} - When a caller is removed from a queue, his current position is logged in this variable. If the value is 0, then this means that the caller was serviced by a queue member. If non-zero, then this was the position in the queue the caller was in when he left.
* `${RECORDED_FILE`} - Recorded file in record()
* `${TALK_DETECTED`} - Result from talkdetect()
* `${TOUCH_MONITOR`} - The filename base to use with Touch Monitor (auto record)
* `${TOUCH_MONITOR_PREF`} - The prefix for automonitor recording filenames.
* `${TOUCH_MONITOR_FORMAT`} - The audio format to use with Touch Monitor (auto record)
* `${TOUCH_MONITOR_OUTPUT`} - Recorded file from Touch Monitor (auto record)
* `${TOUCH_MONITOR_MESSAGE_START`} - Recorded file to play for both channels at start of monitoring session
* `${TOUCH_MONITOR_MESSAGE_STOP`} - Recorded file to play for both channels at end of monitoring session
* `${TOUCH_MIXMONITOR`} - The filename base to use with Touch MixMonitor (auto record)
* `${TOUCH_MIXMONITOR_FORMAT`} - The audio format to use with Touch MixMonitor (auto record)
* `${TOUCH_MIXMONITOR_OUTPUT`} - Recorded file from Touch MixMonitor (auto record)
* `${TXTCIDNAME`} - Result of application TXTCIDName
* `${VPB_GETDTMF`} - chan_vpb
