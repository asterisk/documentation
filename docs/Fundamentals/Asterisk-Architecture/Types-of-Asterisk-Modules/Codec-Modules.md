---
title: Codec Modules
pageid: 4817491
---

CODEC modules have file names that look like **codec_xxxxx.so**, such as **codec_alaw.so** and **codec_ulaw.so**.

CODECs represent mathematical algorithms for encoding (compressing) and decoding (decompression) media streams. Asterisk uses CODEC modules to both send and recieve media (audio and video). Asterisk also uses CODEC modules to convert (or transcode) media streams between different formats.

Modules Provided by Default
===========================

Asterisk is provided with CODEC modules for the following media types:

* ADPCM, 32kbit/s
* G.711 A-law, 64kbit/s
* G.711 µ-law, 64kbit/s
* G.722, 64kbit/s
* G.726, 32kbit/s
* GSM, 13kbit/s
* LPC-10, 2.4kbit/s

Other Formats and Modules
=========================

The Asterisk core provides capability for 16 bit Signed Linear PCM, which is what all of the CODECs are encoding from or decoding to. There is another CODEC module, **codec_resample** which allows re-sampling of Signed Linear into different sampling rates 12,16,24,32,44,48,96 or 192 kHz to aid translation.

Various other CODEC modules will be built and installed if their dependencies are detected during Asterisk compilation.

* If the [DAHDI](/Getting-Started/Installing-Asterisk/Installing-Asterisk-From-Source/Building-and-Installing-DAHDI) drivers are detected then **codec_dahdi** will installed.
* If the Speex ([www.speex.org](http://www.speex.org)) development libraries are detected, **codec_speex** will also be installed.
* If the iLBC ([www.ilbcfreeware.org](http://www.ilbcfreeware.org/)) development libraries are detected, **codec_ilbc** will also be installed.

Support for the patent-encumbered G.729A or G.723.1 CODECs is provided by Digium on a commercial basis through software (G.729A) or hardware (G.729A and G.723.1) products. For more information about purchasing licenses or hardware to use the G.729A or G.723.1 CODECs with Asterisk, please see Digium's website.

Support for Polycom's patent-encumbered but free G.722.1 Siren7 and G.722.1C Siren14 CODECs, or for Skype's SILK CODEC, can be enabled in Asterisk by [downloading the binary CODEC modules](http://downloads.digium.com/pub/telephony/) from Digium's website.




!!! tip 
    On the Asterisk Command Line Interface, use the command "core show translation" to show the translation times between all registered audio formats.

      
[//]: # (end-tip)



