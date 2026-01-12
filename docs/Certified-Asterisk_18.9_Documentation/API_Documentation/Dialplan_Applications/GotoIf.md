---
search:
  boost: 0.5
title: GotoIf
---

# GotoIf()

### Synopsis

Conditional goto.

### Description

This application will set the current context, extension, and priority in the channel structure based on the evaluation of the given condition. After this application completes, the pbx engine will continue dialplan execution at the specified location in the dialplan. The labels are specified with the same syntax as used within the Goto application. If the label chosen by the condition is omitted, no jump is performed, and the execution passes to the next instruction. If the target location is bogus, and does not exist, the execution engine will try to find and execute the code in the 'i' (invalid) extension in the current context. If that does not exist, it will try to execute the 'h' extension. If neither the 'h' nor 'i' extensions have been defined, the channel is hung up, and the execution of instructions on the channel is terminated. Remember that this command can set the current context, and if the context specified does not exist, then it will not be able to find any 'h' or 'i' extensions there, and the channel and call will both be terminated!.<br>


### Syntax


```

GotoIf(condition?[labeliftrue:[labeliffalse]])
```
##### Arguments


* `condition`

* `destination`

    * `labeliftrue` - Continue at _labeliftrue_ if the condition is true. Takes the form similar to Goto() of \[\[context,\]extension,\]priority.<br>

    * `labeliffalse` - Continue at _labeliffalse_ if the condition is false. Takes the form similar to Goto() of \[\[context,\]extension,\]priority.<br>

### See Also

* [Dialplan Applications Goto](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/Goto)
* [Dialplan Applications GotoIfTime](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/GotoIfTime)
* [Dialplan Applications GosubIf](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/GosubIf)
* [Dialplan Applications MacroIf](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/MacroIf)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 