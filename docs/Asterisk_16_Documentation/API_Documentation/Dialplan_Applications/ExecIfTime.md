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

* [Dialplan Applications Exec](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/Exec)
* [Dialplan Applications ExecIf](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/ExecIf)
* [Dialplan Applications TryExec](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/TryExec)
* [Dialplan Applications GotoIfTime](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/GotoIfTime)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 