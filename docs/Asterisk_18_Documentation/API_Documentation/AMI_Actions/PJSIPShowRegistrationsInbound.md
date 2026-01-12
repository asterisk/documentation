---
search:
  boost: 0.5
title: PJSIPShowRegistrationsInbound
---

# PJSIPShowRegistrationsInbound

### Synopsis

Lists PJSIP inbound registrations.

### Description

In response, 'InboundRegistrationDetail' events showing configuration and status information are raised for all contacts, static or dynamic. Once all events are completed an 'InboundRegistrationDetailComplete' is issued.<br>


/// warning
This command just dumps all coonfigured AORs with contacts, even if the contact is a permanent one. To really get just inbound registrations, use 'PJSIPShowRegistrationInboundContactStatuses'.
///


### Syntax


```


Action: PJSIPShowRegistrationsInbound

```
##### Arguments

### See Also

* [AMI Actions PJSIPShowRegistrationInboundContactStatuses_res_pjsip_registrar](/Asterisk_18_Documentation/API_Documentation/AMI_Actions/PJSIPShowRegistrationInboundContactStatuses_res_pjsip_registrar)


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 