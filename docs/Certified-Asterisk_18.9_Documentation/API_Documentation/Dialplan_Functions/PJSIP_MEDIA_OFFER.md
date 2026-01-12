---
search:
  boost: 0.5
title: PJSIP_MEDIA_OFFER
---

# PJSIP_MEDIA_OFFER()

### Synopsis

Media and codec offerings to be set on an outbound SIP channel prior to dialing.

### Description

When read, returns the codecs offered based upon the media choice.<br>

When written, sets the codecs to offer when an outbound dial attempt is made, or when a session refresh is sent using _PJSIP\_SEND\_SESSION\_REFRESH_.<br>


### Syntax


```

PJSIP_MEDIA_OFFER(media)
```
##### Arguments


* `media` - types of media offered<br>

### See Also

* [Dialplan Functions PJSIP_SEND_SESSION_REFRESH](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/PJSIP_SEND_SESSION_REFRESH)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 