---
search:
  boost: 0.5
title: FRAME_DROP
---

# FRAME_DROP()

### Synopsis

Drops specific frame types in the TX or RX direction on a channel.

### Description

Examples:<br>

exten => 1,1,Set(FRAME\_DROP(TX)=DTMF\_BEGIN,DTMF\_END); drop only DTMF frames towards this channel.<br>

exten => 1,1,Set(FRAME\_DROP(TX)=ANSWER); drop only ANSWER CONTROL frames towards this channel.<br>

exten => 1,1,Set(FRAME\_DROP(RX)=DTMF\_BEGIN,DTMF\_END); drop only DTMF frames received on this channel.<br>


### Syntax


```

FRAME_DROP(direction)
```
##### Arguments


* `direction` - List of frame types to be dropped for the specified direction. Direction can be 'TX' or 'RX'. The 'TX' direction will prevent Asterisk from sending frames to a channel, and the 'RX' direction will prevent Asterisk from receiving frames from a channel.<br>
Subsequent calls to this function will replace previous settings, allowing certain frames to be dropped only temporarily, for instance.<br>
Below are the different types of frames that can be dropped. Other actions may need to be taken in conjunction with use of this function: for instance, if you drop ANSWER control frames, you should explicitly use 'Progress()' for your call or undesired behavior may occur.<br>

    * `DTMF_BEGIN`

    * `DTMF_END`

    * `VOICE`

    * `VIDEO`

    * `CONTROL`

    * `NULL`

    * `IAX`

    * `TEXT`

    * `TEXT_DATA`

    * `IMAGE`

    * `HTML`

    * `CNG`

    * `MODEM`
The following CONTROL frames can also be dropped:<br>

    * `RING`

    * `RINGING`

    * `ANSWER`

    * `BUSY`

    * `TAKEOFFHOOK`

    * `OFFHOOK`

    * `CONGESTION`

    * `FLASH`

    * `WINK`

    * `PROGRESS`

    * `PROCEEDING`

    * `HOLD`

    * `UNHOLD`

    * `VIDUPDATE`

    * `CONNECTED_LINE`

    * `REDIRECTING`


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 