---
search:
  boost: 0.5
title: ConfKick
---

# ConfKick()

### Synopsis

Kicks channel(s) from the requested ConfBridge.

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

* [Dialplan Applications ConfBridge](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/ConfBridge)
* [Dialplan Functions CONFBRIDGE](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/CONFBRIDGE)
* [Dialplan Functions CONFBRIDGE_INFO](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/CONFBRIDGE_INFO)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 