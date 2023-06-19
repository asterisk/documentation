---
title: Video Telephony
pageid: 4260087
---

Asterisk and Video telephony
============================


Asterisk supports video telephony in the core infrastructure. Internally, it's one audio stream and one video stream in the same call. Some channel drivers and applications has video support, but not all.


##### Codecs and formats


Asterisk supports the following video codecs and file formats. There's no video transcoding so you have to make sure that both ends support the same video format.




| Codec | Format | Notes |
| --- | --- | --- |
| H.263 | read/write |   |
| H.264 | read/write |   |
| H.261 | - | Passthrough only |


Note that the file produced by Asterisk video format drivers is in no generic video format. Gstreamer has support for producing these files and converting from various video files to Asterisk video+audio files.


Note that H.264 is not enabled by default. You need to add that in the channel configuration file.


##### Channel Driver Support




| Channel Driver | Module | Notes |
| --- | --- | --- |
| SIP | `chan_sip.so` | The SIP channel driver (chan\_sip.so) has support for video |
| IAX2 | `chan_iax2.so` | Supports video calls (over trunks too) |
| Local | `chan_local.so` | Forwards video calls as a proxy channel |
| Agent | `chan_agent.so` | Forwards video calls as a proxy channel |
| oss | `chan_oss.so` | Has support for video display/decoding, see video\_console.txt |


##### Applications


This is not yet a complete list. These dialplan applications are known to handle video:


* Voicemail - Video voicemail storage (does not attach video to e-mail)
* Record - Records audio and video files (give audio format as argument)
* Playback - Plays a video while being instructed to play audio
* Echo - Echos audio and video back to the user


There is a development group working on enhancing video support for Asterisk. 


If you want to participate, join the asterisk-video mailing list on <http://lists.digium.com>


Updates to this file are more than welcome!

