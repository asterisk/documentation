---
search:
  boost: 0.5
title: Macro
---

# Macro()

### Synopsis

Macro Implementation.

### Description

Executes a macro using the context macro- _name_, jumping to the 's' extension of that context and executing each step, then returning when the steps end.<br>

The calling extension, context, and priority are stored in **MACRO\_EXTEN**, **MACRO\_CONTEXT** and **MACRO\_PRIORITY** respectively. Arguments become **ARG1**, **ARG2**, etc in the macro context.<br>

If you Goto out of the Macro context, the Macro will terminate and control will be returned at the location of the Goto.<br>

If **MACRO\_OFFSET** is set at termination, Macro will attempt to continue at priority MACRO\_OFFSET + N + 1 if such a step exists, and N + 1 otherwise.<br>


/// warning
Because of the way Macro is implemented (it executes the priorities contained within it via sub-engine), and a fixed per-thread memory stack allowance, macros are limited to 7 levels of nesting (macro calling macro calling macro, etc.); It may be possible that stack-intensive applications in deeply nested macros could cause asterisk to crash earlier than this limit. It is advised that if you need to deeply nest macro calls, that you use the Gosub application (now allows arguments like a Macro) with explicit Return() calls instead.
///


/// warning
Use of the application 'WaitExten' within a macro will not function as expected. Please use the 'Read' application in order to read DTMF from a channel currently executing a macro.
///


### Syntax


```

Macro(name,arg1,[arg2[,...]])
```
##### Arguments


* `name` - The name of the macro<br>

* `args`

    * `arg1` **required**

    * `arg2[,arg2...]`

### See Also

* [Dialplan Applications MacroExit](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/MacroExit)
* [Dialplan Applications Goto](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/Goto)
* [Dialplan Applications Gosub](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/Gosub)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 