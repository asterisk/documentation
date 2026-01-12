---
search:
  boost: 0.5
title: BridgeWait
---

# BridgeWait()

### Synopsis

Put a call into the holding bridge.

### Description

This application places the incoming channel into a holding bridge. The channel will then wait in the holding bridge until some event occurs which removes it from the holding bridge.<br>


/// note
This application will answer calls which haven't already been answered.
///


### Syntax


```

BridgeWait([name,[role,[options]]])
```
##### Arguments


* `name` - Name of the holding bridge to join. This is a handle for 'BridgeWait' only and does not affect the actual bridges that are created. If not provided, the reserved name 'default' will be used.<br>

* `role` - Defines the channel's purpose for entering the holding bridge. Values are case sensitive.<br>

    * `participant` - The channel will enter the holding bridge to be placed on hold until it is removed from the bridge for some reason. (default)<br>

    * `announcer` - The channel will enter the holding bridge to make announcements to channels that are currently in the holding bridge. While an announcer is present, holding for the participants will be suspended.<br>

* `options`

    * `m(class)` - The specified MOH class will be used/suggested for music on hold operations. This option will only be useful for entertainment modes that use it (m and h).<br>

        * `class` **required**


    * `e` - Which entertainment mechanism should be used while on hold in the holding bridge. Only the first letter is read.<br>

        * `m` - Play music on hold (default)<br>

        * `r` - Ring without pause<br>

        * `s` - Generate silent audio<br>

        * `h` - Put the channel on hold<br>

        * `n` - No entertainment<br>


    * `S(duration)` - Automatically exit the bridge and return to the PBX after *duration* seconds.<br>

        * `duration` **required**



### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 