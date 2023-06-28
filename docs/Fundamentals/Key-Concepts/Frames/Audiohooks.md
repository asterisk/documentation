---
title: Audiohooks
pageid: 21463463
---

Overview
========


Certain applications and functions are capable of attaching what is known as an audiohook to a channel. In order to understand what this means and how to handle these applications and functions, it is useful to understand a little of the architecture involved with attaching them.


Introduction - A Simple Audiohook
=================================


Simple Audio Hook ExampleL
In this simple example, a SIP phone has dialed into Asterisk and its channel has invoked a function (pitch_shift) which has been set to cause all audio sent and received to have its pitch shifted higher (i.e. if the audio is voice, the voices will sound squeaky sort of like obnoxious cartoon chipmunks). The following dialplan provides a more concrete usage:




---

  
  


```

Confluencenoneexten => 1,1,Answer()
exten => 1,n,Set(PITCH_SHIFT(both)=higher)
exten => 1,n,Voicemail(501)

```


When a phone calls this extension, it will be greeted by a higher pitched version of the voicemail prompt and then the speaker will leave a message for 501. The sound going from the phone to voicemail will also be higher pitched than what was actually said by the person who left the message.


Right now a serious minded Asterisk user reading this example might think something along the lines of 'So what, I don't have any use for making people using my phone system sound like squirrels." However, audiohooks provide a great deal of the functionality for other applications within Asterisk including some features that are very business minded (listening in on channels, recording phone calls, and even less spy-guy type things like adjusting volume on the fly)


It's important to note that audiohooks are bound to the channel that they were invoked on. They don't apply to a call (a call is actually a somewhat nebulous concept in general anyway) and so one shouldn't expect audiohooks to follow other channels around just because audio that those channels are involved with touches the hook. If the channel that created the audiohook ceases to be involved with an audio stream, the audiohook will also no longer be involved with that audio stream.


Attended Transfers and AUDIOHOOK_INHERIT
=========================================


Audio hook with two endpoints


---

  
  


```

Confluencenoneexten => 1,1,Answer()
exten => 1,n,MixMonitor(training_recording.wav)
exten => 1,n,Queue(techsupport)

```


Imagine the following scenario. An outside line calls into an Asterisk system to enter a tech support queue. When the call starts this user hears something along the lines of "Thank you for calling, all calls will be recorded for training purposes", so naturally MixMonitor will be used to record the call. The first available agent answers the call and can't quite seem to provide a working solution to the customer's problem, so he attempts to perform an attended transfer to someone with more expertise on the issue. The user gets transfered, and the rest of the call goes smoothly, but... ah nuts. The recording stopped for some reason when the agent transferred the customer to the other user. And why didn't this happen when he blind transferred a customer the other day?


The reason MixMonitor stopped is because the channel that owned it died. An Asterisk admin might think something like "That's not true, the mixmonitor was put on the customer channel and its still there, I can still see it's name is the same and everything." and it's true that it seems that way, but attended transfers in particular cause what's known as a channel masquerade. Yes, its name and everything else about it seems like the same channel, but in reality the customer's channel has been swapped for the agent's channel and died since the agent hung up. The audiohook went with it. Under normal circumstances, administrators don't need to think about masquerades at all, but this is one of the rare instances where it gets in the way of desired behavior. This doesn't affect blind transfers because they don't start the new dialog by having the person who initiated the transfer bridging to the end recipient.


Working around this problem is pretty easy though. Audiohooks are not swapped by default when a masquerade occurs, unlike most of the relevant data on the channel. This can be changed on a case by case basis though with the AUDIOHOOK_INHERIT dialplan function.


Using AUDIOHOOK_INHERT only requires that AUDIOHOOK_INHERIT(source)=yes is set where source is the name given for the source of the audiohook. For more information on the sources available, see the description of the source argument in the documentation for AUDIOHOOK_INHERIT.


So to fix the above example so that mixmonitor continues to record after the attended transfer, only one extra line is needed.




---

  
  


```

Confluencenoneexten => 1,1,Answer()
exten => 1,n,MixMonitor(training_recording.wav)
exten => 1,n,Set(AUDIOHOOK_INHERIT(MixMonitor)=yes)
exten => 1,n,Queue(techsupport)

```


Below is an illustrated example of how the masquerade process impacts an audiohook (in the case of the example, PITCH_SHIFT)


Attended Transfer
Inheritance of audiohooks can be turned off in the same way by setting AUDIOHOOK_INHERIT(source)=no.


Audiohook Sources
=================


Audiohooks have a source name and can come from a number of sources. An up to date list of possible sources should always be available from the documentation for AUDIOHOOK_INHERIT.


* Chanspy - from app_chanspy
* MixMonitor - app_mixmonitor.c
* Volume - func_volume.c
* Mute - res_mutestream.c
* Speex - func_speex.c
* pitch_shift - func_pitchshift.c
* JACK_HOOK - app_jack.c



Limitations for transferring Audiohooks
=======================================


Even with audiohook inheritance set, the MixMonitor is still bound to the channel that invoked it. The only difference in this case is that with this option set, the audiohook won't be left on the discarded channel through the masquerade. This option doesn't enable a channel running mixmonitor to transfer the MixMonitor to another channel or anything like that. The dialog below illustrates why.


audiohook_masquerade_transfer_initiated_by_ownerL