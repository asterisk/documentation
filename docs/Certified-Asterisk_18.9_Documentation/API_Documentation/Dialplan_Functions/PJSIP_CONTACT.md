---
search:
  boost: 0.5
title: PJSIP_CONTACT
---

# PJSIP_CONTACT()

### Synopsis

Get information about a PJSIP contact

### Description

### Syntax


```

PJSIP_CONTACT(name,field)
```
##### Arguments


* `name` - The name of the contact to query.<br>

* `field` - The configuration option for the contact to query for. Supported options are those fields on the _contact_ object.<br>

    * `type` - Must be of type 'contact'.<br>

    * `uri` - SIP URI to contact peer<br>

    * `expiration_time` - Time to keep alive a contact<br>

    * `qualify_frequency` - Interval at which to qualify a contact<br>

    * `qualify_timeout` - Timeout for qualify<br>

    * `authenticate_qualify` - Authenticates a qualify challenge response if needed<br>

    * `outbound_proxy` - Outbound proxy used when sending OPTIONS request<br>

    * `path` - Stored Path vector for use in Route headers on outgoing requests.<br>

    * `user_agent` - User-Agent header from registration.<br>

    * `endpoint` - Endpoint name<br>

    * `reg_server` - Asterisk Server name<br>

    * `via_addr` - IP-address of the last Via header from registration.<br>

    * `via_port` - IP-port of the last Via header from registration.<br>

    * `call_id` - Call-ID header from registration.<br>

    * `prune_on_boot` - A contact that cannot survive a restart/boot.<br>

    * `rtt` - The RTT of the last qualify<br>

    * `status` - Status of the contact<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 