---
search:
  boost: 0.5
title: Bridge
---

# Bridge()

### Synopsis

Bridge two channels.

### Description

Allows the ability to bridge two channels via the dialplan.<br>

This application sets the following channel variable upon completion:<br>


* `BRIDGERESULT` - The result of the bridge attempt as a text string.<br>

    * `SUCCESS`

    * `FAILURE`

    * `LOOP`

    * `NONEXISTENT`

### Syntax


```

Bridge(channel,[options])
```
##### Arguments


* `channel` - The current channel is bridged to the channel identified by the channel name, channel name prefix, or channel uniqueid.<br>

* `options`

    * `p` - Play a courtesy tone to _channel_.<br>


    * `F(context^exten^priority)` - When the bridger hangs up, transfer the *bridged* party to the specified destination and *start* execution at that location.<br>

        * `context`

        * `exten`

        * `priority` **required**


    * `F` - When the bridger hangs up, transfer the *bridged* party to the next priority ofthe current extension and *start* execution at that location.<br>


    * `h` - Allow the called party to hang up by sending the _*_ DTMF digit.<br>


    * `H` - Allow the calling party to hang up by pressing the _*_ DTMF digit.<br>


    * `k` - Allow the called party to enable parking of the call by sending the DTMF sequence defined for call parking in *features.conf*.<br>


    * `K` - Allow the calling party to enable parking of the call by sending the DTMF sequence defined for call parking in *features.conf*.<br>


    * `L(x[:y][:z])` - Limit the call to _x_ ms. Play a warning when _y_ ms are left. Repeat the warning every _z_ ms. The following special variables can be used with this option:<br>

        * `LIMIT_PLAYAUDIO_CALLER` - Play sounds to the caller. yes|no (default yes)<br>

        * `LIMIT_PLAYAUDIO_CALLEE` - Play sounds to the callee. yes|no<br>

        * `LIMIT_TIMEOUT_FILE` - File to play when time is up.<br>

        * `LIMIT_CONNECT_FILE` - File to play when call begins.<br>

        * `LIMIT_WARNING_FILE` - File to play as warning if _y_ is defined. The default is to say the time remaining.<br>


    * `n` - Do not answer the channel automatically before bridging.<br>
Additionally, to prevent a bridged channel (the target of the Bridge application) from answering, the 'BRIDGE\_NOANSWER' variable can be set to inhibit answering.<br>


    * `S(x)` - Hang up the call after _x_ seconds *after* the called party has answered the call.<br>


    * `t` - Allow the called party to transfer the calling party by sending the DTMF sequence defined in *features.conf*.<br>


    * `T` - Allow the calling party to transfer the called party by sending the DTMF sequence defined in *features.conf*.<br>


    * `w` - Allow the called party to enable recording of the call by sending the DTMF sequence defined for one-touch recording in *features.conf*.<br>


    * `W` - Allow the calling party to enable recording of the call by sending the DTMF sequence defined for one-touch recording in *features.conf*.<br>


    * `x` - Cause the called party to be hung up after the bridge, instead of being restarted in the dialplan.<br>


### See Also

* [AMI Actions Bridge](/Asterisk_18_Documentation/API_Documentation/AMI_Actions/Bridge)
* [AMI Events BridgeCreate](/Asterisk_18_Documentation/API_Documentation/AMI_Events/BridgeCreate)
* [AMI Events BridgeEnter](/Asterisk_18_Documentation/API_Documentation/AMI_Events/BridgeEnter)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 