---
search:
  boost: 0.5
title: DAHDISendCallreroutingFacility
---

# DAHDISendCallreroutingFacility()

### Synopsis

Send an ISDN call rerouting/deflection facility message.

### Description

This application will send an ISDN switch specific call rerouting/deflection facility message over the current channel. Supported switches depend upon the version of libpri in use.<br>


### Syntax


```

DAHDISendCallreroutingFacility(destination,[original,[reason]])
```
##### Arguments


* `destination` - Destination number.<br>

* `original` - Original called number.<br>

* `reason` - Diversion reason, if not specified defaults to 'unknown'<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 