---
search:
  boost: 0.5
title: SLAStation
---

# SLAStation()

### Synopsis

Shared Line Appearance Station.

### Description

This application should be executed by an SLA station. The argument depends on how the call was initiated. If the phone was just taken off hook, then the argument _station_ should be just the station name. If the call was initiated by pressing a line key, then the station name should be preceded by an underscore and the trunk name associated with that line button.<br>

For example: 'station1\_line1'<br>

On exit, this application will set the variable **SLASTATION\_STATUS** to one of the following values:<br>


* `SLASTATION_STATUS`

    * `FAILURE`

    * `CONGESTION`

    * `SUCCESS`

### Syntax


```

SLAStation(station)
```
##### Arguments


* `station` - Station name<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 