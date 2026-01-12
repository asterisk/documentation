---
search:
  boost: 0.5
title: SHARED
---

# SHARED()

### Synopsis

Gets or sets the shared variable specified.

### Description

Implements a shared variable area, in which you may share variables between channels.<br>

The variables used in this space are separate from the general namespace of the channel and thus **SHARED(foo)** and **foo** represent two completely different variables, despite sharing the same name.<br>

Finally, realize that there is an inherent race between channels operating at the same time, fiddling with each others' internal variables, which is why this special variable namespace exists; it is to remind you that variables in the SHARED namespace may change at any time, without warning. You should therefore take special care to ensure that when using the SHARED namespace, you retrieve the variable and store it in a regular channel variable before using it in a set of calculations (or you might be surprised by the result).<br>


### Syntax


```

SHARED(varname,channel)
```
##### Arguments


* `varname` - Variable name<br>

* `channel` - If not specified will default to current channel. It is the complete channel name: 'SIP/12-abcd1234' or the prefix only 'SIP/12'.<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 