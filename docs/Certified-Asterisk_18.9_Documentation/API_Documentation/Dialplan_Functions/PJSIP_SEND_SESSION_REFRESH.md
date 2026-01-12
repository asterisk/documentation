---
search:
  boost: 0.5
title: PJSIP_SEND_SESSION_REFRESH
---

# PJSIP_SEND_SESSION_REFRESH()

### Synopsis

W/O: Initiate a session refresh via an UPDATE or re-INVITE on an established media session

### Description

This function will cause the PJSIP stack to immediately refresh the media session for the channel. This will be done using either a re-INVITE (default) or an UPDATE request.<br>

This is most useful when combined with the _PJSIP\_MEDIA\_OFFER_ dialplan function, as it allows the formats in use on a channel to be re-negotiated after call setup.<br>


/// warning
The formats the endpoint supports are *not* checked or enforced by this function. Using this function to offer formats not supported by the endpoint *may* result in a loss of media.
///

``` title="Example: Re-negotiate format to g722"

; Within some existing extension on an answered channel
same => n,Set(PJSIP_MEDIA_OFFER(audio)=!all,g722)
same => n,Set(PJSIP_SEND_SESSION_REFRESH()=invite)

		
```

### Syntax


```

PJSIP_SEND_SESSION_REFRESH([update_type])
```
##### Arguments


* `update_type` - The type of update to send. Default is 'invite'.<br>

    * `invite` - Send the session refresh as a re-INVITE.<br>

    * `update` - Send the session refresh as an UPDATE.<br>

### See Also

* [Dialplan Functions PJSIP_MEDIA_OFFER](/Certified-Asterisk_18.9_Documentation/API_Documentation/Dialplan_Functions/PJSIP_MEDIA_OFFER)


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 