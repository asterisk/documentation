---
search:
  boost: 0.5
title: PP_EACH_USER
---

# PP_EACH_USER()

### Synopsis

Generate a string for each phoneprov user.

### Description

Pass in a string, with phoneprov variables you want substituted in the format of %\{VARNAME\}, and you will get the string rendered for each user in phoneprov excluding ones with MAC address _exclude\_mac_. Probably not useful outside of res\_phoneprov.<br>

Example: $\{PP\_EACH\_USER(<item><fn>%\{DISPLAY\_NAME\}</fn></item>|$\{MAC\})<br>


### Syntax


```

PP_EACH_USER(string,exclude_mac)
```
##### Arguments


* `string`

* `exclude_mac`


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 