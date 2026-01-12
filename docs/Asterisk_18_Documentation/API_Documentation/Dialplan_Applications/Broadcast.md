---
search:
  boost: 0.5
title: Broadcast
---

# Broadcast()

### Synopsis

Transmit or receive audio to or from multiple channels simultaneously

### Description

This application can be used to broadcast audio to multiple channels at once. Any audio received on this channel will be transmitted to all of the specified channels and, optionally, their bridged peers.<br>

It can also be used to aggregate audio from multiple channels at once. Any audio on any of the specified channels, and optionally their bridged peers, will be transmitted to this channel.<br>

Execution of the application continues until either the broadcasting channel hangs up or all specified channels have hung up.<br>

This application is used for one-to-many and many-to-one audio applications where bridge mixing cannot be done synchronously on all the involved channels. This is primarily useful for injecting the same audio stream into multiple channels at once, or doing the reverse, combining the audio from multiple channels into a single stream. This contrasts with using a separate injection channel for each target channel and/or using a conference bridge.<br>

The channel running the Broadcast application must do so synchronously. The specified channels, however, may be doing other things.<br>

``` title="Example: Broadcast received audio to three channels and their bridged peers"

same => n,Broadcast(wb,DAHDI/1,DAHDI/3,PJSIP/doorphone)


```
``` title="Example: Broadcast received audio to three channels, only"

same => n,Broadcast(w,DAHDI/1,DAHDI/3,PJSIP/doorphone)


```
``` title="Example: Combine audio from three channels and their bridged peers to us"

same => n,Broadcast(s,DAHDI/1,DAHDI/3,PJSIP/doorphone)


```
``` title="Example: Combine audio from three channels to us"

same => n,Broadcast(so,DAHDI/1,DAHDI/3,PJSIP/doorphone)


```
``` title="Example: Two-way audio with a bunch of channels"

same => n,Broadcast(wbso,DAHDI/1,DAHDI/3,PJSIP/doorphone)


```
Note that in the last example above, this is NOT the same as a conference bridge. The specified channels are not audible to each other, only to the channel running the Broadcast application. The two-way audio is only between the broadcasting channel and each of the specified channels, individually.<br>


### Syntax


```

Broadcast([options,]channels)
```
##### Arguments


* `options`

    * `b` - In addition to broadcasting to target channels, also broadcast to any channels to which target channels are bridged.<br>


    * `l` - Allow usage of a long queue to store audio frames.<br>


    * `o` - Do not mix streams when combining audio from target channels (only applies with s option).<br>


    * `r` - Feed frames to barge channels in "reverse" by injecting them into the primary channel's read queue instead.<br>
This option is required for barge to work in a n-party bridge (but not for 2-party bridges). Alternately, you can add an intermediate channel by using a non-optimized Local channel, so that the target channel is bridged with a single channel that is connected to the bridge, but it is recommended this option be used instead.<br>
Note that this option will always feed injected audio to the other party, regardless of whether the target channel is bridged or not.<br>


    * `s` - Rather than broadcast audio to a bunch of channels, receive the combined audio from the target channels.<br>


    * `w` - Broadcast audio received on this channel to other channels.<br>


* `channels` - List of channels for broadcast targets.<br>
Channel names must be the full channel names, not merely device names.<br>
Broadcasting will continue until the broadcasting channel hangs up or all target channels have hung up.<br>

### See Also

* [Dialplan Applications ChanSpy](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/ChanSpy)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 