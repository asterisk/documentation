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

``` title="Example: Example 1"

exten => 1,1,Answer()


```
; In this example the effect of the following line is<br>

; implied:<br>

``` title="Example: Example 1b"

same => n,Set(CONFBRIDGE(user,template)=default_user)
same => n,Set(CONFBRIDGE(user,announce_join_leave)=yes)
same => n,Set(CONFBRIDGE(user,startmuted)=yes)
same => n,ConfBridge(1)


```
---- Example 2 ----<br>

This example shows how to use a predefined user profile in *confbridge.conf* as a template for a dynamic profile. Here we make an admin/marked user out of the 'my\_user' profile that you define in *confbridge.conf*.<br>

``` title="Example: Example 2"

exten => 1,1,Answer()
same => n,Set(CONFBRIDGE(user,template)=my_user)
same => n,Set(CONFBRIDGE(user,admin)=yes)
same => n,Set(CONFBRIDGE(user,marked)=yes)
same => n,ConfBridge(1)


```

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

This documentation was generated from Asterisk branch 16 using version GIT 