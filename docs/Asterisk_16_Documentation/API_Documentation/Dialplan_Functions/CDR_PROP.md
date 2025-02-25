---
search:
  boost: 0.5
title: CDR_PROP
---

# CDR_PROP()

### Synopsis

Set a property on a channel's CDR.

### Description

This function sets a property on a channel's CDR. Properties alter the behavior of how the CDR operates for that channel.<br>


### Syntax


```

CDR_PROP(name)
```
##### Arguments


* `name` - The property to set on the CDR.<br>

    * `party_a` - Set this channel as the preferred Party A when channels are associated together.<br>
Write-Only<br>

    * `disable` - Setting to 1 will disable CDRs for this channel. Setting to 0 will enable CDRs for this channel.<br>
Write-Only<br>


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 