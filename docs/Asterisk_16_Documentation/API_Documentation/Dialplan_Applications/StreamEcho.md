---
search:
  boost: 0.5
title: StreamEcho
---

# StreamEcho()

### Synopsis

Echo media, up to 'N' streams of a type, and DTMF back to the calling party

### Description

If a "num" (the number of streams) is not given then this simply echos back any media or DTMF frames (note, however if '#' is detected then the application exits) read from the calling channel back to itself. This means for any relevant frame read from a particular stream it is written back out to the associated write stream in a one to one fashion.<br>

However if a "num" is specified, and if the calling channel allows it (a new offer is made requesting the allowance of additional streams) then any any media received, like before, is echoed back onto each stream. However, in this case a relevant frame received on a stream of the given "type" is also echoed back out to the other streams of that same type. It should be noted that when operating in this mode only the first stream found of the given "type" is allowed from the original offer. And this first stream found is also the only stream of that "type" granted read (send/receive) capabilities in the new offer whereas the additional ones are set to receive only.<br>


/// note
This does not echo CONTROL, MODEM, or NULL frames.
///


### Syntax


```

StreamEcho([num,[type]])
```
##### Arguments


* `num` - The number of streams of a type to echo back. If '0' is specified then all streams of a type are removed.<br>

* `type` - The media type of the stream(s) to add or remove (in the case of "num" being '0'). This can be set to either "audio" or "video" (default). If "num" is empty (i.e. not specified) then this parameter is ignored.<br>


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 