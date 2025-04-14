---
title: Exploring Sound Prompts
pageid: 4817435
---

Asterisk comes with a wide variety of pre-recorded sound prompts. When you install Asterisk, you can choose to install both core and extra sound packages in several different file formats. Prompts are also available in several languages. To explore the sound files on your system, simply find the sounds directory (this will be  */var/lib/asterisk/sounds** on most systems) and look at the filenames. You'll find useful prompts ("Please enter the extension of the person you are looking for..."), as well as as a number of off-the-wall prompts (such as "Weasels have eaten our phone system", "The office has been overrun with iguanas", and "Try to spend your time on hold not thinking about a blue-eyed polar bear") as well.

!!! tip Sound Prompt Formats
    Sound prompts come in a variety of file formats, such as **.wav** and **.ulaw** files. When asked to play a sound prompt from disk, Asterisk plays the sound prompt with the file format that can most easily be converted to the CODEC of the current call. For example, if the inbound call is using the **alaw** CODEC and the sound prompt is available in **.gsm** and **.ulaw** format, Asterisk will play the **.ulaw** file because it requires fewer CPU cycles to transcode to the **alaw CODEC.
     You can type the command **core show translation** at the Asterisk CLI to see the transcoding times for various CODECs. The times reported (in Asterisk 1.6.0 and later releases) are the number of microseconds it takes Asterisk to transcode one second worth of audio. These times are calculated when Asterisk loads the codec modules, and often vary slightly from machine to machine.  To perform a current calculation of translation times, you can type the command **core show translation recalc 60**.

[//]: # (end-tip)
