---
search:
  boost: 0.5
title: VOLUME
---

# VOLUME()

### Synopsis

Set or get the TX or RX volume of a channel.

### Description

The VOLUME function can be used to increase or decrease the 'tx' or 'rx' gain of any channel.<br>

For example:<br>

Set(VOLUME(TX)=3)<br>

Set(VOLUME(RX)=2)<br>

Set(VOLUME(TX,p)=3)<br>

Set(VOLUME(RX,p)=3)<br>


### Syntax


```

VOLUME(direction,options)
```
##### Arguments


* `direction` - Must be 'TX' or 'RX'.<br>

* `options`

    * `p` - Enable DTMF volume control<br>



### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 