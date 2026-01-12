---
search:
  boost: 0.5
title: ExecIfTime
---

# ExecIfTime()

### Synopsis

Conditional application execution based on the current time.

### Description

This application will execute the specified dialplan application, with optional arguments, if the current time matches the given time specification.<br>


### Syntax


```

ExecIfTime(times,weekdays,mdays,months,[timezone]?appname[(appargs]))
```
##### Arguments


* `day_condition`

    * `times` **required**

    * `weekdays` **required**

    * `mdays` **required**

    * `months` **required**

    * `timezone`

* `appname`

    * `appargs` **required**

### See Also

* [Dialplan Applications Exec](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/Exec)
* [Dialplan Applications ExecIf](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/ExecIf)
* [Dialplan Applications TryExec](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/TryExec)
* [Dialplan Applications GotoIfTime](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/GotoIfTime)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 