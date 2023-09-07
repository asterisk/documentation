---
title: Asterisk 10 Codecs and Audio Formats
---

Overview
--------


As a part of the  project for Asterisk 10, changes have been made to Asterisk to increase the number of codecs it's capable of supporting, to handle codecs with custom formats, and to support audio sampling rates greater than 16kHz. This has resulted in several practical changes to Asterisk that will benefit its users.


SIP Only
Note that the additional codecs discussed here are available for use in Asterisk's SIP channel driver, only. Asterisk 10 does not make them available for IAX2, MGCP, SSCP, H.323, UniSTIM, etc.


#### Expanded Signed Linear Support


Versions of Asterisk prior to 10 supported 16-bit Signed Linear sampled at 8kHz and at 16kHz (versions 1.6.0 - 1.8). New to Asterisk 10 is support for a much wider range of sampling rates. Asterisk can resample between any of these sampling rates and can read/write raw 16-bit signed linear audio files from/to disk. The complete list of supported sampling rates and file format extensions is:




| Sampling Rate  | Asterisk File format |
| --- | --- |
|  8kHz  |  .sln  |
|  12kHz  |  .sln12  |
|  16kHz  |  .sln16  |
|  24kHz  |  .sln24  |
|  32kHz  |  .sln32  |
|  44.1kHz  |  .sln44  |
|  48kHz  |  .sln48  |
|  96kHz  |  .sln96  |
|  192kHz  |  .sln192  |


Asterisk 10 removes the format\_sln16 file format in favor of expanded support in the main format\_sln file format for all sampling rates. So, users who notice the absence of format\_sln16 from their Asterisk 10 builds should not panic.


Users can create 16-bit Signed Linear files of varying sampling rates from WAV files using the sox command-line audio utility. 


* SOX example



sox input.wav -t raw -b 16 -r 32000 output.sln
mv output.sln output.sln32

In this example, an input WAV file has been converted to Signed Linear at a depth of 16-bits and at a rate of 32kHz. The resulting output.sln file is then renamed output.sln32 so that it can be processed correctly by Asterisk.


#### 32kHz Speex Support


Asterisk versions prior to 1.8 supported 8kHz Speex. Asterisk 1.8 supports 8 and 16kHz Speex. Asterisk 10 now supports 8, 16, and 32kHz Speex. Use of the 32kHz Speex mode is, like the other modes, controlled in the respective channel driver's configuration file, e.g. chan\_sip's sip.conf.


* Speex Example


sip.conf



[mypeer]
type=peer
secret=mysupersecret!!!
host=dynamic
context=fancycalls
disallow=all
allow=speex

[mypeer2]
type=peer
secret=myothers3cr3t
host=dynamic
context=fancycalls
disallow=all
allow=speex16

[mypeer3]
type=peer
secret=passwordisaterriblepassword
host=dynamic
context=fancycalls
disallow=all
allow=speex32

In this example, we have created three SIP peers for 3 different devices. The first, mypeer, supports only the 8kHz sampling of Speex; the second, mypeer2, supports only the 16kHz sampling of Speex; and the third, mypeer3, supports the new 32kHz sampling of Speex.


For comparison, here are some Speex samples, saved as WAV files in .mov containers, for ease-of-playback.




|  |  |  |
| --- | --- | --- |
| 8kHz 20100  | 16kHz 20100  | 32kHz 20100 |


#### CELT Pass-through Support


Asterisk 10 adds pass-through support for the CELT codec. CELT provides low-delay transmission of high-quality audio. Unlike many other codecs that are focused on the transmission of human speech only, CELT is suitable for the transmission of both speech and audio, e.g. music.


Because the CELT codec is being folded, along with SILK, into a future codec called OPUS, and because the CELT bitstream isn't finalized, we have chosen not to add transcoding support for CELT as this time. CELT is configured in codecs.conf with the following parameters.




| Option  | Values  | Description |
| --- | --- | --- |
|  type  |  celt  |  Sets the CELT codec as the type of codec being configured  |
|  samprate  |  32000, 441000, 48000  |  Defines the sampling rate in Hz to be used for the defined codec  |
|  framesize  |  factors of 2  |  Represents the duration of each frame in samples. Defaults to 480 and should only be defined if a client does not use the default size. This option allows the codec to split 20ms frames into multiple frames in an anticipatory way. Thus, with 20ms frames at 48kHz are 960 samples, the packet is large. So setting framesize to 480, 20ms frames are transmitted in two 480 sample packets.  |


##### CELT codecs.conf example



[celt32]
type=celt
samprate=32000

[celt44]
type=celt
samprate=44100

[celt48]
type=celt
samprate=48000

In this example, three different CELT codecs are created: one for 32kHz mode, one for 44kHz mode, and another for 48kHz mode. 



These codecs cannot be dynamically changed while Asterisk is running. In order to make changes, an Asterisk restart is required.



To make sure a codec or format is setup correctly, you can execute:



core show codecs

from the Asterisk CLI


##### CELT sip.conf example


Corresponding SIP peer entries to use the CELT codec would look like:



[myceltpeer1]
type=peer
secret=passwordisstillaterriblepassword
host=dynamic
context=fancycalls
disallow=all
allow=celt32

[myceltpeer2]
type=peer
secret=momnowaitdontmakemomyourpassword
host=dynamic
context=fancycalls
disallow=all
allow=celt44

[myceltpeer3]
type=peer
secret=daddontmakedadyourpasswordeither
host=dynamic
context=fancycalls
disallow=all
allow=celt48

In this case, we have defined 3 peers, each with a different CELT sampling rate. Thus, you'd probably want to set at least two of them to the same CELT rate, so they could call each other.


For CELT-calling, there are not a host of options on the client side. One could try Ekiga or SFLphone as softclients to make CELT calls.


#### SILK Support


Asterisk 10 provides full support for Skype's SILK codec. SILK is an extremely flexible codec for the transmission of speech. It operates in low bitrate narrow-band modes as well as higher (but still very low, otherwise) bitrate super wide-band modes. With respect to CPU complexity, its consumption is roughly three times that of G.729a at comparable bitrates.


SILK is configured in codecs.conf with the following parameters




| Option  | Values  | Description |
| --- | --- | --- |
|  type  |  silk  |  Sets the SILK codec as the type of codec being configured  |
|  samprate  |  8000, 12000, 16000, 24000  |  Defines the sampling rate in Hz to be used for the defined codec  |
|  fec  |  true, false  |  Sets the use of Forward Error Correction by the codec. Off by default.  |
|  packetloss\_percentage  |  Integer as a percent  |  Defines the estimated packetloss in the uplink direction. This parameter affects the amount of redundancy built into SILK when fec is enabled. The larger the amount, the higher the consumed bandwidth. Default is 0. 10 is recommended when fec is enabled  |
|  maxbitrate  |  8kHz: 5000-20000, 12kHz: 7000-25000, 16kHz: 8000-30000, 24kHz: 20000-40000  |  Defines, in bps and per the sampling rate being used, the maximum bitrate that will be consumed by the codec  |
|  dtx  |  true, false  |  Defines whether encoding is done in discontinuous transmission mode. If enabled, bandwidth will be reduced during periods of silence, but additional CPU complexity will be required. Off by default  |


##### SILK codecs.conf example



[silk8]
type=silk
samprate=8000
fec=true
packetloss\_percentage=10
maxbitrate=20000
dtx=false

[silk12]
type=silk
samprate=12000
fec=true
packetloss\_percentage=10
maxbitrate=25000
dtx=false

[silk16]
type=silk
samprate=16000
fec=true
packetloss\_percentage=10
maxbitrate=30000
dtx=false

[silk24]
type=silk
samprate=24000
fec=true
packetloss\_percentage=10
maxbitrate=40000
dtx=false

In this example, four different SILK codecs are created: one each for 8 (silk8), 12 (silk12), 16 (silk16), and 24kHz (silk24).



These codecs cannot be dynamically changed while Asterisk is running. In order to make changes, an Asterisk restart is required.



To make sure a codec or format is setup correctly, you can execute:



core show codecs

from the Asterisk CLI


##### SILK sip.conf example


Corresponding SIP peer entries to use the SILK codec would look like:



[mysilkpeer1]
type=peer
secret=thanksdigium
host=dynamic
context=fancycalls
disallow=all
allow=silk8

[mysilkpeer2]
type=peer
secret=forgivingme
host=dynamic
context=fancycalls
disallow=all
allow=silk12

[mysilkpeer3]
type=peer
secret=suchexcellentsoftware
host=dynamic
context=fancycalls
disallow=all
allow=silk16

[mysilkpeer4]
type=peer
secret=touse
host=dynamic
context=fancycalls
disallow=all
allow=silk24

In this case, we have defined 4 peers, each with a different SILK codec.


The generally available SIP softphones that support SILK are, to our knowledge, [CSIPSimple](http://code.google.com/p/csipsimple/) and nightly builds of [Jitsi](http://jitsi.org/index.php/Main/HomePage) beginning with build 3648 (so that, and anything newer than that).



The SILK licensing, like the licensing for Polycom's Siren 7 G.722.1 and Siren 14 G.722.1C codecs, requires that the distribution of binary codec modules that can be used by Asterisk. To download the SILK codec module for Asterisk, browse to <http://downloads.digium.com/pub/telephony/codec_silk/> and drop the untar'd .so file into /usr/lib/asterisk/modules and issue an Asterisk restart, or simply load the codec module from the Asterisk CLI

