---
search:
  boost: 0.5
title: PJSIPNotify
---

# PJSIPNotify

### Synopsis

Send a NOTIFY to either an endpoint, an arbitrary URI, or inside a SIP dialog.

### Description

Sends a NOTIFY to an endpoint, an arbitrary URI, or inside a SIP dialog.<br>

All parameters for this event must be specified in the body of this requestvia multiple 'Variable: name=value' sequences.<br>


/// note
One (and only one) of 'Endpoint', 'URI', or 'Channel' must be specified. If 'URI' is used, the default outbound endpoint will be used to send the message. If the default outbound endpoint isn't configured, this command can not send to an arbitrary URI.
///


### Syntax


```


Action: PJSIPNotify
ActionID: <value>
[Endpoint: <value>]
[URI: <value>]
[channel: <value>]
[Option: <value>]
[Variable: <value>]

```
##### Arguments


* `ActionID` - ActionID for this transaction. Will be returned.<br>

* `Endpoint` - The endpoint to which to send the NOTIFY.<br>

* `URI` - Abritrary URI to which to send the NOTIFY.<br>

* `channel` - Channel name to send the NOTIFY. Must be a PJSIP channel.<br>

* `Option` - The config section name from 'pjsip\_notify.conf' to use.<br>
One of Option or Variable must be specified.<br>

* `Variable` - Appends variables as headers/content to the NOTIFY. If the variable is named 'Content', then the value will compose the body of the message if another variable sets 'Content-Type'. _name_=_value_<br>
One of Option or Variable must be specified.<br>


### Generated Version

This documentation was generated from Asterisk branch 18 using version GIT 