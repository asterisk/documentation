---
title: Asterisk Audio and Video Capabilities
pageid: 33521737
---

Overview of Media Support
=========================

Asterisk supports a variety of audio and video media. Asterisk provides CODEC modules to facilitate encoding and decoding of audio streams. Additionally file format modules are provided to handle writing to and reading from the file-system.

The tables on this page describe what capabilities Asterisk supports and specific details for each format.

On This PageEnabling specific media support
===============================

There are three basic requirements for making use of specific audio or video media with Asterisk.

1. The Asterisk core must support the format or a module may be required to add the support.
2. Asterisk configuration must be modified appropriately.
3. The devices interfacing with Asterisk must support the format and be configured to use it.

Module compilation and loading
------------------------------

For audio or video capabilities that require a module - you should make sure that the module is built and installed on the system.

See the section on [Using Menuselect to Select Asterisk Options](/Using-Menuselect-to-Select-Asterisk-Options) if you need help figuring out how to get a module built and then section on [Configuring the Asterisk Module Loader](/Configuring-the-Asterisk-Module-Loader) to verify that a module gets loaded when Asterisk starts up.

Channel driver configuration
----------------------------

Audio or video capabilities for Asterisk are used on a per channel or per feature basis. To tell Asterisk what CODECs or formats to use in a particular scenario you may need to configure your channel driver, or modify configuration for the feature itself.

We'll provide two examples, but you should look at the documentation for the channel driver or feature to better understand how to configure media in that context.

### Configuring allowed media for a PJSIP endpoint




---

  
pjsip.conf  


```

[CATHY]
type=endpoint
context=from-internal
allow=!all,ulaw
auth=CATHY
aors=CATHY

```



---


We set the option "allow" to a string of values "!all,ulaw".

* The value "**!all**" means "Disallow all" and is identical to "disallow=all". This tells Asterisk to disallow all codecs except what we further define in the allow option.
* The value "**ulaw**" instructs Asterisk to allow ulaw audio during media negotiation for this endpoint.

See the section [Configuring res\_pjsip](/Configuring-res_pjsip) for more information on the PJSIP channel driver.

### Configuring app\_voicemail file formats for recordings




---

  
voicemail.conf  


```

 [general]
format=wav49,wav,gsm

```



---


In the general section of voicemail.conf you can set the formats used when writing [voicemail](/Voicemail)to the file-system. We set the option "format" to a string of file format names.

* The value "wav49" represents GSM in a WAV|wav49 container.
* The value "wav" represents SLIN in a wav container.
* The value "gsm" represents GSM in straight gsm format.

Endpoint device configuration
-----------------------------

Configuring your particular device is outside the scope of the Asterisk documentation.

Consult your devices user/admin manual to find out where you define codecs or media to be used.

For VoIP desk phones there are typically two places to look for media configuration.

1. The web GUI for the phone.
2. The provisioning files that are pulled down by the phones on your network.

Audio Support
=============

A variety of audio capabilities are supported by Asterisk.

 



| Name | Config Value | Capability:(P)assthrough | CODEC Module | Format Module | Distributed w/ Asterisk? | Commercial License |
| --- | --- | --- | --- | --- | --- | --- |
| ADPCM | adpcm | T | codec\_adpcm | format\_vox | YES | NO |
| G.711 A-law | alaw | T | codec\_alaw | format\_pcm | YES | NO |
| G.711 µ-law | ulaw | T | codec\_ulaw | format\_pcm | YES | NO |
| G.719 | g719 | P | n/a | format\_g719 | YES | NO |
| G.722 | g722 | T | codec\_g722 | format\_pcm | YES | NO |
| G.722.1 Siren7 | siren7 | T | codec\_siren7 | format\_siren7 | Codec(NO) Format(YES) | NO |
| G.722.1C Siren14 | siren14 | T | codec\_siren14 | format\_siren14 | Codec(NO) Format(YES) | NO |
| G.723.1 | g723 | T | codec\_g723 | format\_g723 | Codec(NO) Format(YES) | YES(hardware required) |
| G.726 | g726 | T | codec\_g726 | format\_g726 | YES | NO |
| G.726 AAL2 | g726aal2 | T | codec\_g726 | format\_g726 | YES | NO |
| G.729A | g729 | T | codec\_g729a | format\_g729 | Codec(NO) Format(YES) | YES |
| GSM | gsm | T | codec\_gsm | format\_gsm | YES | NO |
| ILBC | ilbc | T | codec\_ilbc | format\_ilbc | YES | NO |
| LPC-10 | lpc10 | T | codec\_lpc10 | n/a | YES | NO |
| SILK | silk | T | codec\_silk | n/a | Codec(NO) Format(YES) | NO |
| Speex | speex | T | codec\_speex | n/a | YES | NO |
| Signed Linear PCM | slin | T | codec\_resample | format\_sln | YES | NO |
| Ogg Vorbis | n/a | n/a | n/a | format\_ogg\_vorbis | Codec(NO) Format(YES) | NO |
| Opus | opus | T | codec\_opus | n/a | Codec(NO) Format(YES) | NO |
| wav (SLIN) | wav | T | n/a | format\_wav | YES | NO |
| WAV (GSM) | wav49 | T | n/a | format\_wav\_gsm | YES | NO |

Speex Support
-------------

Asterisk supports 8, 16, and 32kHz Speex. Use of the 32kHz Speex mode is, like the other modes, controlled in the respective channel driver's configuration file, e.g. chan\_sip's sip.conf or PJSIP's pjsip.conf.

Signed Linear PCM
-----------------

Asterisk can resample between several different sampling rates and can read/write raw 16-bit signed linear audio files from/to disk. The complete list of supported sampling rates and file format is found in the expansion link below:



| Sampling Rate | Asterisk File format |
| --- | --- |
| 8kHz | .sln |
| 12kHz | .sln12 |
| 16kHz | .sln16 |
| 24kHz | .sln24 |
| 32kHz | .sln32 |
| 44.1kHz | .sln44 |
| 48kHz | .sln48 |
| 96kHz | .sln96 |
| 192kHz | .sln192 |




---

**Tip:**  Users can create 16-bit Signed Linear files of varying sampling rates from WAV files using the sox command-line audio utility.




---

  
  


```

sox input.wav -t raw -b 16 -r 32000 output.sln
mv output.sln output.sln32  



---


In this example, an input WAV file has been converted to Signed Linear at a depth of 16-bits and at a rate of 32kHz. The resulting output.sln file is then renamed output.sln32 so that it can be processed correctly by Asterisk.


```




---


 

Video and Image Support
=======================

You'll notice the CODEC module column is missing. Video transcoding or image transcoding is not currently supported.



| Name | Config Value | Capability:(P)assthrough | Format Module | Distributed w/ Asterisk |
| --- | --- | --- | --- | --- |
| JPEG | jpeg | P | format\_jpeg | YES |
| H.261 | h261 | P | n/a | YES |
| H.263 | h263 | P | format\_h263 | YES |
| H.263+ | h263p | P | format\_h263 | YES |
| H.264 | h264 | P | format\_h264 | YES |
| VP8 | vp8 | P | n/a | YES |
| VP9 | vp9 | P | n/a | YES |

 

 

