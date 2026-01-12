---
search:
  boost: 0.5
title: GET FULL VARIABLE
---

# GET FULL VARIABLE

### Synopsis

Evaluates a channel expression

### Description

Evaluates the given _expression_ against the channel specified by _channelname_, or the current channel if _channelname_ is not provided.<br>

Unlike GET VARIABLE, the _expression_ is processed in a manner similar to dialplan evaluation, allowing complex and built-in variables to be accessed, e.g. 'The time is $\{EPOCH\}'<br>

Returns '0' if no channel matching _channelname_ exists, '1' otherwise.<br>

Example return code: 200 result=1 (The time is 1578493800)<br>


### Syntax


```

GET FULL VARIABLE EXPRESSION CHANNELNAME 
```
##### Arguments


* `expression`

* `channelname`

### See Also

* [AGI Commands get_variable](/Certified-Asterisk_18.9_Documentation/API_Documentation/AGI_Commands/get_variable)
* [AGI Commands set_variable](/Certified-Asterisk_18.9_Documentation/API_Documentation/AGI_Commands/set_variable)
* [Dialplan Applications AGI](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Applications/AGI)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 