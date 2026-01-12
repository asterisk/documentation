---
search:
  boost: 0.5
title: IAXPEER
---

# IAXPEER()

### Synopsis

Gets IAX peer information.

### Description

Gets information associated with the specified IAX2 peer.<br>


### Syntax


```

IAXPEER(peername,item)
```
##### Arguments


* `peername`

    * `CURRENTCHANNEL` - If _peername_ is specified to this value, return the IP address of the endpoint of the current channel<br>

* `item` - If _peername_ is specified, valid items are:<br>

    * `ip` - (default) The IP address.<br>

    * `status` - The peer's status (if 'qualify=yes')<br>

    * `mailbox` - The configured mailbox.<br>

    * `context` - The configured context.<br>

    * `expire` - The epoch time of the next expire.<br>

    * `dynamic` - Is it dynamic? (yes/no).<br>

    * `callerid_name` - The configured Caller ID name.<br>

    * `callerid_num` - The configured Caller ID number.<br>

    * `codecs` - The configured codecs.<br>

    * `codec[x]` - Preferred codec index number _x_ (beginning with '0')<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 