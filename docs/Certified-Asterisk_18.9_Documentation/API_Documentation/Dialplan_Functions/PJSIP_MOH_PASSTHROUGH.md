---
search:
  boost: 0.5
title: PJSIP_MOH_PASSTHROUGH
---

# PJSIP_MOH_PASSTHROUGH()

### Synopsis

Get or change the on-hold behavior for a SIP call.

### Description

When read, returns the current moh passthrough mode<br>

When written, sets the current moh passthrough mode<br>

If _yes_, on-hold re-INVITEs are sent. If _no_, music on hold is generated.<br>

This function can be used to override the moh\_passthrough configuration option<br>


### Syntax


```

PJSIP_MOH_PASSTHROUGH()
```
##### Arguments


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 