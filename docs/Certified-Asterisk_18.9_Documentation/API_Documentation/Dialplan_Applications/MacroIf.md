---
search:
  boost: 0.5
title: MacroIf
---

# MacroIf()

### Synopsis

Conditional Macro implementation.

### Description

Executes macro defined in _macroiftrue_ if _expr_ is true (otherwise _macroiffalse_ if provided)<br>

Arguments and return values as in application Macro()<br>


/// warning
Use of the application 'WaitExten' within a macro will not function as expected. Please use the 'Read' application in order to read DTMF from a channel currently executing a macro.
///


### Syntax


```

MacroIf(expr?macroiftrue:[macroiffalse])
```
##### Arguments


* `expr`

* `destination`

    * `macroiftrue` **required**

        * `macroiftrue` **required**

        * `arg1[arg1...]`

    * `macroiffalse`

        * `macroiffalse` **required**

        * `arg1[arg1...]`

### See Also

* [Dialplan Applications GotoIf](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/GotoIf)
* [Dialplan Applications GosubIf](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/GosubIf)
* [Dialplan Functions IF](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/IF)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 