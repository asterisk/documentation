---
title: ConfBridge Configuration
pageid: 34014252
---

ConfBridge Configuration
========================

ConfBridge Profiles and Menus are configured in the confbridge.conf configuration file - normally located at /etc/asterisk/confbridge.conf. The file contains three reserved sections:

* [general]
* [default\_bridge]
* [default\_user]

The **[general]** section is currently unused, but is reserved for future use.  
 The **[default\_bridge]** section contains all options invoked when ConfBridge is instantiated from the dialplan without a bridge profile argument.  
 The **[default\_user]** section contains all options invoked when ConfBridge is instantiated from the dialplan without a user profile argument.

Each section contains a **type** definition. The type definition determines the function of the section. The three **types** are:

* bridge
* user
* menu

**bridge** is used to denote Bridge Profile section definitions.  
 **user** is used to denote User Profile section definitions.  
 **menu** is used to denote Conference Menu section definitions.

All other sections, defined by a section identifier encapsulated in square brackets, are user-definable.

On This Page**Example**

This is an example, using invalid options and functions, of a confbridge.conf configuration file, displaying the organizational layout. The various options and functions are described later in this page.




---

  
  


```

[general]
; comments are preceded by a comma
;
; the general section is blank
;
[default\_bridge]
type=bridge
; Bridge Profile options go here
myoption=value
myoption2=othervalue
;
[default\_user]
type=user
; User Profile options go here
myoption=value
myoption2=othervalue
;
[sample\_menu]
type=menu
; Conferece Menu options go here
DTMF=function
otherDTMF=otherFunction
;


```


Bridge Profile Configuration Options
------------------------------------

A Bridge Profile provides the following configuration options:



| Option | Values | Description | Notes |
| --- | --- | --- | --- |
| type | bridge | Set this to bridge to configure a bridge profile |   |
| max\_members | integer; e.g. 50 | Limits the number of participants for a single conference to a specific number. By default, conferences have no participant limit. After the limit is reached, the conference will be locked until someone leaves. Admin-level users are exempt from this limit and will still be able to join otherwise-locked, because of limit, conferences. |   |
| record\_conference | yes/no | Records the conference call starting when the first user enters the room, and ending when the last user exits the room. The default recorded filename is 'confbridge-<name of conference bridge>-<start time>.wav and the default format is 8kHz signed linear. By default, this option is disabled. This file will be located in the configured monitoring directory as set in asterisk.conf |   |
| record\_file | path, e.g. /tmp/myfiles | When record\_conference is set to yes, the specific name of the recorded file can be set using this option. Note that since multiple conferences may use the same Bridge profile, this can cause issues, depending on the configuration. It is recommended to only use this option dynamically with the CONFBRIDGE() dialplan function. This allows the recorded name to be specified and a unique name to be chosen. By default, the recorded file is stored in Asterisk's spool/monitory directory, with a unique filename starting with the 'confbridge' prefix. |   |
| internal\_sample\_rate | auto, 8000, 12000, 16000, 24000, 32000, 44100, 48000, 96000, 192000 | Sets the internal native sample rate at which to mix the conference. The "auto" option allows Asterisk to adjust the sample rate to the best quality / performance based on the participant makeup. Numbered values lock the rate to the specified numerical rate. If a defined number does not match an internal sampling rate supported by Asterisk, the nearest sampling rate will be used instead. |   |
| mixing\_interval | 10, 20, 40, 80 | Sets, in milliseconds, the internal mixing interval. By default, the mixing interval of a bridge is 20ms. This setting reflects how "tight" or "loose" the mixing will be for the conference. Lower intervals provide a "tighter" sound with less delay in the bridge and consume more system resources. Higher intervals provide a "looser" sound with more delay in the bridge and consume less resources |   |
| video\_mode | none, follow\_talker, last\_marked, first\_marked | Configured video (as opposed to audio) distribution method for conference participants. Participants must use the same video codec. Confbridge does not provide MCU functionality. It does not transcode, scale, transrate, or otherwise manipulate the video. Options are "none," where no video source is set by default and a video source may be later set via AMI or DTMF actions; "follow\_talker," where video distrubtion follows whomever is talking and providing video; "last\_marked," where the last marked user with video capabilities to join the conference will be the single video source distributed to all other participants - when the current video source leaves, the marked user previous to the last-joined will be used as the video source; and "first-marked," where the first marked user with video capabilities to join the conference will be the single video source distributed to all other participants - when the current video source leaves, the marked user that joined next will be used as the video source. Use of video in conjunction with the jitterbuffer results in the audio being slightly out of sync with the video - because the jitterbuffer only operates on the audio stream, not the video stream. Jitterbuffer should be disabled when video is used. |   |
| sound\_join | filename | The sound played to the bridge when a user joins, typically some kind of beep sound |   |
| sound\_leave | filename | The sound played to the bridge when a user leaves, also typically some kind of beep sound |   |
| sound\_has\_joined | filename | The sound played as a user intro, e.g. "xxxx has joined the conference." |   |
| sound\_has\_left | filename | The sound played as a user parts the conference, e.g. "xxxx has left the conference." |   |
| sound\_kicked | filename | The sound played to a user who has been kicked from the conference. |   |
| sound\_muted | filename | The sound played to a user when the mute option is toggled on. |   |
| sound\_unmuted | filename | The sound played to a user when the mute option is toggled off. |   |
| sound\_only\_person | filename | The sound played when a user is the only person in the conference. |   |
| sound\_only\_one | filename | The sound played to a user when there is only one other person in the conference. |   |
| sound\_there\_are | filename | The sound played when announcing how many users there are in a conference. |   |
| sound\_other\_in\_party | filename | Used in conjunction with the sound\_there\_are option, used like "sound\_there\_are" <number of participants> "sound\_other\_in\_party" |   |
| sound\_place\_into\_conference | filename | The sound played when someone is placed into a conference, after waiting for a marked user. |   |
| sound\_wait\_for\_leader | filename | The sound played when a user is placed into a conference that cannot start until a marked user enters. |   |
| sound\_leader\_has\_left | filename | The sound played when the last marked user leaves the conference. |   |
| sound\_get\_pin | filename | The sound played when prompting for a conference PIN |   |
| sound\_invalid\_pin | filename | The sound played when an invalid PIN is entered too many (3) times |   |
| sound\_locked | filename | The sound played to a user trying to join a locked conference. |   |
| sound\_locked\_now | filename | The sound played to an Admin-level user after toggling the conference to locked mode. |   |
| sound\_unlocked\_now | filename | The sound played to an Admin-level user after toggling the conference to unlocked mode. |   |
| sound\_error\_menu | filename | The sound played when an invalid menu option is entered. |   |
| sound\_participants\_muted | filename | The sound played when all non-admin participants are muted. | **New in Asterisk 11** |
| sound\_participants\_unmuted | filename | The sound played when all non-admin participants are unmuted | **New in Asterisk 11** |

**Example**  





---

  
  


```

[fancybridge]
type=bridge
max\_members=20
mixing\_interval=10
internal\_sample\_rate=auto
record\_conference=yes


```


User Profile Configuration Options
----------------------------------

A User Profile provides the following configuration options:



| Option | Values | Description | Notes |
| --- | --- | --- | --- |
| type | user | Set this to user to configure a user profile |   |
| admin | yes/no | Sets if the user is an Admin or not. By default, no. |   |
| marked | yes/no | Sets if the user is Marked or not. By default, no. |   |
| startmuted | yes/no | sets if the user should start out muted. By default, no. |   |
| music\_on\_hold\_when\_empty | yes/no | Sets whether music on hold should be played when only one person is in the conference or when the user is waiting on a marked user to enter the conference. By default, off. |   |
| music\_on\_hold\_class | music on hold class | Sets the music on hold class to use for music on hold. |   |
| quiet | yes/no | When set to "yes," enter/leave prompts and user introductions are not played. By default, no. |   |
| announce\_user\_count | yes/no | Sets if the number of users in the conference should be announced to the caller. By default, no. |   |
| announce\_user\_count\_all | yes/no; or an integer | Sets if the number of users should be announced to all other users in the conference when someone joins. When set to a number, the announcement will only occur once the user count is above the specified number |   |
| announce\_only\_user | yes/no | Sets if the only user announcement should be played when someone enters an empty conference. By default, yes. |   |
| announcement | filename | If set, the sound file specified by `filename` will be played to the user, and only the user, upon joining the conference bridge. | **New in Asterisk 11** |
| wait\_marked | yes/no | Sets if the user must wait for another marked user to enter before joining the conference. By default, no. |   |
| end\_marked | yes/no | If enabled, every user with this option in their profile will be removed from the conference when the last marked user exists the conference. |   |
| dsp\_drop\_silence | yes/no | Drops what Asterisk detects as silence from entering into the bridge. Enabling this option will drastically improve performance and help remove the buildup of background noise from the conference. This option is highly recommended for large conferences, due to its performance improvements. |   |
| dsp\_talking\_threshold | integer in milliseconds | The time, in milliseconds, by default 160, of sound above what the DSP has established as base-line silence for a user, before that user is considered to be talking. This value affects several options:1. Audio is only mixed out of a user's incoming audio stream if talking is detected. If this value is set too loose, the user will hear themselves briefly each time they begin talking until the DSP has time to establish that they are in fact talking.
2. When talker detection AMI events are enabled, this value determines when talking has begun, which causes AMI events to fire. If this value is set too tight, AMI events may be falsely triggered by variants in the background noise of the caller.
3. The drop\_silence option depends on this value to determine when the user's audio should be mixed into the bridge after periods of silence. If this value is too loose, the beginning of a user's speech will get cut off as they transition from silence to talking.
 |   |
| dsp\_silence\_threshold | integer in milliseconds | The time, in milliseconds, by default 2500, of sound falling within what the DSP has established as the baseline silence, before a user is considered to be silent. The best way to approach this option is to set it slightly above the maximum amount of milliseconds of silence a user may generate during natural speech. This value affects several operations:1. When talker detection AMI events are enabled, this value determines when the user has stopped talking after a period of talking. If this value is set too low, AMI events indicating that the user has stopped talking may get faslely sent out when the user briefly pauses during mid sentence.
2. The drop\_silence option depends on this value to determine when the user's audio should begin to be dropped from the bridge, after the user stops talking. If this value is set too low, the user's audio stream may sound choppy to other participants.
 |   |
| talk\_detection\_events | yes/no | Sets whether or not notifications of when a user begins and ends talking should be sent out as events over AMI. By default, no. |   |
| denoise | yes/no | Whether or not a noise reduction filter should be applied to the audio before mixing. By default, off. This requires codec\_speex to be built and installed. Do not confuse this option with drop\_silence. denoise is useful if there is a lot of background noise for a user, as it attempts to remove the noise while still preserving the speech. This option does not remove silence from being mixed into the conference and does come at the cost of a slight performance hit. |   |
| jitterbuffer | yes/no | Whether or not to place a jitter buffer on the caller's audio stream before any audio mixing is performed. This option is highly recommended, but will add a slight delay to the audio and will incur a slight performance penalty. This option makes use of the JITTERBUFFER dialplan function's default adaptive jitter buffer. For a more fine-tuned jitter buffer, disable this option and use the JITTERBUFFER dialplan function on the calling channel, before it enters the ConfBridge application. |   |
| pin | integer | Sets if the user must enter a PIN before joining the conference. The user will be prompted for the PIN. |   |
| announce\_join\_leave | yes/no | When enabled, this option prompts the user for their name when entering the conference. After the name is recorded, it will be played as the user enters and exists the conference. By default, no. |   |
| dtmf\_passthrough | yes/no | Whether or not DTMF received from users should pass through the conference to other users. By default, no. |   |

**Example**  





---

  
  


```

[fancyuser]
type=user
music\_on\_hold\_when\_empty=yes
music\_on\_hold\_class=default
announce\_user\_count\_all=yes
announce\_join\_leave=yes
dsp\_drop\_silence=yes
denoise=yes
pin=456


```


Conference Menu Configuration Options
-------------------------------------

A Conference Menu provides the following configuration options:



| Option | Values | Description | Notes |
| --- | --- | --- | --- |
| type | menu | Set this to menu to configure a conference menu |   |
| playback | (<name of audio file1>&<name of audio file2>&...) | Plays back an audio file, or a string of audio files chained together using the & character, to the user and then immediately returns them to the conference. |   |
| playback\_and\_continue | (<name of audio file 1>&<name of audio file 2>&...) | Plays back an audio file, or a series of audio files chained together using the & character, to the user while continuing the collect the DTMF sequence. This is useful when using a menu prompt that describes all of the menu options. Note that any DTMF during this action will terminate the prompt's playback. |   |
| toggle\_mute |   | Toggles mute on and off. When a user is muted, they will not be able to speak to other conference users, but they can still listen to other users. While muted, DTMF keys from the caller will continue to be collected. |   |
| no\_op |   | This action does nothing. Its only real purpose exists for being able to reserve a sequence in the configuration as a menu exit sequence. |   |
| decrease\_listening\_volume |   | Decreases the caller's listening volume. Everything they hear will sound quieter. |   |
| increase\_listening\_volume |   | Increases the caller's listening volume. Everything they hear will sound louder. |   |
| reset\_listening\_volume |   | Resets the caller's listening volume to the default level. |   |
| decrease\_talking\_volume |   | Decreases the caller's talking volume. Everything they say will sound quieter to other callers. |   |
| increase\_talking\_volume |   | Increases the caller's talking volume. Everything they say will sound louder to other callers. |   |
| reset\_talking\_volume |   | Resets the caller's talking volume to the default level. |   |
| dialplan\_exec | (context,exten,priority) | Allows one to escape from the conference and execute commands in the dialplan. Once the dialplan exits, the user will be put back into the conference. |   |
| leave\_conference |   | Allows a user to exit the conference and continue execution in the dialplan. |   |
| admin\_kick\_last |   | Allows an Admin to remove the last participant from the conference. This action only works for users whose User Profiles set them as conference Admins. |   |
| admin\_toggle\_conference\_lock |   | Allows an Admin to toggle locking and unlocking the conference. When the conference is locked, only other Admin users can join. When the conference is unlocked, any user may join up to the limit defined by the max\_members Bridge Profile option. This action only works for users whose User Profiles set them as conference Admins. |   |
| admin\_toggle\_mute\_participants |   | Allows an Admin to mute/unmute all non-admin participants in the conference. | **New in Asterisk 11** |
| set\_as\_single\_video\_src |   | Allows a user to set themselves as the single video distribution source for all other participants. This overrides the video\_mode setting. |   |
| release\_as\_single\_video\_src |   | Allows a user to release themselves as the single video source. Upon release of the video source, and/or if video\_mode is set to "none," this action will result in the conference returning to whatever video mode the Bridge Profile is using. This action will have no effect if the user is not currently the video source. The user is also not guaranteed that the use of this action will prevent them from becoming the video source later. |   |
| participant\_count |   | Plays back the current number of participants into the conference. | **New in Asterisk 11** |

**Example**  





---

  
  


```

[fancymenu]
type=menu
\*=playback\_and\_continue(conf-togglemute&press&digits/1&silence/1&conf-leave&press&digits/2&silence/1&add-a-caller&press&digits/3&silence/1&conf-decrease-talking&press&digits/4&silence/1&reset-talking&press&digits/5&silence/1&increase-talking&press&digits/6&silence/1&conf-decrease-listening&press&digits/7&silence/1&conf-reset-listening&press&digits/8&silence/1&conf-increase-listening&press&digits/9&silence/1&conf-exit-menu&press&digits/0)
\*1=toggle\_mute
1=toggle\_mute
\*2=leave\_conference
2=leave\_conference
\*3=dialplan\_exec(addcallers,1,1)
3=dialplan\_exec(addcallers,1,1)
\*4=decrease\_listening\_volume
4=decrease\_listening\_volume
\*5=reset\_listening\_volume
5=reset\_listening\_volume
\*6=increase\_listening\_volume
6=increase\_listening\_volume
\*7=decrease\_talking\_volume
7=decrease\_talking\_volume
\*8=reset\_talking\_volume
8=reset\_talking\_volume
\*9=increase\_talking\_volume
9=increase\_talking\_volume
\*0=no\_op
0=no\_op


```


Of particular note in this example, we're calling the dialplan\_exec option. Here, we're specifying "addcaller,1,1." This means that when someone dials 3, Asterisk will escape them out of the bridge momentarily to go execute priority 1 of extension 1 in the addcaller context of the dialplan (extensions.conf). Our dialplan, including the addcaller context, in this case, might look like:




---

  
  


```

[addcaller]
exten => 1,1,Originate(SIP/otherpeer,exten,conferences,100,1)

[conferences]
exten => 100,1,ConfBridge(1234)


```


Thus, when someone dials "3" while in the bridge, they'll Originate a call from the dialplan that puts SIP/otherpeer into the conference. Once the dial has completed, the person that dialed "3" will find themselves back in the bridge, with the other participants.

