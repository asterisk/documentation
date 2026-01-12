---
search:
  boost: 0.5
title: DAHDIRAS
---

# DAHDIRAS()

### Synopsis

Executes DAHDI ISDN RAS application.

### Description

Executes a RAS server using pppd on the given channel. The channel must be a clear channel (i.e. PRI source) and a DAHDI channel to be able to use this function (No modem emulation is included).<br>

Your pppd must be patched to be DAHDI aware.<br>


### Syntax


```

DAHDIRAS(args)
```
##### Arguments


* `args` - A list of parameters to pass to the pppd daemon, separated by ',' characters.<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 