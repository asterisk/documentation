---
search:
  boost: 0.5
title: PJSIP_PARSE_URI
---

# PJSIP_PARSE_URI()

### Synopsis

Parse an uri and return a type part of the URI.

### Since

13.24.0, 16.1.0, 17.0.0

### Description

Parse an URI and return a specified part of the URI.<br>


### Syntax


```

PJSIP_PARSE_URI(uri,type)
```
##### Arguments


* `uri` - URI to parse<br>

* `type` - The 'type' parameter specifies which URI part to read<br>

    * `display` - Display name.<br>

    * `scheme` - URI scheme.<br>

    * `user` - User part.<br>

    * `passwd` - Password part.<br>

    * `host` - Host part.<br>

    * `port` - Port number, or zero.<br>

    * `user_param` - User parameter.<br>

    * `method_param` - Method parameter.<br>

    * `transport_param` - Transport parameter.<br>

    * `ttl_param` - TTL param, or -1.<br>

    * `lr_param` - Loose routing param, or zero.<br>

    * `maddr_param` - Maddr param.<br>


### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 