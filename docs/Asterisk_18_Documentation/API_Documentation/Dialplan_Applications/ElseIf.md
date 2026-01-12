---
search:
  boost: 0.5
title: ElseIf
---

# ElseIf()

### Synopsis

Start an else if branch.

### Description

Start an optional ElseIf branch. Execution will continue inside the branch if expr is true and if previous If and ElseIf branches evaluated to false.<br>

Please note that execution inside a true If branch will fallthrough into ElseIf unless the If segment is terminated with an ExitIf call. This is only necessary with ElseIf but not with Else.<br>


### Syntax


```

ElseIf(expr)
```
##### Arguments


* `expr`

### See Also

* [Dialplan Applications If](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/If)
* [Dialplan Applications Else](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/Else)
* [Dialplan Applications EndIf](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/EndIf)
* [Dialplan Applications ExitIf](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/ExitIf)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 