---
title: File Format Drivers
pageid: 4817495
---

Asterisk uses file format modules to take media (such as audio and video) from the network and save them on disk, or retrieve said files from disk and convert them back to a media stream. While often related to [CODECs](/Fundamentals/Asterisk-Architecture/Types-of-Asterisk-Modules/Codec-Modules), there may be more than one available on-disk format for a particular CODEC.

File format modules have file names that look like **format_xxxxx.so**, such as **format_wav.so** and **format_jpeg.so**.

Below is a list of format modules included with recent versions of Asterisk:

* format_g719
* format_g723
* format_g726
* format_g729
* format_gsm
* format_h263
* format_h264
* format_ilbc
* format_jpeg
* format_ogg_vorbis
* format_pcm
* format_siren7
* format_siren14
* format_sln
* format_vox
* format_wav_gsm
* format_wav
