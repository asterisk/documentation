---
search:
  boost: 0.5
title: GosubIf
---

# GosubIf()

### Synopsis

Conditionally jump to label, saving return address.

### Description

If the condition is true, then jump to labeliftrue. If false, jumps to labeliffalse, if specified. In either case, a jump saves the return point in the dialplan, to be returned to with a Return.<br>


### Syntax


```

GosubIf(condition?[labeliftrue:[labeliffalse]])
```
##### Arguments


* `condition`

* `destination`

    * `labeliftrue (params )` - Continue at _labeliftrue_ if the condition is true. Takes the form similar to Goto() of \[\[context,\]extension,\]priority.<br>

        * `arg1[arg1...]` **required**

        * `argN`

    * `labeliffalse (params )` - Continue at _labeliffalse_ if the condition is false. Takes the form similar to Goto() of \[\[context,\]extension,\]priority.<br>

        * `arg1[arg1...]` **required**

        * `argN`

### See Also

* [Dialplan Applications Gosub](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/Gosub)
* [Dialplan Applications Return](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/Return)
* [Dialplan Applications MacroIf](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/MacroIf)
* [Dialplan Functions IF](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/IF)
* [Dialplan Applications GotoIf](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/GotoIf)
* [Dialplan Applications Goto](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/Goto)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 