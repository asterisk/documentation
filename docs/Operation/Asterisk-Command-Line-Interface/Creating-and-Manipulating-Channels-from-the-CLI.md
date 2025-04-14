---
title: Creating and Manipulating Channels from the CLI
pageid: 28315619
---

Here we'll mention a few commands that allow you to create or manipulate channels at the CLI during runtime.

channel request hangup
----------------------

Provided by the core, this command simply allows you to request that a specified channel or all channels be hungup.

```
Usage: channel request hangup <channel>|<all>
 Request that a channel be hung up. The hangup takes effect
 the next time the driver reads or writes from the channel.
 If 'all' is specified instead of a channel name, all channels
 will see the hangup request.

```

An example:

```
newtonr-laptop*CLI> core show channels
Channel Location State Application(Data) 
SIP/6001-00000001 (None) Up Playback(demo-congrats) 
1 active channel

newtonr-laptop*CLI> channel request hangup SIP/6001-00000001 
Requested Hangup on channel 'SIP/6001-00000001'
[May 2 09:51:19] WARNING[7045][C-00000001]: app_playback.c:493 playback_exec: Playback failed on SIP/6001-00000001 for demo-congrats

```

Here I made a call to an extension calling Playback, then from the CLI I requested that the established channel be hung up. You can see that it hung up in the middle of playing a sound file, so that sound file fails to continue playing.

channel originate
-----------------

Provided by res_clioriginate.so, this command allows you to create a new channel and have it connect to either a dialplan extension or a specific application.

```
 There are two ways to use this command. A call can be originated between a
channel and a specific application, or between a channel and an extension in
the dialplan. This is similar to call files or the manager originate action.
Calls originated with this command are given a timeout of 30 seconds.
Usage1: channel originate <tech/data> application <appname> [appdata]
 This will originate a call between the specified channel tech/data and the
given application. Arguments to the application are optional. If the given
arguments to the application include spaces, all of the arguments to the
application need to be placed in quotation marks.
Usage2: channel originate <tech/data> extension [exten@][context]
 This will originate a call between the specified channel tech/data and the
given extension. If no context is specified, the 'default' context will be
used. If no extension is given, the 's' extension will be used.

```

An example:

```
newtonr-laptop*CLI> channel originate SIP/6001 extension 9999@somecontext
 == Using SIP RTP CoS mark 5
 -- Called 6001
 -- SIP/6001-00000004 is ringing
 > 0x7f0828067710 -- Probation passed - setting RTP source address to 10.24.18.16:4046
 -- SIP/6001-00000004 answered
 -- Executing [9999@somecontext:1] VoiceMailMain("SIP/6001-00000004", "") in new stack
 -- <SIP/6001-00000004> Playing 'vm-login.gsm' (language 'en')
 > 0x7f0828067710 -- Probation passed - setting RTP source address to 10.24.18.16:4046

```

We originated a call to the chan_sip peer 6001 in this case. The extension parameter tells it what extension to connect that channel to once the channel answers. In this case we connect it to an extension calling VoiceMailMain.

channel redirect
----------------

Provided by res_clioriginate.so, this command allows you to redirect an existing channel to a dialplan extension.

```
Usage: channel redirect <channel> <[[context,]exten,]priority>
 Redirect an active channel to a specified extension.

```

An example:

```
 -- Executing [100@from-internal:1] Playback("SIP/6001-00000005", "demo-congrats") in new stack
 > 0x7f07ec03e560 -- Probation passed - setting RTP source address to 10.24.18.16:4048
 -- <SIP/6001-00000005> Playing 'demo-congrats.gsm' (language 'en')
newtonr-laptop*CLI> channel redirect SIP/6001-00000005 somecontext,9999,1
Channel 'SIP/6001-00000005' successfully redirected to somecontext,9999,1
[May 2 09:56:28] WARNING[7056][C-00000005]: app_playback.c:493 playback_exec: Playback failed on SIP/6001-00000005 for demo-congrats
 -- Executing [9999@somecontext:1] VoiceMailMain("SIP/6001-00000005", "") in new stack
 -- <SIP/6001-00000005> Playing 'vm-login.gsm' (language 'en')

```

Here we make a call from SIP/6001 to a 100@from-internal, which results in a call to Playback. After the call is established, we issue a 'channel redirect' to redirect that channel to the extension 9999 in the context 'somecontext'. It is immediately placed into that extension and we hear the VoicemailMain prompt.
