---
search:
  boost: 0.5
title: codec_opus
---

# codec_opus: Codec opus module for Asterisk

This configuration documentation is for functionality provided by codec_opus.

## Configuration File: codecs.conf

### [opus]: Codec opus module for Asterisk options

#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| [application](#application)| Custom| voip| false| Encoder's application type.| |
| [bitrate](#bitrate)| Custom| auto| false| Encoder's bit rate.| |
| [cbr](#cbr)| Boolean| no| false| Encoder's constant bit rate value.| |
| [complexity](#complexity)| Integer| 10| false| Encoder's computational complexity.| |
| [dtx](#dtx)| Boolean| no| false| Encoder's discontinuous transmission value.| |
| [fec](#fec)| Boolean| yes| false| Encoder's forward error correction value.| |
| [max_bandwidth](#max_bandwidth)| Custom| full| false| Encoder's maximum bandwidth allowed.| |
| [max_playback_rate](#max_playback_rate)| Custom| 48000| false| Encoder's maximum playback rate.| |
| [packet_loss](#packet_loss)| Integer| 0| false| Encoder's packet loss percentage.| |
| [signal](#signal)| Custom| auto| false| Encoder's signal type.| |
| type| None| | false| Must be of type 'opus'.| |


#### Configuration Option Descriptions

##### application


* `voip`

* `audio`

* `low_delay`

##### bitrate

Can be any number between 500 and 512000 as well as one of the following opus values:<br>


* `auto`

* `max`

##### cbr

True/False value where 0/false/no represents a variable bit rate and 1/true/yes is constant bit rate.<br>


##### complexity

Can be any number between 0 and 10, inclusive. Note, 10 equals the highest complexity.<br>


##### dtx

True/False value where 0/false/no represents disabled and 1/true/yes is enabled.<br>


##### fec

True/False value where 0/false/no represents disabled and 1/true/yes is enabled.<br>


##### max_bandwidth

Sets an upper bandwidth bound on the encoder. Can be any of the following:<br>


* `narrow`

* `medium`

* `wide`

* `super_wide`

* `full`

##### max_playback_rate

Any value between 8000 and 48000, inclusive. Although typically it should match one of the usual Opus bandwidths.<br>


##### packet_loss

Can be any number between 0 and 100 (inclusive). Higher values result in a loss resistant behavior, however this has a cost on the quality (dependent upon a given bitrate).<br>


##### signal

Aids in mode selection on the encoder:<br>


* `auto`

* `voice`

* `music`


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 