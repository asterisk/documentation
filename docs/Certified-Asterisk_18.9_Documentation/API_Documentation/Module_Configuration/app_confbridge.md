---
search:
  boost: 0.5
title: app_confbridge
---

# app_confbridge: Conference Bridge Application

This configuration documentation is for functionality provided by app_confbridge.

## Configuration File: confbridge.conf

### [global]: Unused, but reserved.



### [user_profile]: A named profile to apply to specific callers.

Callers in a ConfBridge have a profile associated with them that determine their options. A configuration section is determined to be a user\_profile when the 'type' parameter has a value of 'user'.<br>


#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| admin| Boolean| no| false| Sets if the user is an admin or not| |
| announce_join_leave| Boolean| no| false| Prompt user for their name when joining a conference and play it to the conference when they enter| |
| announce_join_leave_review| Boolean| no| false| Prompt user for their name when joining a conference and play it to the conference when they enter. The user will be asked to review the recording of their name before entering the conference.| |
| announce_only_user| Boolean| yes| false| Announce to a user when they join an empty conference| |
| announce_user_count| Boolean| no| false| Sets if the number of users should be announced to the user| |
| [announce_user_count_all](#announce_user_count_all)| Custom| no| false| Announce user count to all the other users when this user joins| |
| announcement| String| | false| Sound file to play to the user when they join a conference| |
| answer_channel| Boolean| yes| false| Sets if a user's channel should be answered if currently unanswered.| |
| [denoise](#denoise)| Boolean| no| false| Apply a denoise filter to the audio before mixing| |
| [dsp_drop_silence](#dsp_drop_silence)| Boolean| no| false| Drop what Asterisk detects as silence from audio sent to the bridge| |
| [dsp_silence_threshold](#dsp_silence_threshold)| Unsigned Integer| 2500| false| The number of milliseconds of silence necessary to declare talking stopped.| |
| [dsp_talking_threshold](#dsp_talking_threshold)| Unsigned Integer| 160| false| Average magnitude threshold to determine talking.| |
| dtmf_passthrough| Boolean| no| false| Sets whether or not DTMF should pass through the conference| |
| [echo_events](#echo_events)| Boolean| no| false| Sets if events are echoed back to the user that triggered them| |
| end_marked| Boolean| no| false| Kick the user from the conference when the last marked user leaves| |
| [jitterbuffer](#jitterbuffer)| Boolean| no| false| Place a jitter buffer on the user's audio stream before audio mixing is performed| |
| marked| Boolean| no| false| Sets if this is a marked user or not| |
| music_on_hold_class| String| | false| The MOH class to use for this user| |
| music_on_hold_when_empty| Boolean| no| false| Play MOH when user is alone or waiting on a marked user| |
| pin| String| | false| Sets a PIN the user must enter before joining the conference| |
| quiet| Boolean| no| false| Silence enter/leave prompts and user intros for this user| |
| [send_events](#send_events)| Boolean| no| false| Sets if events are send to the user| |
| startmuted| Boolean| no| false| Sets if all users should start out muted| |
| talk_detection_events| Boolean| no| false| Set whether or not notifications of when a user begins and ends talking should be sent out as events over AMI| |
| template| Custom| | false| When using the CONFBRIDGE dialplan function, use a user profile as a template for creating a new temporary profile| |
| [text_messaging](#text_messaging)| Boolean| yes| false| Sets if text messages are sent to the user.| |
| timeout| Unsigned Integer| 0| false| Kick the user out of the conference after this many seconds. 0 means there is no timeout for the user.| |
| [type](#type)| None| | false| Define this configuration category as a user profile.| |
| wait_marked| Boolean| no| false| Sets if the user must wait for a marked user to enter before joining a conference| |


#### Configuration Option Descriptions

##### announce_user_count_all

Sets if the number of users should be announced to all the other users in the conference when this user joins. This option can be either set to 'yes' or a number. When set to a number, the announcement will only occur once the user count is above the specified number.<br>


##### denoise

Sets whether or not a denoise filter should be applied to the audio before mixing or not. Off by default. Requires 'codec\_speex' to be built and installed. Do not confuse this option with _drop\_silence_. Denoise is useful if there is a lot of background noise for a user as it attempts to remove the noise while preserving the speech. This option does NOT remove silence from being mixed into the conference and does come at the cost of a slight performance hit.<br>


##### dsp_drop_silence

This option drops what Asterisk detects as silence from entering into the bridge. Enabling this option will drastically improve performance and help remove the buildup of background noise from the conference. Highly recommended for large conferences due to its performance enhancements.<br>


##### dsp_silence_threshold

The time in milliseconds of sound falling below the _dsp\_talking\_threshold_ option when a user is considered to stop talking. This value affects several operations and should not be changed unless the impact on call quality is fully understood.<br>

What this value affects internally:<br>

1. When talk detection AMI events are enabled, this value determines when the user has stopped talking after a period of talking. If this value is set too low AMI events indicating the user has stopped talking may get falsely sent out when the user briefly pauses during mid sentence.<br>

2. The _drop\_silence_ option depends on this value to determine when the user's audio should begin to be dropped from the conference bridge after the user stops talking. If this value is set too low the user's audio stream may sound choppy to the other participants. This is caused by the user transitioning constantly from silence to talking during mid sentence.<br>

The best way to approach this option is to set it slightly above the maximum amount of milliseconds of silence a user may generate during natural speech.<br>

Valid values are 1 through 2\^31.<br>


##### dsp_talking_threshold

The minimum average magnitude per sample in a frame for the DSP to consider talking/noise present. A value below this level is considered silence. This value affects several operations and should not be changed unless the impact on call quality is fully understood.<br>

What this value affects internally:<br>

1. Audio is only mixed out of a user's incoming audio stream if talking is detected. If this value is set too high the user will hear himself talking.<br>

2. When talk detection AMI events are enabled, this value determines when talking has begun which results in an AMI event to fire. If this value is set too low AMI events may be falsely triggered by variants in room noise.<br>

3. The _drop\_silence_ option depends on this value to determine when the user's audio should be mixed into the bridge after periods of silence. If this value is too high the user's speech will get discarded as they will be considered silent.<br>

Valid values are 1 through 2\^15.<br>


##### echo_events

If events are enabled for this user and this option is set, the user will receive events they trigger, talking, mute, etc. If not set, they will not receive their own events.<br>


##### jitterbuffer

Enabling this option places a jitterbuffer on the user's audio stream before audio mixing is performed. This is highly recommended but will add a slight delay to the audio. This option is using the 'JITTERBUFFER' dialplan function's default adaptive jitterbuffer. For a more fine tuned jitterbuffer, disable this option and use the 'JITTERBUFFER' dialplan function on the user before entering the ConfBridge application.<br>


##### send_events

If events are enabled for this bridge and this option is set, users will receive events like join, leave, talking, etc. via text messages. For users accessing the bridge via chan\_pjsip, this means in-dialog MESSAGE messages. This is most useful for WebRTC participants where the browser application can use the messages to alter the user interface.<br>


##### text_messaging

If text messaging is enabled for this user then text messages will be sent to it. These may be events or from other participants in the conference bridge. If disabled then no text messages are sent to the user.<br>


##### type

The type parameter determines how a context in the configuration file is interpreted.<br>


* `user` - Configure the context as a _user\_profile_<br>

* `bridge` - Configure the context as a _bridge\_profile_<br>

* `menu` - Configure the context as a _menu_<br>

### [bridge_profile]: A named profile to apply to specific bridges.

ConfBridge bridges have a profile associated with them that determine their options. A configuration section is determined to be a 'bridge\_profile' when the 'type' parameter has a value of 'bridge'.<br>


#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| [binaural_active](#binaural_active)| Boolean| no| false| If true binaural conferencing with stereo audio is active| |
| [enable_events](#enable_events)| Boolean| no| false| Enables events for this bridge| |
| [internal_sample_rate](#internal_sample_rate)| Unsigned Integer| 0| false| Set the internal native sample rate for mixing the conference| |
| jitterbuffer| Boolean| no| false| Place a jitter buffer on the conference's audio stream| |
| [language](#language)| String| en| false| The language used for announcements to the conference.| |
| [max_members](#max_members)| Unsigned Integer| 0| false| Limit the maximum number of participants for a single conference| |
| [maximum_sample_rate](#maximum_sample_rate)| Unsigned Integer| 0| false| Set the maximum native sample rate for mixing the conference| |
| [mixing_interval](#mixing_interval)| Custom| 20| false| Sets the internal mixing interval in milliseconds for the bridge| |
| [record_command](#record_command)| String| | false| Execute a command after recording ends| |
| [record_conference](#record_conference)| Boolean| no| false| Record the conference starting with the first active user's entrance and ending with the last active user's exit| |
| [record_file](#record_file)| String| confbridge-name of conference bridge-start time.wav| false| The filename of the conference recording| |
| [record_file_append](#record_file_append)| Boolean| yes| false| Append to record file when starting/stopping on same conference recording| |
| [record_file_timestamp](#record_file_timestamp)| Boolean| yes| false| Append the start time to the record_file name so that it is unique.| |
| [record_options](#record_options)| String| | false| Pass additional options to MixMonitor when recording| |
| [regcontext](#regcontext)| String| | false| The name of the context into which to register the name of the conference bridge as NoOP() at priority 1| |
| [remb_behavior](#remb_behavior)| Custom| average| false| Sets how REMB reports are generated from multiple sources| |
| [remb_estimated_bitrate](#remb_estimated_bitrate)| Unsigned Integer| 0| false| Sets the estimated bitrate sent to each participant in REMB reports| |
| [remb_send_interval](#remb_send_interval)| Unsigned Integer| 0| false| Sets the interval in milliseconds that a combined REMB frame will be sent to video sources| |
| [sound_](#sound_)| Custom| | false| Override the various conference bridge sound files| |
| template| Custom| | false| When using the CONFBRIDGE dialplan function, use a bridge profile as a template for creating a new temporary profile| |
| [type](#type)| None| | false| Define this configuration category as a bridge profile| |
| [video_mode](#video_mode)| Custom| | false| Sets how confbridge handles video distribution to the conference participants| |
| [video_update_discard](#video_update_discard)| Unsigned Integer| 2000| false| Sets the amount of time in milliseconds after sending a video update to discard subsequent video updates| |


#### Configuration Option Descriptions

##### binaural_active

Activates binaural mixing for a conference bridge. Binaural features are disabled by default.<br>


##### enable_events

If enabled, recipients who joined the bridge via a channel driver that supports Enhanced Messaging (currently only chan\_pjsip) will receive in-dialog messages containing a JSON body describing the event. The Content-Type header will be 'text/x-ast-confbridge-event'. This feature must also be enabled in user profiles.<br>


##### internal_sample_rate

Sets the internal native sample rate the conference is mixed at. This is set to automatically adjust the sample rate to the best quality by default. Other values can be anything from 8000-192000. If a sample rate is set that Asterisk does not support, the closest sample rate Asterisk does support to the one requested will be used.<br>


##### language

By default, announcements to a conference use English. Which means the prompts played to all users within the conference will be English. By changing the language of a bridge, this will change the language of the prompts played to all users.<br>


##### max_members

This option limits the number of participants for a single conference to a specific number. By default conferences have no participant limit. After the limit is reached, the conference will be locked until someone leaves. Note however that an Admin user will always be alowed to join the conference regardless if this limit is reached or not.<br>


##### maximum_sample_rate

Sets the maximum native sample rate the conference is mixed at. This is set to not have a maximum by default. If a sample rate is specified, though, the native sample rate will never exceed it.<br>


##### mixing_interval

Sets the internal mixing interval in milliseconds for the bridge. This number reflects how tight or loose the mixing will be for the conference. In order to improve performance a larger mixing interval such as 40ms may be chosen. Using a larger mixing interval comes at the cost of introducing larger amounts of delay into the bridge. Valid values here are 10, 20, 40, or 80.<br>


##### record_command

Executes the specified command when recording ends. Any strings matching '\^\{X\}' will be unescaped to **X**. All variables will be evaluated at the time ConfBridge is called.<br>


##### record_conference

Records the conference call starting when the first user enters the room, and ending when the last user exits the room. The default recorded filename is *'confbridge-$\{name of conference bridge\}-$\{start time\}.wav'* and the default format is 8khz slinear. This file will be located in the configured monitoring directory in *asterisk.conf*.<br>


##### record_file

When _record\_conference_ is set to yes, the specific name of the record file can be set using this option. Note that since multiple conferences may use the same bridge profile, this may cause issues depending on the configuration. It is recommended to only use this option dynamically with the 'CONFBRIDGE()' dialplan function. This allows the record name to be specified and a unique name to be chosen. By default, the record\_file is stored in Asterisk's spool/monitor directory with a unique filename starting with the 'confbridge' prefix.<br>


##### record_file_append

When _record\_file\_append_ is set to yes, stopping and starting recording on a conference adds the new portion to end of current record\_file. When this is set to no, a new _record\_file_ is generated every time you start then stop recording on a conference.<br>


##### record_file_timestamp

When _record\_file\_timestamp_ is set to yes, the start time is appended to _record\_file_ so that the filename is unique. This allows you to specify a _record\_file_ but not overwrite existing recordings.<br>


##### record_options

Pass additional options to MixMonitor when _record\_conference_ is set to yes. See 'MixMonitor' for available options.<br>


##### regcontext

When set this will cause the name of the created conference to be registered into the named context at priority 1 with an operation of NoOP(). This can then be used in other parts of the dialplan to test for the existence of a specific conference bridge. You should be aware that there are potential races between testing for the existence of a bridge, and taking action upon that information, consider for example two callers executing the check simultaneously, and then taking special action as "first caller" into the bridge. The same for exiting, directly after the check the bridge can be destroyed before the new caller enters (creating a new bridge), for example, and the "first member" actions could thus be missed.<br>


##### remb_behavior

Sets how REMB reports are combined from multiple sources to form one. A REMB report consists of information about the receiver estimated maximum bitrate. As a source stream may be forwarded to multiple receivers the reports must be combined into a single one which is sent to the sender.<br>


* `average` - The average of all estimated maximum bitrates is taken and sent to the sender.<br>

* `lowest` - The lowest estimated maximum bitrate is forwarded to the sender.<br>

* `highest` - The highest estimated maximum bitrate is forwarded to the sender.<br>

* `average_all` - The average of all estimated maximum bitrates is taken from all receivers in the bridge and a single value is sent to each sender.<br>

* `lowest_all` - The lowest estimated maximum bitrate of all receivers in the bridge is taken and sent to each sender.<br>

* `highest_all` - The highest estimated maximum bitrate of all receivers in the bridge is taken and sent to each sender.<br>

* `force` - The bitrate configured in 'remb\_estimated\_bitrate' is sent to each sender.<br>

##### remb_estimated_bitrate

When 'remb\_behavior' is set to 'force', this options sets the estimated bitrate (in bits per second) sent to each participant in REMB reports.<br>


##### remb_send_interval

Sets the interval in milliseconds that a combined REMB frame will be sent to video sources. This is done by taking all REMB frames that have been received since the last REMB frame was sent, making a combined value, and sending it to the source. A REMB frame contains receiver estimated maximum bitrate information. By creating a combined REMB frame the sender of video can be influenced on the bitrate they choose, allowing better quality for all receivers.<br>


##### sound_

All sounds in the conference are customizable using the bridge profile options below. Simply state the option followed by the filename or full path of the filename after the option. Example: 'sound\_had\_joined=conf-hasjoin' This will play the 'conf-hasjoin' sound file found in the sounds directory when announcing someone's name is joining the conference.<br>


* `sound_join` - The sound played to everyone when someone enters the conference.<br>

* `sound_leave` - The sound played to everyone when someone leaves the conference.<br>

* `sound_has_joined` - The sound played before announcing someone's name has joined the conference. This is used for user intros. Example '"\_\_\_\_\_ has joined the conference"'<br>

* `sound_has_left` - The sound played when announcing someone's name has left the conference. This is used for user intros. Example '"\_\_\_\_\_ has left the conference"'<br>

* `sound_kicked` - The sound played to a user who has been kicked from the conference.<br>

* `sound_muted` - The sound played when the mute option it toggled on.<br>

* `sound_unmuted` - The sound played when the mute option it toggled off.<br>

* `sound_binaural_on` - The sound played when binaural audio is turned on.<br>

* `sound_binaural_off` - The sound played when the binaural audio is turned off.<br>

* `sound_only_person` - The sound played when the user is the only person in the conference.<br>

* `sound_only_one` - The sound played to a user when there is only one other person is in the conference.<br>

* `sound_there_are` - The sound played when announcing how many users there are in a conference.<br>

* `sound_other_in_party` - This file is used in conjunction with 'sound\_there\_are' when announcing how many users there are in the conference. The sounds are stringed together like this. '"sound\_there\_are" $\{number of participants\} "sound\_other\_in\_party"'<br>

* `sound_place_into_conference` - The sound played when someone is placed into the conference after waiting for a marked user.<br>

* `sound_wait_for_leader` - The sound played when a user is placed into a conference that can not start until a marked user enters.<br>

* `sound_leader_has_left` - The sound played when the last marked user leaves the conference.<br>

* `sound_get_pin` - The sound played when prompting for a conference pin number.<br>

* `sound_invalid_pin` - The sound played when an invalid pin is entered too many times.<br>

* `sound_locked` - The sound played to a user trying to join a locked conference.<br>

* `sound_locked_now` - The sound played to an admin after toggling the conference to locked mode.<br>

* `sound_unlocked_now` - The sound played to an admin after toggling the conference to unlocked mode.<br>

* `sound_error_menu` - The sound played when an invalid menu option is entered.<br>

##### type

The type parameter determines how a context in the configuration file is interpreted.<br>


* `user` - Configure the context as a _user\_profile_<br>

* `bridge` - Configure the context as a _bridge\_profile_<br>

* `menu` - Configure the context as a _menu_<br>

##### video_mode

Sets how confbridge handles video distribution to the conference participants. Note that participants wanting to view and be the source of a video feed *MUST* be sharing the same video codec. Also, using video in conjunction with with the jitterbuffer currently results in the audio being slightly out of sync with the video. This is a result of the jitterbuffer only working on the audio stream. It is recommended to disable the jitterbuffer when video is used.<br>


* `none` - No video sources are set by default in the conference. It is still possible for a user to be set as a video source via AMI or DTMF action at any time.<br>

* `follow_talker` - The video feed will follow whoever is talking and providing video.<br>

* `last_marked` - The last marked user to join the conference with video capabilities will be the single source of video distributed to all participants. If multiple marked users are capable of video, the last one to join is always the source, when that user leaves it goes to the one who joined before them.<br>

* `first_marked` - The first marked user to join the conference with video capabilities is the single source of video distribution among all participants. If that user leaves, the marked user to join after them becomes the source.<br>

* `sfu` - Selective Forwarding Unit - Sets multi-stream operation for a multi-party video conference.<br>

##### video_update_discard

Sets the amount of time in milliseconds after sending a video update request that subsequent video updates should be discarded. This means that if we send a video update we will discard any other video update requests until after the configured amount of time has elapsed. This prevents flooding of video update requests from clients.<br>


### [menu]: A conference user menu

Conference users, as defined by a _conf\_user_, can have a DTMF menu assigned to their profile when they enter the 'ConfBridge' application.<br>


#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| [0-9A-D*#](#0-9A-D*#)| Custom| | true| DTMF sequences to assign various confbridge actions to| |
| template| Custom| | false| When using the CONFBRIDGE dialplan function, use a menu profile as a template for creating a new temporary profile| |
| [type](#type)| None| | false| Define this configuration category as a menu| |


#### Configuration Option Descriptions

##### 0-9A-D*#

The ConfBridge application also has the ability to apply custom DTMF menus to each channel using the application. Like the User and Bridge profiles a menu is passed in to ConfBridge as an argument in the dialplan.<br>

Below is a list of menu actions that can be assigned to a DTMF sequence.<br>


/// note
To have the first DTMF digit in a sequence be the '#' character, you need to escape it. If it is not escaped then normal config file processing will think it is a directive like #include. For example: The mute setting is toggled when '#1' is pressed. \#1=toggle_mute
///


/// note
A single DTMF sequence can have multiple actions associated with it. This is accomplished by stringing the actions together and using a ',' as the delimiter. Example: Both listening and talking volume is reset when '5' is pressed. '5=reset\_talking\_volume, reset\_listening\_volume'
///


* `playback(filename&filename2&...)` - 'playback' will play back an audio file to a channel and then immediately return to the conference. This file can not be interupted by DTMF. Multiple files can be chained together using the '&' character.<br>

* `playback_and_continue(filename&filename2&...)` - 'playback\_and\_continue' will play back a prompt while continuing to collect the dtmf sequence. This is useful when using a menu prompt that describes all the menu options. Note however that any DTMF during this action will terminate the prompts playback. Prompt files can be chained together using the '&' character as a delimiter.<br>

* `toggle_mute` - Toggle turning on and off mute. Mute will make the user silent to everyone else, but the user will still be able to listen in.<br>

* `toggle_binaural` - Toggle turning on and off binaural audio processing.<br>

* `no_op` - This action does nothing (No Operation). Its only real purpose exists for being able to reserve a sequence in the config as a menu exit sequence.<br>

* `decrease_listening_volume` - Decreases the channel's listening volume.<br>

* `increase_listening_volume` - Increases the channel's listening volume.<br>

* `reset_listening_volume` - Reset channel's listening volume to default level.<br>

* `decrease_talking_volume` - Decreases the channel's talking volume.<br>

* `increase_talking_volume` - Increases the channel's talking volume.<br>

* `reset_talking_volume` - Reset channel's talking volume to default level.<br>

* `dialplan_exec(context,exten,priority)` - The 'dialplan\_exec' action allows a user to escape from the conference and execute commands in the dialplan. Once the dialplan exits the user will be put back into the conference. The possibilities are endless!<br>

* `leave_conference` - This action allows a user to exit the conference and continue execution in the dialplan.<br>

* `admin_kick_last` - This action allows an Admin to kick the last participant from the conference. This action will only work for admins which allows a single menu to be used for both users and admins.<br>

* `admin_toggle_conference_lock` - This action allows an Admin to toggle locking and unlocking the conference. Non admins can not use this action even if it is in their menu.<br>

* `set_as_single_video_src` - This action allows any user to set themselves as the single video source distributed to all participants. This will make the video feed stick to them regardless of what the 'video\_mode' is set to.<br>

* `release_as_single_video_src` - This action allows a user to release themselves as the video source. If 'video\_mode' is not set to 'none' this action will result in the conference returning to whatever video mode the bridge profile is using.<br>
Note that this action will have no effect if the user is not currently the video source. Also, the user is not guaranteed by using this action that they will not become the video source again. The bridge will return to whatever operation the 'video\_mode' option is set to upon release of the video src.<br>

* `admin_toggle_mute_participants` - This action allows an administrator to toggle the mute state for all non-admins within a conference. All admin users are unaffected by this option. Note that all users, regardless of their admin status, are notified that the conference is muted.<br>

* `participant_count` - This action plays back the number of participants currently in a conference<br>

##### type

The type parameter determines how a context in the configuration file is interpreted.<br>


* `user` - Configure the context as a _user\_profile_<br>

* `bridge` - Configure the context as a _bridge\_profile_<br>

* `menu` - Configure the context as a _menu_<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 