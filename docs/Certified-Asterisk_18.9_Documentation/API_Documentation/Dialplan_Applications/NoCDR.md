---
search:
  boost: 0.5
title: NoCDR
---

# NoCDR()

### Synopsis

Tell Asterisk to not maintain a CDR for this channel.

### Description

This application will tell Asterisk not to maintain a CDR for the current channel. This does *NOT* mean that information is not tracked; rather, if the channel is hung up no CDRs will be created for that channel.<br>

If a subsequent call to ResetCDR occurs, all non-finalized CDRs created for the channel will be enabled.<br>


/// note
This application is deprecated. Please use the CDR\_PROP function to disable CDRs on a channel.
///


### Syntax


```

NoCDR()
```
##### Arguments

### See Also

* [Dialplan Applications ResetCDR](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/ResetCDR)
* [Dialplan Functions CDR_PROP](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/CDR_PROP)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 