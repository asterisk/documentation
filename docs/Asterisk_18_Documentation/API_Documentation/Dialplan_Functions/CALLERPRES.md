---
search:
  boost: 0.5
title: CALLERPRES
---

# CALLERPRES()

### Synopsis

Gets or sets Caller*ID presentation on the channel.

### Description

Gets or sets Caller*ID presentation on the channel. This function is deprecated in favor of CALLERID(num-pres) and CALLERID(name-pres) or CALLERID(pres) to get/set both at once. The following values are valid:<br>


* `allowed_not_screened` - Presentation Allowed, Not Screened.<br>

* `allowed_passed_screen` - Presentation Allowed, Passed Screen.<br>

* `allowed_failed_screen` - Presentation Allowed, Failed Screen.<br>

* `allowed` - Presentation Allowed, Network Number.<br>

* `prohib_not_screened` - Presentation Prohibited, Not Screened.<br>

* `prohib_passed_screen` - Presentation Prohibited, Passed Screen.<br>

* `prohib_failed_screen` - Presentation Prohibited, Failed Screen.<br>

* `prohib` - Presentation Prohibited, Network Number.<br>

* `unavailable` - Number Unavailable.<br>

### Syntax


```

CALLERPRES()
```
##### Arguments


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 