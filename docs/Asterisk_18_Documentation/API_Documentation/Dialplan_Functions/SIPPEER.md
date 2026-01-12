---
search:
  boost: 0.5
title: SIPPEER
---

# SIPPEER()

### Synopsis

Gets SIP peer information.

### Description


### Syntax


```

SIPPEER(peername,item)
```
##### Arguments


* `peername`

* `item`

    * `ip` - (default) The IP address.<br>

    * `port` - The port number.<br>

    * `mailbox` - The configured mailbox.<br>

    * `context` - The configured context.<br>

    * `expire` - The epoch time of the next expire.<br>

    * `dynamic` - Is it dynamic? (yes/no).<br>

    * `callerid_name` - The configured Caller ID name.<br>

    * `callerid_num` - The configured Caller ID number.<br>

    * `callgroup` - The configured Callgroup.<br>

    * `pickupgroup` - The configured Pickupgroup.<br>

    * `namedcallgroup` - The configured Named Callgroup.<br>

    * `namedpickupgroup` - The configured Named Pickupgroup.<br>

    * `codecs` - The configured codecs.<br>

    * `status` - Status (if qualify=yes).<br>

    * `regexten` - Extension activated at registration.<br>

    * `limit` - Call limit (call-limit).<br>

    * `busylevel` - Configured call level for signalling busy.<br>

    * `curcalls` - Current amount of calls. Only available if call-limit is set.<br>

    * `language` - Default language for peer.<br>

    * `accountcode` - Account code for this peer.<br>

    * `useragent` - Current user agent header used by peer.<br>

    * `maxforwards` - The value used for SIP loop prevention in outbound requests<br>

    * `chanvar[name]` - A channel variable configured with setvar for this peer.<br>

    * `codec[x]` - Preferred codec index number _x_ (beginning with zero).<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 