---
search:
  boost: 0.5
title: FEATURE
---

# FEATURE()

### Synopsis

Get or set a feature option on a channel.

### Description

When this function is used as a read, it will get the current value of the specified feature option for this channel. It will be the value of this option configured in features.conf if a channel specific value has not been set. This function can also be used to set a channel specific value for the supported feature options.<br>


### Syntax


```

FEATURE(option_name)
```
##### Arguments


* `option_name` - The allowed values are:<br>

    * `inherit` - Inherit feature settings made in FEATURE or FEATUREMAP to child channels.<br>

    * `featuredigittimeout` - Milliseconds allowed between digit presses when entering a feature code.<br>

    * `transferdigittimeout` - Seconds allowed between digit presses when dialing a transfer destination<br>

    * `atxfernoanswertimeout` - Seconds to wait for attended transfer destination to answer<br>

    * `atxferdropcall` - Hang up the call entirely if the attended transfer fails<br>

    * `atxferloopdelay` - Seconds to wait between attempts to re-dial transfer destination<br>

    * `atxfercallbackretries` - Number of times to re-attempt dialing a transfer destination<br>

    * `xfersound` - Sound to play to during transfer and transfer-like operations.<br>

    * `xferfailsound` - Sound to play to a transferee when a transfer fails<br>

    * `atxferabort` - Digits to dial to abort an attended transfer attempt<br>

    * `atxfercomplete` - Digits to dial to complete an attended transfer<br>

    * `atxferthreeway` - Digits to dial to change an attended transfer into a three-way call<br>

    * `pickupexten` - Digits used for picking up ringing calls<br>

    * `pickupsound` - Sound to play to picker when a call is picked up<br>

    * `pickupfailsound` - Sound to play to picker when a call cannot be picked up<br>

    * `courtesytone` - Sound to play when automon or automixmon is activated<br>

    * `recordingfailsound` - Sound to play when automon or automixmon is attempted but fails to start<br>

    * `transferdialattempts` - Number of dial attempts allowed when attempting a transfer<br>

    * `transferretrysound` - Sound that is played when an incorrect extension is dialed and the transferer should try again.<br>

    * `transferinvalidsound` - Sound that is played when an incorrect extension is dialed and the transferer has no attempts remaining.<br>

    * `transferannouncesound` - Sound that is played to the transferer when a transfer is initiated. If empty, no sound will be played.<br>

### See Also

* [Dialplan Functions FEATUREMAP](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/FEATUREMAP)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 