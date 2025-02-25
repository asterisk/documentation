---
search:
  boost: 0.5
title: PJSIP_HEADERS
---

# PJSIP_HEADERS()

### Synopsis

Gets the list of SIP header names from an INVITE message.

### Since

16.20.0, 18.6.0, 19.0.0

### Description

Returns a comma-separated list of header names (without values) from the INVITE message. Multiple headers with the same name are included in the list only once.<br>

For example, '$\{PJSIP\_HEADERS(Co)\}' might return 'Contact,Content-Length,Content-Type'. As a practical example, you may use '$\{PJSIP\_HEADERS(X-)\}' to enumerate optional extended headers.<br>


### Syntax


```

PJSIP_HEADERS(prefix)
```
##### Arguments


* `prefix` - If specified, only the headers matching the given prefix are returned.<br>

### See Also

* [Dialplan Functions PJSIP_HEADER](/Asterisk_16_Documentation/API_Documentation/Dialplan_Functions/PJSIP_HEADER)


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 