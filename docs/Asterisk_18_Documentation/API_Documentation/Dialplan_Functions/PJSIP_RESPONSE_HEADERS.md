---
search:
  boost: 0.5
title: PJSIP_RESPONSE_HEADERS
---

# PJSIP_RESPONSE_HEADERS()

### Synopsis

Gets the list of SIP header names from the 200 response of INVITE message.

### Description

Returns a comma-separated list of header names (without values) from the 200 response of INVITE message. Multiple headers with the same name are included in the list only once.<br>

For example, '$\{PJSIP\_RESPONSE\_HEADERS(Co)\}' might return 'Contact,Content-Length,Content-Type'. As a practical example, you may use '$\{PJSIP\_RESPONSE\_HEADERS(X-)\}' to enumerate optional extended headers.<br>


### Syntax


```

PJSIP_RESPONSE_HEADERS(prefix)
```
##### Arguments


* `prefix` - If specified, only the headers matching the given prefix are returned.<br>

### See Also

* [Dialplan Functions PJSIP_RESPONSE_HEADER](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/PJSIP_RESPONSE_HEADER)
* [Dialplan Functions PJSIP_HEADERS](/Asterisk_18_Documentation/API_Documentation/Dialplan_Functions/PJSIP_HEADERS)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 