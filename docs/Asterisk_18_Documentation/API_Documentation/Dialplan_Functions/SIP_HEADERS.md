---
search:
  boost: 0.5
title: SIP_HEADERS
---

# SIP_HEADERS()

### Synopsis

Gets the list of SIP header names from an incoming INVITE message.

### Description

Returns a comma-separated list of header names (without values) from the INVITE message that originated the current channel. Multiple headers with the same name are included in the list only once. The returned list can be iterated over using the functions POP() and SIP\_HEADER().<br>

For example, '$\{SIP\_HEADERS(Co)\}' might return 'Contact,Content-Length,Content-Type'. As a practical example, you may use '$\{SIP\_HEADERS(X-)\}' to enumerate optional extended headers.<br>

This function does not access headers from the incoming SIP REFER message; see the documentation of the function SIP\_HEADER for how to access them.<br>

Please observe that contents of the SDP (an attachment to the SIP request) can't be accessed with this function.<br>


### Syntax


```

SIP_HEADERS(prefix)
```
##### Arguments


* `prefix` - If specified, only the headers matching the given prefix are returned.<br>

### See Also

* [Dialplan Functions SIP_HEADER](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/SIP_HEADER)
* [Dialplan Functions POP](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/POP)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 