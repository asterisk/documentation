---
search:
  boost: 0.5
title: MixMonitor
---

# MixMonitor()

### Synopsis

Record a call and mix the audio during the recording. Use of StopMixMonitor is required to guarantee the audio file is available for processing during dialplan execution.

### Description

Records the audio on the current channel to the specified file.<br>

This application does not automatically answer and should be preceeded by an application such as Answer or Progress().<br>


/// note
MixMonitor runs as an audiohook.
///


/// note
If a filename passed to MixMonitor ends with '.wav49', Asterisk will silently convert the extension to '.WAV' for legacy reasons. **MIXMONITOR\_FILENAME** will contain the actual filename that Asterisk is writing to, not necessarily the value that was passed in.
///


* `MIXMONITOR_FILENAME` - Will contain the filename used to record.<br>

/// warning
Do not use untrusted strings such as **CALLERID(num)** or **CALLERID(name)** as part of ANY of the application's parameters. You risk a command injection attack executing arbitrary commands if the untrusted strings aren't filtered to remove dangerous characters. See function **FILTER()**.
///


### Syntax


```

MixMonitor(filename.extension,[options,[command]])
```
##### Arguments


* `file`

    * `filename` **required** - If _filename_ is an absolute path, uses that path, otherwise creates the file in the configured monitoring directory from *asterisk.conf.*<br>

    * `extension` **required**

* `options`

    * `a` - Append to the file instead of overwriting it.<br>


    * `b` - Only save audio to the file while the channel is bridged.<br>


    * `B(interval)` - Play a periodic beep while this call is being recorded.<br>

        * `interval` - Interval, in seconds. Default is 15.<br>


    * `v(x)` - Adjust the *heard* volume by a factor of _x_ (range '-4' to '4')<br>

        * `x` **required**


    * `V(x)` - Adjust the *spoken* volume by a factor of _x_ (range '-4' to '4')<br>

        * `x` **required**


    * `W(x)` - Adjust both, *heard and spoken* volumes by a factor of _x_ (range '-4' to '4')<br>

        * `x` **required**


    * `r(file)` - Use the specified file to record the *receive* audio feed. Like with the basic filename argument, if an absolute path isn't given, it will create the file in the configured monitoring directory.<br>

        * `file` **required**


    * `t(file)` - Use the specified file to record the *transmit* audio feed. Like with the basic filename argument, if an absolute path isn't given, it will create the file in the configured monitoring directory.<br>

        * `file` **required**


    * `S` - When combined with the _r_ or _t_ option, inserts silence when necessary to maintain synchronization between the receive and transmit audio streams.<br>


    * `i(chanvar)` - Stores the MixMonitor's ID on this channel variable.<br>

        * `chanvar` **required**


    * `p` - Play a beep on the channel that starts the recording.<br>


    * `P` - Play a beep on the channel that stops the recording.<br>


    * `m(mailbox)` - Create a copy of the recording as a voicemail in the indicated *mailbox*(es) separated by commas eg. m(1111@default,2222@default,...). Folders can be optionally specified using the syntax: mailbox@context/folder<br>

        * `mailbox` **required**


* `command` - Will be executed when the recording is over.<br>
Any strings matching '\^\{X\}' will be unescaped to **X**.<br>
All variables will be evaluated at the time MixMonitor is called.<br>

    /// warning
Do not use untrusted strings such as **CALLERID(num)** or **CALLERID(name)** as part of the command parameters. You risk a command injection attack executing arbitrary commands if the untrusted strings aren't filtered to remove dangerous characters. See function **FILTER()**.
///


### See Also

* [Dialplan Applications Monitor](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/Monitor)
* [Dialplan Applications StopMixMonitor](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/StopMixMonitor)
* [Dialplan Applications PauseMonitor](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/PauseMonitor)
* [Dialplan Applications UnpauseMonitor](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/UnpauseMonitor)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 