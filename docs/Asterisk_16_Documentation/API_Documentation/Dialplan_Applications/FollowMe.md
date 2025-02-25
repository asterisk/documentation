---
search:
  boost: 0.5
title: FollowMe
---

# FollowMe()

### Synopsis

Find-Me/Follow-Me application.

### Description

This application performs Find-Me/Follow-Me functionality for the caller as defined in the profile matching the _followmeid_ parameter in *followme.conf*. If the specified _followmeid_ profile doesn't exist in *followme.conf*, execution will be returned to the dialplan and call execution will continue at the next priority.<br>

Returns -1 on hangup.<br>


### Syntax


```

FollowMe(followmeid,[options])
```
##### Arguments


* `followmeid`

* `options`

    * `a` - Record the caller's name so it can be announced to the callee on each step.<br>


    * `B(context^exten^priority)` - Before initiating the outgoing call(s), Gosub to the specified location using the current channel.<br>

        * `context`

        * `exten`

        * `priority (params )` **required**

            * `arg1[^arg1...]` **required**

            * `argN`


    * `b(context^exten^priority)` - Before initiating an outgoing call, Gosub to the specified location using the newly created channel. The Gosub will be executed for each destination channel.<br>

        * `context`

        * `exten`

        * `priority (params )` **required**

            * `arg1[^arg1...]` **required**

            * `argN`


    * `d` - Disable the 'Please hold while we try to connect your call' announcement.<br>


    * `I` - Asterisk will ignore any connected line update requests it may receive on this dial attempt.<br>


    * `l` - Disable local call optimization so that applications with audio hooks between the local bridge don't get dropped when the calls get joined directly.<br>


    * `N` - Don't answer the incoming call until we're ready to connect the caller or give up.<br>


    * `n` - Playback the unreachable status message if we've run out of steps or the callee has elected not to be reachable.<br>


    * `s` - Playback the incoming status message prior to starting the follow-me step(s)<br>



### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 