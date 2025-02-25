---
search:
  boost: 0.5
title: ForkCDR
---

# ForkCDR()

### Synopsis

Forks the current Call Data Record for this channel.

### Description

Causes the Call Data Record engine to fork a new CDR starting from the time the application is executed. The forked CDR will be linked to the end of the CDRs associated with the channel.<br>


### Syntax


```

ForkCDR([options])
```
##### Arguments


* `options`

    * `a` - If the channel is answered, set the answer time on the forked CDR to the current time. If this option is not used, the answer time on the forked CDR will be the answer time on the original CDR. If the channel is not answered, this option has no effect.<br>
Note that this option is implicitly assumed if the 'r' option is used.<br>


    * `e` - End (finalize) the original CDR.<br>


    * `r` - Reset the start and answer times on the forked CDR. This will set the start and answer times (if the channel is answered) to be set to the current time.<br>
Note that this option implicitly assumes the 'a' option.<br>


    * `v` - Do not copy CDR variables and attributes from the original CDR to the forked CDR.<br>


### See Also

* [Dialplan Functions CDR](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/CDR)
* [Dialplan Applications NoCDR](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/NoCDR)
* [Dialplan Applications ResetCDR](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/ResetCDR)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 