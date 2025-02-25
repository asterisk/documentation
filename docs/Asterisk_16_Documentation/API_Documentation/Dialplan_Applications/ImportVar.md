---
search:
  boost: 0.5
title: ImportVar
---

# ImportVar()

### Synopsis

Import a variable from a channel into a new variable.

### Description

This application imports a _variable_ from the specified _channel_ (as opposed to the current one) and stores it as a variable (_newvar_) in the current channel (the channel that is calling this application). Variables created by this application have the same inheritance properties as those created with the 'Set' application.<br>


### Syntax


```

ImportVar(newvar=channelname,variable)
```
##### Arguments


* `newvar`

* `vardata`

    * `channelname` **required**

    * `variable` **required**

### See Also

* [Dialplan Applications Set](/Asterisk_16_Documentation/API_Documentation/Dialplan_Applications/Set)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 