---
title: Codec Opus
pageid: 36798693
---

Configuration Options
---------------------

The Opus codec for Asterisk exposes a few configuration options that allow adjustments to be made to the encoder. The following options can be used to define custom format types within the *codecs.conf* file. These custom format types can then be specified in the "allow" line of an endpoint.

 



| Option Name | Description | Default |
| --- | --- | --- |
| type | Must be of type "opus". | "" (empty string) |
| packet\_loss | Encoder's packet loss percentage. Can be any number between *0* and *100*, inclusive. A higher value results in more loss resistance. | 0 |
| complexity | Encoder's computational complexity. Can be any number between *0* and *10*, inclusive. Note, 10 equals the highest complexity. | 10 |
| signal | Encoder's signal type. Aids in mode selection on the encoder: Can be any of the following: *auto*, *voice*, *music*. | auto |
| application | Encoder's application type. Can be any of the following: *voip*, *audio*, *low\_delay*. | voip |
| max\_playback\_rate\* | Sets the "maxplaybackrate” format parameter on the SDP and also limits the bandwidth on the encoder. Any value between *8000* and *48000* (inclusive) is valid, however typically it should match one of the usual opus bandwidths. Below is a mapping of values to bandwidth:

|  |  |
| --- | --- |
| 8000 | Narrow Band |
| 8001 – 16000 | Medium Band |
| 16001 – 24000 | Wide Band |
| 24001 – 32000 | Super Wide Band |
| 32001 – 48000 | Full Band |

 | 48000 |
| max\_bandwidth | Sets an upper bandwidth bound on the encoder. Can be any of the following: narrow, medium, wide, super\_wide, full. | full |
| bitrate\* | Specify the maximum average bitrate (sdp parameter "maxaveragebitrate"). Any value between 500 and 512000 is valid. The following values are also allowed: *auto*, *max*. | auto |
| cbr\* | Sets the "cbr" (constant bit rate) format parameter on SDP. Also tells the encoder to use a constant bit rate. A value of *no (*0** or **false** also work) represents a variable bit rate whereas *yes* (*1* or *true* also work) represents a constant bit rate. | 0 |
| fec\* | Sets the "useinbandfec" format parameter on the SDP. If set, and applicable, the encoder will add in-band forward error correction data. A value of *no (*0** or **false** also work) represents disabled whereas *yes* (*1* or *true* also work) represents enabled. | 0 |
| dtx\* | Sets the "usedtx" format on the SDP. A value of *no (*0** or **false** also work) represents disabled whereas *yes* (*1* or *true* also work) represents enabled (usedtx). | 0 |

\*If the format parameter is set to its default it will not show up in the fmtp attribute line.

Examples
--------

Limit the maximum playback rate of any endpoint that allow "opus" and don't include any forward error correction.




---

  
  


```

[opus]
type=opus
max\_playback\_rate=8000 ; Limit the bandwidth on the encoder to narrow band
fec=no ; Do not include in-band forward error correction data

```



---


Limit endpoints that allow "myopus" to wide band and use a constant bit rate:




---

  
  


```

[myopus]
type=opus
bitrate=16000 ; Maximum encoded bit rate used
cbr=yes ; The encoder will use a constant bit rate

```



---


