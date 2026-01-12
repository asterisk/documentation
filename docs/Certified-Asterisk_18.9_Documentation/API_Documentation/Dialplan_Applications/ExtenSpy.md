---
search:
  boost: 0.5
title: ExtenSpy
---

# ExtenSpy()

### Synopsis

Listen to a channel, and optionally whisper into it.

### Description

This application is used to listen to the audio from an Asterisk channel. This includes the audio coming in and out of the channel being spied on. Only channels created by outgoing calls for the specified extension will be selected for spying. If the optional context is not supplied, the current channel's context will be used.<br>

While spying, the following actions may be performed:<br>

- Dialing '#' cycles the volume level.<br>

- Dialing '*' will stop spying and look for another channel to spy on.<br>


/// note
The _X_ option supersedes the three features above in that if a valid single digit extension exists in the correct context ChanSpy will exit to it. This also disables choosing a channel based on 'chanprefix' and a digit sequence.
///


### Syntax


```

ExtenSpy(exten@[context],[options])
```
##### Arguments


* `exten`

    * `exten` **required** - Specify extension.<br>

    * `context` - Optionally specify a context, defaults to 'default'.<br>

* `options`

    * `b` - Only spy on channels involved in a bridged call.<br>


    * `B` - Instead of whispering on a single channel barge in on both channels involved in the call.<br>


    * `c(digit)`

        * `digit` **required** - Specify a DTMF digit that can be used to spy on the next available channel.<br>


    * `d` - Override the typical numeric DTMF functionality and instead use DTMF to switch between spy modes.<br>

        * `4` - spy mode<br>

        * `5` - whisper mode<br>

        * `6` - barge mode<br>


    * `D` - Interleave the audio coming from the channel and the audio coming to the channel in the output audio as a dual channel stream, rather than mix it. Does nothing if 'o' is also set.<br>


    * `e(ext)` - Enable *enforced* mode, so the spying channel can only monitor extensions whose name is in the _ext_ : delimited list.<br>

        * `ext` **required**


    * `E` - Exit when the spied-on channel hangs up.<br>


    * `g(grp)`

        * `grp` **required** - Only spy on channels in which one or more of the groups listed in _grp_ matches one or more groups from the **SPYGROUP** variable set on the channel to be spied upon.<br>


    * `l` - Allow usage of a long queue to store audio frames.<br>


    * `n(mailbox@context)` - Say the name of the person being spied on if that person has recorded his/her name. If a context is specified, then that voicemail context will be searched when retrieving the name, otherwise the 'default' context be used when searching for the name (i.e. if SIP/1000 is the channel being spied on and no mailbox is specified, then '1000' will be used when searching for the name).<br>

        * `mailbox`

        * `context`


    * `o` - Only listen to audio coming from this channel.<br>


    * `q` - Don't play a beep when beginning to spy on a channel, or speak the selected channel name.<br>


    * `r(basename)` - Record the session to the monitor spool directory. An optional base for the filename may be specified. The default is 'chanspy'.<br>

        * `basename`


    * `s` - Skip the playback of the channel type (i.e. SIP, IAX, etc) when speaking the selected channel name.<br>


    * `S` - Stop when there are no more extensions left to spy on.<br>


    * `v(value)` - Adjust the initial volume in the range from '-4' to '4'. A negative value refers to a quieter setting.<br>

        * `value`


    * `w` - Enable 'whisper' mode, so the spying channel can talk to the spied-on channel.<br>


    * `W` - Enable 'private whisper' mode, so the spying channel can talk to the spied-on channel but cannot listen to that channel.<br>


    * `x(digit)`

        * `digit` **required** - Specify a DTMF digit that can be used to exit the application while actively spying on a channel. If there is no channel being spied on, the DTMF digit will be ignored.<br>


    * `X` - Allow the user to exit ChanSpy to a valid single digit numeric extension in the current context or the context specified by the **SPY\_EXIT\_CONTEXT** channel variable. The name of the last channel that was spied on will be stored in the **SPY\_CHANNEL** variable.<br>


### See Also

* [Dialplan Applications ChanSpy](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/ChanSpy)
* [AMI Events ChanSpyStart](/Certified-Asterisk_18.9_Documentation/API_Documentation/AMI_Events/ChanSpyStart)
* [AMI Events ChanSpyStop](/Certified-Asterisk_18.9_Documentation/API_Documentation/AMI_Events/ChanSpyStop)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 