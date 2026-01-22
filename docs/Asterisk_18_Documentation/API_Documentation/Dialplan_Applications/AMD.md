---
search:
  boost: 0.5
title: AMD
---

# AMD()

### Synopsis

Attempt to detect answering machines.

### Description

This application attempts to detect answering machines at the beginning of outbound calls. Simply call this application after the call has been answered (outbound only, of course).<br>

When loaded, AMD reads amd.conf and uses the parameters specified as default values. Those default values get overwritten when the calling AMD with parameters.<br>

This application sets the following channel variables:<br>


* `AMDSTATUS` - This is the status of the answering machine detection<br>

    * `MACHINE`

    * `HUMAN`

    * `NOTSURE`

    * `HANGUP`

* `AMDCAUSE` - Indicates the cause that led to the conclusion<br>

    * `TOOLONG` - Total Time.

    * `INITIALSILENCE` - Silence Duration - Initial Silence.

    * `HUMAN` - Silence Duration - afterGreetingSilence.

    * `LONGGREETING` - Voice Duration - Greeting.

    * `MAXWORDLENGTH` - Word Length - max length of a single word.

    * `MAXWORDS` - Word Count - maximum number of words.

### Syntax


```

AMD([initialSilence,[greeting,[afterGreetingSilence,[totalAnalysisTime,[miniumWordLength,[betweenWordSilence,[maximumNumberOfWords,[silenceThreshold,[maximumWordLength,[audioFile]]]]]]]]]])
```
##### Arguments


* `initialSilence` - Is maximum initial silence duration before greeting.<br>
If this is exceeded, the result is detection as a MACHINE<br>

* `greeting` - is the maximum length of a greeting.<br>
If this is exceeded, the result is detection as a MACHINE<br>

* `afterGreetingSilence` - Is the silence after detecting a greeting.<br>
If this is exceeded, the result is detection as a HUMAN<br>

* `totalAnalysisTime` - Is the maximum time allowed for the algorithm<br>
to decide on whether the audio represents a HUMAN, or a MACHINE<br>

* `miniumWordLength` - Is the minimum duration of Voice considered to be a word<br>

* `betweenWordSilence` - Is the minimum duration of silence after a word to consider the audio that follows to be a new word<br>

* `maximumNumberOfWords` - Is the maximum number of words in a greeting<br>
If this is exceeded, then the result is detection as a MACHINE<br>

* `silenceThreshold` - What is the average level of noise from 0 to 32767 which if not exceeded, should be considered silence?<br>

* `maximumWordLength` - Is the maximum duration of a word to accept.<br>
If exceeded, then the result is detection as a MACHINE<br>

* `audioFile` - Is an audio file to play to the caller while AMD is in progress.<br>
By default, no audio file is played.<br>
If an audio file is configured in amd.conf, then that file will be used if one is not specified here. That file may be overridden by this argument.<br>

### See Also

* [Dialplan Applications WaitForSilence](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/WaitForSilence)
* [Dialplan Applications WaitForNoise](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/WaitForNoise)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 