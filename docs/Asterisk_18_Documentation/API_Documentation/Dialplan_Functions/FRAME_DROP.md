---
search:
  boost: 0.5
title: FRAME_DROP
---

# FRAME_DROP()

### Synopsis

Drops specific frame types in the TX or RX direction on a channel.

### Since

16.21.0, 18.7.0, 19.0.0

### Description

Examples:<br>

``` title="Example: Drop only DTMF frames towards this channel"

exten => 1,1,Set(FRAME_DROP(TX)=DTMF_BEGIN,DTMF_END)


```
``` title="Example: Drop only Answer control frames towards this channel"

exten => 1,1,Set(FRAME_DROP(TX)=ANSWER)


```
``` title="Example: Drop only DTMF frames received on this channel"

exten => 1,1,Set(FRAME_DROP(RX)=DTMF_BEGIN,DTMF_END)


```

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

This documentation was generated from Asterisk branch 18 using version GIT 