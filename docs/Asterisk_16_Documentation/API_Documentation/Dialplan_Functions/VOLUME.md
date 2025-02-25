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

``` title="Example: Increase volume"

same => n,Set(VOLUME(TX)=3)


```
``` title="Example: Increase volume"

same => n,Set(VOLUME(RX)=2)


```
``` title="Example: Increase volume with DTMF control"

same => n,Set(VOLUME(TX,p)=3)


```
``` title="Example: Increase RX volume with DTMF control"

same => n,Set(VOLUME(RX,p)=3)


```
``` title="Example: Decrease RX volume"

same => n,Set(VOLUME(RX)=-4)


```
``` title="Example: Reset to normal"

same => n,Set(VOLUME(RX)=0)


```

### Syntax


```

VOLUME(direction,options)
```
##### Arguments


* `direction` - Must be 'TX' or 'RX'.<br>

* `options`

    * `p` - Enable DTMF volume control<br>



### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 