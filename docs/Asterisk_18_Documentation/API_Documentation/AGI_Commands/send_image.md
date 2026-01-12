---
search:
  boost: 0.5
title: SEND IMAGE
---

# SEND IMAGE

### Synopsis

Sends images to channels supporting it.

### Description

Sends the given image on a channel. Most channels do not support the transmission of images. Returns '0' if image is sent, or if the channel does not support image transmission. Returns '-1' only on error/hangup. Image names should not include extensions.<br>


### Syntax


```

SEND IMAGE IMAGE 
```
##### Arguments


* `image`

### See Also

* [Dialplan Applications AGI](/Asterisk_18_Documentation/API_Documentation/Dialplan_Applications/AGI)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 