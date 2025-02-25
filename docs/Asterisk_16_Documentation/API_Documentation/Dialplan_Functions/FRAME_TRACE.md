---
search:
  boost: 0.5
title: FRAME_TRACE
---

# FRAME_TRACE()

### Synopsis

View internal ast_frames as they are read and written on a channel.

### Description

Examples:<br>

``` title="Example: View only DTMF frames"

exten => 1,1,Set(FRAME_TRACE(white)=DTMF_BEGIN,DTMF_END)


```
``` title="Example: View only DTMF frames"

exten => 1,1,Set(FRAME_TRACE()=DTMF_BEGIN,DTMF_END)


```
``` title="Example: View everything except DTMF frames"

exten => 1,1,Set(FRAME_TRACE(black)=DTMF_BEGIN,DTMF_END)


```

### Syntax


```

FRAME_TRACE(filter list type)
```
##### Arguments


* `filter list type` - A filter can be applied to the trace to limit what frames are viewed. This filter can either be a 'white' or 'black' list of frame types. When no filter type is present, 'white' is used. If no arguments are provided at all, all frames will be output.<br>
Below are the different types of frames that can be filtered.<br>

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


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 