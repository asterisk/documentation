---
search:
  boost: 0.5
title: ConfBridge
---

# ConfBridge()

### Synopsis

Conference bridge application.

### Description

Enters the user into a specified conference bridge. The user can exit the conference by hangup or DTMF menu option.<br>

This application sets the following channel variable upon completion:<br>


* `CONFBRIDGE_RESULT`

    * `FAILED` - The channel encountered an error and could not enter the conference.

    * `HANGUP` - The channel exited the conference by hanging up.

    * `KICKED` - The channel was kicked from the conference.

    * `ENDMARKED` - The channel left the conference as a result of the last marked user leaving.

    * `DTMF` - The channel pressed a DTMF sequence to exit the conference.

    * `TIMEOUT` - The channel reached its configured timeout.

### Syntax


```

ConfBridge(conference,[bridge_profile,[user_profile,[menu]]])
```
##### Arguments


* `conference` - Name of the conference bridge. You are not limited to just numbers.<br>

* `bridge_profile` - The bridge profile name from confbridge.conf. When left blank, a dynamically built bridge profile created by the CONFBRIDGE dialplan function is searched for on the channel and used. If no dynamic profile is present, the 'default\_bridge' profile found in confbridge.conf is used.<br>
It is important to note that while user profiles may be unique for each participant, mixing bridge profiles on a single conference is \_NOT\_ recommended and will produce undefined results.<br>

* `user_profile` - The user profile name from confbridge.conf. When left blank, a dynamically built user profile created by the CONFBRIDGE dialplan function is searched for on the channel and used. If no dynamic profile is present, the 'default\_user' profile found in confbridge.conf is used.<br>

* `menu` - The name of the DTMF menu in confbridge.conf to be applied to this channel. When left blank, a dynamically built menu profile created by the CONFBRIDGE dialplan function is searched for on the channel and used. If no dynamic profile is present, the 'default\_menu' profile found in confbridge.conf is used.<br>

### See Also

* [Dialplan Applications ConfKick](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/ConfKick)
* [Dialplan Functions CONFBRIDGE](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/CONFBRIDGE)
* [Dialplan Functions CONFBRIDGE_INFO](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/CONFBRIDGE_INFO)
* [Dialplan Functions CONFBRIDGE_CHANNELS](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/CONFBRIDGE_CHANNELS)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 