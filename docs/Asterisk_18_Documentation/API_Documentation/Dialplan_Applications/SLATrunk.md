---
search:
  boost: 0.5
title: SLATrunk
---

# SLATrunk()

### Synopsis

Shared Line Appearance Trunk.

### Description

This application should be executed by an SLA trunk on an inbound call. The channel calling this application should correspond to the SLA trunk with the name _trunk_ that is being passed as an argument.<br>

On exit, this application will set the variable **SLATRUNK\_STATUS** to one of the following values:<br>


* `SLATRUNK_STATUS`

    * `FAILURE`

    * `SUCCESS`

    * `UNANSWERED`

    * `RINGTIMEOUT`

### Syntax


```

SLATrunk(trunk,[options])
```
##### Arguments


* `trunk` - Trunk name<br>

* `options`

    * `M(class)` - Play back the specified MOH _class_ instead of ringing<br>

        * `class` **required**



### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 