---
search:
  boost: 0.5
title: ControlPlayback
---

# ControlPlayback

### Synopsis

Control the playback of a file being played to a channel.

### Description

Control the operation of a media file being played back to a channel. Note that this AMI action does not initiate playback of media to channel, but rather controls the operation of a media operation that was already initiated on the channel.<br>


/// note
The 'pause' and 'restart' _Control_ options will stop a playback operation if that operation was not initiated from the _ControlPlayback_ application or the _control stream file_ AGI command.
///


### Syntax


```


    Action: ControlPlayback
    ActionID: <value>
    Channel: <value>
    Control: <value>

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Channel` - The name of the channel that currently has a file being played back to it.<br>

* `Control`

    * `stop` - Stop the playback operation.<br>

    * `forward` - Move the current position in the media forward. The amount of time that the stream moves forward is determined by the _skipms_ value passed to the application that initiated the playback.<br>

        /// note
The default skipms value is '3000' ms.
///


    * `reverse` - Move the current position in the media backward. The amount of time that the stream moves backward is determined by the _skipms_ value passed to the application that initiated the playback.<br>

        /// note
The default skipms value is '3000' ms.
///


    * `pause` - Pause/unpause the playback operation, if supported. If not supported, stop the playback.<br>

    * `restart` - Restart the playback operation, if supported. If not supported, stop the playback.<br>

### See Also

* [Dialplan Applications Playback](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/Playback)
* [Dialplan Applications ControlPlayback](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/ControlPlayback)
* [AGI Commands stream_file](/Asterisk_16_Documentation/API_Documentation/AGI_Commands/stream_file)
* [AGI Commands control_stream_file](/Asterisk_16_Documentation/API_Documentation/AGI_Commands/control_stream_file)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 