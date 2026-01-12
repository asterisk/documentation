---
search:
  boost: 0.5
title: CONFBRIDGE
---

# CONFBRIDGE()

### Synopsis

Set a custom dynamic bridge, user, or menu profile on a channel for the ConfBridge application using the same options available in confbridge.conf.

### Description

A custom profile uses the default profile type settings defined in *confbridge.conf* as defaults if the profile template is not explicitly specified first.<br>

For 'bridge' profiles the default template is 'default\_bridge'.<br>

For 'menu' profiles the default template is 'default\_menu'.<br>

For 'user' profiles the default template is 'default\_user'.<br>

---- Example 1 ----<br>

In this example the custom user profile set on the channel will automatically be used by the ConfBridge application.<br>

exten => 1,1,Answer()<br>

; In this example the effect of the following line is<br>

; implied:<br>

; same => n,Set(CONFBRIDGE(user,template)=default\_user)<br>

same => n,Set(CONFBRIDGE(user,announce\_join\_leave)=yes)<br>

same => n,Set(CONFBRIDGE(user,startmuted)=yes)<br>

same => n,ConfBridge(1)<br>

---- Example 2 ----<br>

This example shows how to use a predefined user profile in *confbridge.conf* as a template for a dynamic profile. Here we make an admin/marked user out of the 'my\_user' profile that you define in *confbridge.conf*.<br>

exten => 1,1,Answer()<br>

same => n,Set(CONFBRIDGE(user,template)=my\_user)<br>

same => n,Set(CONFBRIDGE(user,admin)=yes)<br>

same => n,Set(CONFBRIDGE(user,marked)=yes)<br>

same => n,ConfBridge(1)<br>


### Syntax


```

CONFBRIDGE(type,option)
```
##### Arguments


* `type` - To what type of conference profile the option applies.<br>

    * `bridge`

    * `menu`

    * `user`

* `option` - Option refers to a *confbridge.conf* option that is being set dynamically on this channel, or 'clear' to remove already applied profile options from the channel.<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 