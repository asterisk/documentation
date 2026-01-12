---
search:
  boost: 0.5
title: HOLD_INTERCEPT
---

# HOLD_INTERCEPT()

### Synopsis

Intercepts hold frames on a channel and raises an event instead of passing the frame on

### Description

### Syntax


```

HOLD_INTERCEPT(action)
```
##### Arguments


* `action`

    * `remove` - W/O. Removes the hold interception function.<br>


    * `set` - W/O. Enable hold interception on the channel. When enabled, the channel will intercept any hold action that is signalled from the device, and instead simply raise an event (AMI/ARI) indicating that the channel wanted to put other parties on hold.<br>



### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 