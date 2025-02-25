---
search:
  boost: 0.5
title: PickupChan
---

# PickupChan()

### Synopsis

Pickup a ringing channel.

### Description

Pickup a specified _channel_ if ringing.<br>


### Syntax


```

PickupChan(channel&[channel2[&...]],[options])
```
##### Arguments


* `channel` - 
    * `channel` **required**

    * `channel2[,channel2...]`
List of channel names or channel uniqueids to pickup if ringing. For example, a channel name could be 'SIP/bob' or 'SIP/bob-00000000' to find 'SIP/bob-00000000'.<br>

* `options`

    * `p` - Supplied channel names are prefixes. For example, 'SIP/bob' will match 'SIP/bob-00000000' and 'SIP/bobby-00000000'.<br>



### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 