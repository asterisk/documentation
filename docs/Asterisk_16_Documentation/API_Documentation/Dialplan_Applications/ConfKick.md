---
search:
  boost: 0.5
title: ConfKick
---

# ConfKick()

### Synopsis

Kicks channel(s) from the requested ConfBridge.

### Since

16.19.0, 18.5.0, 19.0.0

### Description

Kicks the requested channel(s) from a conference bridge.<br>


* `CONFKICKSTATUS`

    * `FAILURE` - Could not kick any users with the provided arguments.

    * `SUCCESS` - Successfully kicked users from specified conference bridge.

### Syntax


```

ConfKick(conference,[channel])
```
##### Arguments


* `conference`

* `channel` - The channel to kick, 'all' to kick all users, or 'participants' to kick all non-admin participants. Default is all.<br>

### See Also

* [Dialplan Applications ConfBridge](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/ConfBridge)
* [Dialplan Functions CONFBRIDGE](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/CONFBRIDGE)
* [Dialplan Functions CONFBRIDGE_INFO](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/CONFBRIDGE_INFO)
* [Dialplan Functions CONFBRIDGE_CHANNELS](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/CONFBRIDGE_CHANNELS)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 