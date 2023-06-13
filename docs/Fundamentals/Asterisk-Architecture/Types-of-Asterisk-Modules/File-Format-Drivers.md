---
title: File Format Drivers
pageid: 4817495
---

Asterisk uses file format modules to take media (such as audio and video) from the network and save them on disk, or retrieve said files from disk and convert them back to a media stream. While often related to CODECs, there may be more than one available on-disk format for a particular CODEC.

File format modules have file names that look like **format\_xxxxx.so**, such as **format\_wav.so** and **format\_jpeg.so**.

Below is a list of format modules included with recent versions of Asterisk:

* format\_g719
* format\_g723
* format\_g726
* format\_g729
* format\_gsm
* format\_h263
* format\_h264
* format\_ilbc
* format\_jpeg
* format\_ogg\_vorbis
* format\_pcm
* format\_siren7
* format\_siren14
* format\_sln
* format\_vox
* format\_wav\_gsm
* format\_wav
