---
search:
  boost: 0.5
title: Answer
---

# Answer()

### Synopsis

Answer a channel if ringing.

### Description

If the call has not been answered, this application will answer it. Otherwise, it has no effect on the call.<br>

By default, Asterisk will wait for media for up to 500 ms, or the user specified delay, whichever is longer. If you do not want to wait for media at all, use the i option.<br>


### Syntax


```

Answer([delay,[options]])
```
##### Arguments


* `delay` - Asterisk will wait this number of milliseconds before returning to the dialplan after answering the call.<br>
The minimum is 500 ms. To answer immediately without waiting for media, use the i option.<br>

* `options`

    * `i` - Answer the channel immediately without waiting for media.<br>


### See Also

* [Dialplan Applications Hangup](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/Hangup)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 