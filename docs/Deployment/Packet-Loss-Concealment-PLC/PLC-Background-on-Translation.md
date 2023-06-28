---
title: PLC Background on Translation
pageid: 5243111
---

As stated in the introduction, generic PLC can only be used on slin audio. The majority of audio communication is not done in slin, but rather using lower bandwidth codecs. This means that for PLC to be used, there must be a translation step involving slin on the write path of a channel.  One item of note is that slin must be present on the write path of a channel since that is the path where PLC is applied. Consider that Asterisk is bridging channels A and B. A uses ulaw for audio and B uses GSM. This translation involves slin, so things are shaping up well for PLC. Consider, however if Asterisk sets up the translation paths like so:

Fig. 1




---

  
  


```

A +------------+ B
<---ulaw<---slin<---GSM| |GSM--->
 | Asterisk |
ulaw--->slin--->GSM--->| |<---GSM
 +------------+
 

```


The arrows indicate the direction of audio flow. Each channel has a write path (the top arrow) and a read path (the bottom arrow). In this setup, PLC can be used when sending audio to A, but it cannot be used when sending audio to B. The reason is simple, the write path to A's channel contains a slin step, but the write path to B contains no slin step. Such a translation setup is perfectly valid, and Asterisk can potentially set up such a path depending on circumstances. When we use PLC, however, we want slin audio to be present on the write paths of both A and B. A visual representation of what we want is the following:

Fig. 2




---

  
  


```

A +------------+ B
<---ulaw<---slin| |slin--->GSM--->
 | Asterisk |
ulaw--->slin--->| |<---slin<---GSM
 +------------+
 

```


In this scenario, the write paths for both A and B begin with slin, and so PLC may be applied to either channel. This translation behavior has, in the past been doable with the transcode_via_sln option in asterisk.conf. Recent changes to the PLC code have also made the `genericplc` option in codecs.conf imply the `transcode_via_sln` option. The result is that by enabling `genericplc` in codecs.conf, the translation path set up in Fig. 2 should automatically be used as long as the two codecs required transcoding in the first place.

If the codecs on the inbound and outbound channels are the same or do not require transcoding, PLC won't normally be used for the reasons stated above.  You can however, force transcoding and PLC in this situation by setting the `genericplc_on_equal_codecs parameter` in the `plc` section of codecs.conf to true.  This feature was introduced in Asterisk 13.21 and 15.4.

 

