---
title: Overview
pageid: 13076234
---

Overview
========

Asterisk, since its early days, has offered a conferencing application called MeetMe ([app\_meetme.so](http://app_meetme.so)). MeetMe provides DAHDI-mixed software-based bridges for multi-party audio conferencing. MeetMe is used by nearly all Asterisk implementations - small office, call center, large office, feature-server, third-party application, etc. It has been extremely successful as an audio bridge.

Over time, several significant limitations of MeetMe have been encountered by its users. Among these are two of distinction: MeetMe requires DAHDI for mixing, and is thus limited to 8kHz (PSTN) audio sampling rates; and MeetMe is delivered in a fairly static form, it does not provide extensive configuration options.

To address these limitations, a new conferencing application, based upon the ConfBridge application introduced in Asterisk 1.6.0, is now available with Asterisk 10. This new ConfBridge application replaces the older ConfBridge application. It is not intended to be a direct replacement for MeetMe, it will not provide feature parity with the MeetMe application. Instead, the new ConfBridge application delivers a completely redesigned set of functionality that most users will find more than sufficient, and in many ways better, for their conferencing needs.

On This Page


In This SectionConfBridge Concepts
===================

ConfBridge provides four internal concepts:

1. Conference Number
2. Bridge Profile
3. User Profile
4. Conference Menu

A **Conference Number** is a numerical representation for an instance of the bridge. Callers joined to the same conference number will be in the same conference bridge; they're connected. Callers joined to different conference numbers are not in the same conference bridge; they're separated. Conference Numbers are assigned in the dialplan. Unlike MeetMe, they're not pre-reserved.

A **Bridge Profile** is a named set of options that control the behavior of a particular conference bridge. Each bridge must have its own profile. A single bridge cannot have more than one Bridge Profile.

A **User Profile** is a named set of options that control the user's experience as a member of a particular bridge. Each user participating in a bridge can have their own individual User Profile.

A **Conference Menu** is a named set of options that are provided to a user when they present DTMF keys while connected to the bridge. Each user participating in a bridge can have their own individual Conference Menu.

ConfBridge Application Syntax
=============================

The ConfBridge application syntax and usage can be found at [Asterisk 13 Application\_ConfBridge](/Asterisk-13-Application_ConfBridge)

ConfBridge Application Examples
===============================

**Example 1**  
 In this example, callers will be joined to conference number 1234, using the default Bridge Profile, the default User Profile, and no Conference Menu.




---

  
  


```

exten => 1,1,Answer()
exten => 1,n,ConfBridge(1234)


```


**Example 2**  





---

  
  


```

exten => 1,1,Answer()
exten => 1,n,ConfBridge(1234,,1234\_participants,1234\_menu)


```


Usage Notes, FAQ and Other
==========================

There are many points to consider when using the new ConfBridge appliation. Some will be examined here.

#### Video Conferencing

It is imperative that a video conference not have participants using disparate video codecs or encoding profiles. Everyone **must** use the same codec and profile. Otherwise, the video sessions won't work - you'll likely experience frozen video as the conference switches from one video stream using a codec your client has negotiated, to a video stream using a codec your client hasn't negotiated or doesn't support.

##### Video Endpoints

ConfBridge has been tested against a number of video-capable SIP endpoints. Success, and your mileage will vary.

Endpoints that work:

* Jitsi - Jitsi works well for both H.264 and H.263+1998 video calling on Mac, Linux and Windows machines. Currently, Jitsi seems to be the best-working, free, H.264-capable SIP video client.
* Linphone - Linphone works well for H.263+1998 and H.263 video calling on Linux - the Mac port and mobile ports do not support video. Currently, Linphone seems to be the best-working, free, H.263-capable SIP video client, when Jitsi or H.263+1998 aren't an option.
* Empathy - Empathy works for H.264 calling, but is amazingly difficult to configure (why one has to make two SIP accounts just to make a SIP call is a mystery).
* Lifesize - The Lifesize client supports H.264 and runs on Windows only. It works very well, but it isn't free.
* Polycom VVX 1500 - The Polycom VVX 1500 works well for H.264 calling. If you're connecting it to Jitsi, you may have to configure Jitsi to use the Baseline H.264 profile instead of the Main profile.

Endpoints that don't or weren't tested:

* Xlite - Xlite works in some cases, but also seems to crash, regardless of operating system, at odd times. In other cases, Xlite isn't able to decode video from clients.
* Ekiga - Ekiga wasn't tested, because our test camera wasn't supported by the client. The same camera was supported by other soft clients.
* SIPDroid - SIPDroid doesn't seem to work.
* OfficeSIP Messenger - OfficeSIP Messenger didn't seem capable of performing a SIP registration. On this basis alone, no one should recommend its use.

#### Mixing Interval

The mixing interval for a conference is defined in its Bridge Profile. The allowable options are 10, 20, 40, and 80, all in milliseconds. Usage of 80ms mixing intervals is only supported for conferences that are sampled at 8, 12, 16, 24, 32, and 48kHz. Usage of 40ms intervals includes all of the aforementioned sampling rates as well as 96kHz. 192kHz sampled conferences are only supported at 10 and 20ms mixing intervals. These limitations are imposed because higher mixing intervals at the higher sampling rates causes large increases in memory consumption. Adventurous users may, through changing of the MAX\_DATALEN define in bridge\_softmix.c allow 96kHz and 192kHz sampled conferences to operate at longer intervals - set to 16192 for 96kHz at 80ms or 32384 for 192kHz at 80ms, recompile, and restart.

#### Maximizing Performance

In order to maximize the performance of a given machine for ConfBridge purposes, there are several steps one should take.

* Enable dsp\_drop\_silence is enabled in the User Profile.
	+ This is the **single most** important step one can take when trying to increase the number of bridge participants that a single machine can handle. Enabling this means that the audio of users that aren't speaking isn't mixed in with the bridge.
* Lengthen mixing\_interval in the Bridge Profile.
	+ The default interval is 20ms. Other options are 10, 40, and 80ms. Lower values provide a "tighter" sound, but require substantially more CPU. Higher values provider a "looser" sound, and consume substantially less CPU. Setting the value to 80 provides the highest number of possible participants.
* Connect clients at the same sampling rate.
	+ Requiring the bridge to resample between clients that use codecs with different sampling rates is an expensive operation. If all clients are dialed in to the bridge at the same sampling rate, and the bridge operates at that same rate, e.g. 16kHz, then the number of possible clients will be maximized.
* Run Asterisk with a higher priority.
	+ By default, Asterisk operates at a relatively normal priority, as compared to other processes on the system. To maximize the number of possible clients, Asterisk should be started using the **-p** (realtime) flag. If the load becomes too large, this can negatively impact the performance of other processes, including the console itself - making it difficult to remotely administer a fully loaded system.

As the number of clients approaches the maximum possible on the given machine, given its processing capabilities, audio quality will suffer. Following the above guidelines will increase the number of connected clients before audio quality suffers.

