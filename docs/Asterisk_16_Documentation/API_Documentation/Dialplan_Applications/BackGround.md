---
search:
  boost: 0.5
title: BackGround
---

# BackGround()

### Synopsis

Play an audio file while waiting for digits of an extension to go to.

### Description

This application will play the given list of files *(do not put extension)* while waiting for an extension to be dialed by the calling channel. To continue waiting for digits after this application has finished playing files, the 'WaitExten' application should be used.<br>

If one of the requested sound files does not exist, call processing will be terminated.<br>

This application sets the following channel variable upon completion:<br>


* `BACKGROUNDSTATUS` - The status of the background attempt as a text string.<br>

    * `SUCCESS`

    * `FAILED`

### Syntax


```

BackGround(filename1&[filename2[&...]],[options,[langoverride,[context]]])
```
##### Arguments


* `filenames`

    * `filename1` **required**

    * `filename2[,filename2...]`

* `options`

    * `s` - Causes the playback of the message to be skipped if the channel is not in the 'up' state (i.e. it hasn't been answered yet). If this happens, the application will return immediately.<br>


    * `n` - Don't answer the channel before playing the files.<br>


    * `m` - Only break if a digit hit matches a one digit extension in the destination context.<br>


    * `p` - Do not allow playback to be interrupted with digits.<br>


* `langoverride` - Explicitly specifies which language to attempt to use for the requested sound files.<br>

* `context` - This is the dialplan context that this application will use when exiting to a dialed extension.<br>

### See Also

* [Dialplan Applications ControlPlayback](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/ControlPlayback)
* [Dialplan Applications WaitExten](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/WaitExten)
* [Dialplan Applications BackgroundDetect](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/BackgroundDetect)
* [Dialplan Functions TIMEOUT](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/TIMEOUT)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 