---
search:
  boost: 0.5
title: Goto
---

# Goto()

### Synopsis

Jump to a particular priority, extension, or context.

### Description

This application will set the current context, extension, and priority in the channel structure. After it completes, the pbx engine will continue dialplan execution at the specified location. If no specific _extension_, or _extension_ and _context_, are specified, then this application will just set the specified _priority_ of the current extension.<br>

At least a _priority_ is required as an argument, or the goto will return a '-1',and the channel and call will be terminated.<br>

If the location that is put into the channel information is bogus, and asterisk cannot find that location in the dialplan, then the execution engine will try to find and execute the code in the 'i' (invalid) extension in the current context. If that does not exist, it will try to execute the 'h' extension. If neither the 'h' nor 'i' extensions have been defined, the channel is hung up, and the execution of instructions on the channel is terminated. What this means is that, for example, you specify a context that does not exist, then it will not be possible to find the 'h' or 'i' extensions, and the call will terminate!<br>


### Syntax


```

Goto([context,[extensions,]]priority)
```
##### Arguments


* `context`

* `extensions`

* `priority`

### See Also

* [Dialplan Applications GotoIf](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/GotoIf)
* [Dialplan Applications GotoIfTime](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/GotoIfTime)
* [Dialplan Applications Gosub](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/Gosub)
* [Dialplan Applications Macro](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/Macro)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 