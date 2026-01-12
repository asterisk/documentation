---
search:
  boost: 0.5
title: DIALGROUP
---

# DIALGROUP()

### Synopsis

Manages a group of users for dialing.

### Description

Presents an interface meant to be used in concert with the Dial application, by presenting a list of channels which should be dialled when referenced.<br>

When DIALGROUP is read from, the argument is interpreted as the particular _group_ for which a dial should be attempted. When DIALGROUP is written to with no arguments, the entire list is replaced with the argument specified.<br>

Functionality is similar to a queue, except that when no interfaces are available, execution may continue in the dialplan. This is useful when you want certain people to be the first to answer any calls, with immediate fallback to a queue when the front line people are busy or unavailable, but you still want front line people to log in and out of that group, just like a queue.<br>

Example:<br>

exten => 1,1,Set(DIALGROUP(mygroup,add)=SIP/10)<br>

exten => 1,n,Set(DIALGROUP(mygroup,add)=SIP/20)<br>

exten => 1,n,Dial($\{DIALGROUP(mygroup)\})<br>


### Syntax


```

DIALGROUP(group,op)
```
##### Arguments


* `group`

* `op` - The operation name, possible values are:<br>
add - add a channel name or interface (write-only)<br>
del - remove a channel name or interface (write-only)<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 