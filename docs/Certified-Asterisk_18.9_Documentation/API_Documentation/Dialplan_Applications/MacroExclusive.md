---
search:
  boost: 0.5
title: MacroExclusive
---

# MacroExclusive()

### Synopsis

Exclusive Macro Implementation.

### Description

Executes macro defined in the context macro- _name_. Only one call at a time may run the macro. (we'll wait if another call is busy executing in the Macro)<br>

Arguments and return values as in application Macro()<br>


/// warning
Use of the application 'WaitExten' within a macro will not function as expected. Please use the 'Read' application in order to read DTMF from a channel currently executing a macro.
///


### Syntax


```

MacroExclusive(name,[arg1,[arg2[,...]]])
```
##### Arguments


* `name` - The name of the macro<br>

* `arg1`

* `arg2`

### See Also

* [Dialplan Applications Macro](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/Macro)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 