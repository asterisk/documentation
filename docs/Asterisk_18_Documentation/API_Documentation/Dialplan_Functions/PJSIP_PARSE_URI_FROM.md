---
search:
  boost: 0.5
title: PJSIP_PARSE_URI_FROM
---

# PJSIP_PARSE_URI_FROM()

### Synopsis

Parse the contents of a variable as a URI and return a type part of the URI.

### Since

18.24.0, 20.9.0, 21.4.0

### Description

Parse the contents of the provided variable as a URI and return a specified part of the URI.<br>


### Syntax


```

PJSIP_PARSE_URI_FROM(uri,type)
```
##### Arguments


* `uri` - Name of a variable that contains a URI to parse<br>

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

This documentation was generated from Asterisk branch 18 using version GIT 