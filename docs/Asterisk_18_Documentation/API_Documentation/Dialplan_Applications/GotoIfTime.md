---
search:
  boost: 0.5
title: GotoIfTime
---

# GotoIfTime()

### Synopsis

Conditional Goto based on the current time.

### Description

This application will set the context, extension, and priority in the channel structure based on the evaluation of the given time specification. After this application completes, the pbx engine will continue dialplan execution at the specified location in the dialplan. If the current time is within the given time specification, the channel will continue at _labeliftrue_. Otherwise the channel will continue at _labeliffalse_. If the label chosen by the condition is omitted, no jump is performed, and execution passes to the next instruction. If the target jump location is bogus, the same actions would be taken as for 'Goto'. Further information on the time specification can be found in examples illustrating how to do time-based context includes in the dialplan.<br>


### Syntax


```

GotoIfTime(times,weekdays,mdays,months,[timezone]?[labeliftrue:[labeliffalse]])
```
##### Arguments


* `condition`

    * `times` **required**

    * `weekdays` **required**

    * `mdays` **required**

    * `months` **required**

    * `timezone`

* `destination`

    * `labeliftrue` - Continue at _labeliftrue_ if the condition is true. Takes the form similar to Goto() of \[\[context,\]extension,\]priority.<br>

    * `labeliffalse` - Continue at _labeliffalse_ if the condition is false. Takes the form similar to Goto() of \[\[context,\]extension,\]priority.<br>

### See Also

* [Dialplan Applications GotoIf](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/GotoIf)
* [Dialplan Applications Goto](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/Goto)
* [Dialplan Functions IFTIME](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/IFTIME)
* [Dialplan Functions TESTTIME](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/TESTTIME)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 