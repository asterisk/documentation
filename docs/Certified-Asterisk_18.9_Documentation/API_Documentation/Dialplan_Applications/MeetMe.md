---
search:
  boost: 0.5
title: MeetMe
---

# MeetMe()

### Synopsis

MeetMe conference bridge.

### Description

Enters the user into a specified MeetMe conference. If the _confno_ is omitted, the user will be prompted to enter one. User can exit the conference by hangup, or if the 'p' option is specified, by pressing '#'.<br>


/// note
The DAHDI kernel modules and a functional DAHDI timing source (see dahdi\_test) must be present for conferencing to operate properly. In addition, the chan\_dahdi channel driver must be loaded for the 'i' and 'r' options to operate at all.
///


### Syntax


```

MeetMe([confno,[options,[pin]]])
```
##### Arguments


* `confno` - The conference number<br>

* `options`

    * `a` - Set admin mode.<br>


    * `A` - Set marked mode.<br>


    * `b` - Run AGI script specified in **MEETME\_AGI\_BACKGROUND** Default: 'conf-background.agi'.<br>


    * `c` - Announce user(s) count on joining a conference.<br>


    * `C` - Continue in dialplan when kicked out of conference.<br>


    * `d` - Dynamically add conference.<br>


    * `D` - Dynamically add conference, prompting for a PIN.<br>


    * `e` - Select an empty conference.<br>


    * `E` - Select an empty pinless conference.<br>


    * `F` - Pass DTMF through the conference.<br>


    * `G(x)` - Play an intro announcement in conference.<br>

        * `x` **required** - The file to playback<br>


    * `i` - Announce user join/leave with review.<br>


    * `I` - Announce user join/leave without review.<br>


    * `k` - Close the conference if there's only one active participant left at exit.<br>


    * `l` - Set listen only mode (Listen only, no talking).<br>


    * `m` - Set initially muted.<br>


    * `M(class)` - Enable music on hold when the conference has a single caller. Optionally, specify a musiconhold class to use. If one is not provided, it will use the channel's currently set music class, or 'default'.<br>

        * `class` **required**


    * `n` - Disable the denoiser. By default, if 'func\_speex' is loaded, Asterisk will apply a denoiser to channels in the MeetMe conference. However, channel drivers that present audio with a varying rate will experience degraded performance with a denoiser attached. This parameter allows a channel joining the conference to choose not to have a denoiser attached without having to unload 'func\_speex'.<br>


    * `o` - Set talker optimization - treats talkers who aren't speaking as being muted, meaning (a) No encode is done on transmission and (b) Received audio that is not registered as talking is omitted causing no buildup in background noise.<br>


    * `p(keys)` - Allow user to exit the conference by pressing '#' (default) or any of the defined keys. Dial plan execution will continue at the next priority following MeetMe. The key used is set to channel variable **MEETME\_EXIT\_KEY**.<br>

        * `keys` **required**


    * `P` - Always prompt for the pin even if it is specified.<br>


    * `q` - Quiet mode (don't play enter/leave sounds).<br>


    * `r` - Record conference (records as **MEETME\_RECORDINGFILE** using format **MEETME\_RECORDINGFORMAT**. Default filename is 'meetme-conf-rec-$\{CONFNO\}-$\{UNIQUEID\}' and the default format is wav.<br>


    * `s` - Present menu (user or admin) when '*' is received (send to menu).<br>


    * `t` - Set talk only mode. (Talk only, no listening).<br>


    * `T` - Set talker detection (sent to manager interface and meetme list).<br>


    * `v(mailbox@[context])` - Announce when a user is joining or leaving the conference. Use the voicemail greeting as the announcement. If the i or I options are set, the application will fall back to them if no voicemail greeting can be found.<br>

        * `mailbox@[context]` **required** - The mailbox and voicemail context to play from. If no context provided, assumed context is default.<br>


    * `w(secs)` - Wait until the marked user enters the conference.<br>

        * `secs` **required**


    * `x` - Leave the conference when the last marked user leaves.<br>


    * `X` - Allow user to exit the conference by entering a valid single digit extension **MEETME\_EXIT\_CONTEXT** or the current context if that variable is not defined.<br>


    * `1` - Do not play message when first person enters<br>


    * `S(x)` - Kick the user _x_ seconds *after* he entered into the conference.<br>

        * `x` **required**


    * `L(x:y:z)` - Limit the conference to _x_ ms. Play a warning when _y_ ms are left. Repeat the warning every _z_ ms. The following special variables can be used with this option:<br>

        * `CONF_LIMIT_TIMEOUT_FILE` - File to play when time is up.<br>

        * `CONF_LIMIT_WARNING_FILE` - File to play as warning if _y_ is defined. The default is to say the time remaining.<br>

        * `x`

        * `y`

        * `z`


* `pin`

### See Also

* [Dialplan Applications MeetMeCount](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/MeetMeCount)
* [Dialplan Applications MeetMeAdmin](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/MeetMeAdmin)
* [Dialplan Applications MeetMeChannelAdmin](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/MeetMeChannelAdmin)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 