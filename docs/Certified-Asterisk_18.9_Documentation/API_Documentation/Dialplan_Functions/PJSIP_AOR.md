---
search:
  boost: 0.5
title: PJSIP_AOR
---

# PJSIP_AOR()

### Synopsis

Get information about a PJSIP AOR

### Description

### Syntax


```

PJSIP_AOR(name,field)
```
##### Arguments


* `name` - The name of the AOR to query.<br>

* `field` - The configuration option for the AOR to query for. Supported options are those fields on the _aor_ object in *pjsip.conf*.<br>

    * `contact` - Permanent contacts assigned to AoR<br>

    * `default_expiration` - Default expiration time in seconds for contacts that are dynamically bound to an AoR.<br>

    * `mailboxes` - Allow subscriptions for the specified mailbox(es)<br>

    * `voicemail_extension` - The voicemail extension to send in the NOTIFY Message-Account header<br>

    * `maximum_expiration` - Maximum time to keep an AoR<br>

    * `max_contacts` - Maximum number of contacts that can bind to an AoR<br>

    * `minimum_expiration` - Minimum keep alive time for an AoR<br>

    * `remove_existing` - Determines whether new contacts replace existing ones.<br>

    * `remove_unavailable` - Determines whether new contacts should replace unavailable ones.<br>

    * `type` - Must be of type 'aor'.<br>

    * `qualify_frequency` - Interval at which to qualify an AoR<br>

    * `qualify_timeout` - Timeout for qualify<br>

    * `authenticate_qualify` - Authenticates a qualify challenge response if needed<br>

    * `outbound_proxy` - Outbound proxy used when sending OPTIONS request<br>

    * `support_path` - Enables Path support for REGISTER requests and Route support for other requests.<br>


### Generated Version

This documentation was generated from Asterisk branch certified/18.9 using version GIT 