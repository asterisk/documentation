---
search:
  boost: 0.5
title: VoiceMailPlayMsg
---

# VoiceMailPlayMsg()

### Synopsis

Play a single voice mail msg from a mailbox by msg id.

### Description

This application sets the following channel variable upon completion:<br>


* `VOICEMAIL_PLAYBACKSTATUS` - The status of the playback attempt as a text string.<br>

    * `SUCCESS`

    * `FAILED`

### Syntax


```

VoiceMailPlayMsg([mailbox@[context]],msg_id)
```
##### Arguments


* `mailbox`

    * `mailbox`

    * `context`

* `msg_id` - The msg id of the msg to play back.<br>


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 