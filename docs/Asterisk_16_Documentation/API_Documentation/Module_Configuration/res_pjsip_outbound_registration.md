---
search:
  boost: 0.5
title: res_pjsip_outbound_registration
---

# res_pjsip_outbound_registration: SIP resource for outbound registrations

This configuration documentation is for functionality provided by res_pjsip_outbound_registration.

## Overview

*Outbound Registration*<br>

This module allows 'res\_pjsip' to register to other SIP servers.<br>


## Configuration File: pjsip.conf

### [registration]: The configuration for outbound registration

Registration is *COMPLETELY* separate from the rest of 'pjsip.conf'. A minimal configuration consists of setting a 'server\_uri'and a 'client\_uri'.<br>


#### Configuration Option Reference

| Option Name | Type | Default Value | Regular Expression | Description | Since |
|:---|:---|:---|:---|:---|:---| 
| [auth_rejection_permanent](#auth_rejection_permanent)| Boolean| yes| false| Determines whether failed authentication challenges are treated as permanent failures.| |
| [client_uri](#client_uri)| String| | false| Client SIP URI used when attemping outbound registration| |
| contact_user| String| | false| Contact User to use in request| |
| [endpoint](#endpoint)| String| | false| Endpoint to use for incoming related calls| |
| expiration| Unsigned Integer| 3600| false| Expiration time for registrations in seconds| |
| [fatal_retry_interval](#fatal_retry_interval)| Unsigned Integer| 0| false| Interval used when receiving a Fatal response.| |
| [forbidden_retry_interval](#forbidden_retry_interval)| Unsigned Integer| 0| false| Interval used when receiving a 403 Forbidden response.| |
| [line](#line)| Boolean| no| false| Whether to add a 'line' parameter to the Contact for inbound call matching| |
| [max_random_initial_delay](#max_random_initial_delay)| Unsigned Integer| 10| false| Maximum interval in seconds for which an initial registration may be randomly delayed| |
| [max_retries](#max_retries)| Unsigned Integer| 10| false| Maximum number of registration attempts.| |
| [outbound_auth](#outbound_auth)| Custom| | false| Authentication object(s) to be used for outbound registrations.| |
| outbound_proxy| String| | false| Full SIP URI of the outbound proxy used to send registrations| |
| retry_interval| Unsigned Integer| 60| false| Interval in seconds between retries if outbound registration is unsuccessful| |
| [security_mechanisms](#security_mechanisms)| Custom| | false| List of security mechanisms supported.| |
| [security_negotiation](#security_negotiation)| Custom| no| false| The kind of security agreement negotiation to use. Currently, only mediasec is supported.| |
| [server_uri](#server_uri)| String| | false| SIP URI of the server to register against| |
| [support_path](#support_path)| Boolean| no| false| Enables Path support for outbound REGISTER requests.| |
| [transport](#transport)| String| | false| Transport used for outbound authentication| |
| type| None| | false| Must be of type 'registration'.| |


#### Configuration Option Descriptions

##### auth_rejection_permanent

If this option is enabled and an authentication challenge fails, registration will not be attempted again until the configuration is reloaded.<br>


##### client_uri

This is the address-of-record for the outbound registration (i.e. the URI in the To header of the REGISTER).<br>

For registration with an ITSP, the client SIP URI may need to consist of an account name or number and the provider's hostname for their registrar, e.g. client\_uri=1234567890@example.com. This may differ between providers.<br>

For registration to generic registrars, the client SIP URI will depend on networking specifics and configuration of the registrar.<br>


##### endpoint

When line support is enabled this configured endpoint name is used for incoming calls that are related to the outbound registration.<br>


##### fatal_retry_interval

If a fatal response is received, chan\_pjsip will wait _fatal\_retry\_interval_ seconds before attempting registration again. If 0 is specified, chan\_pjsip will not retry after receiving a fatal (non-temporary 4xx, 5xx, 6xx) response. Setting this to a non-zero value may go against a "SHOULD NOT" in RFC3261, but can be used to work around buggy registrars.<br>


/// note
if also set the _forbidden\_retry\_interval_ takes precedence over this one when a 403 is received. Also, if _auth\_rejection\_permanent_ equals 'yes' then a 401 and 407 become subject to this retry interval.
///


##### forbidden_retry_interval

If a 403 Forbidden is received, chan\_pjsip will wait _forbidden\_retry\_interval_ seconds before attempting registration again. If 0 is specified, chan\_pjsip will not retry after receiving a 403 Forbidden response. Setting this to a non-zero value goes against a "SHOULD NOT" in RFC3261, but can be used to work around buggy registrars.<br>


##### line

When enabled this option will cause a 'line' parameter to be added to the Contact header placed into the outgoing registration request. If the remote server sends a call this line parameter will be used to establish a relationship to the outbound registration, ultimately causing the configured endpoint to be used.<br>


##### max_random_initial_delay

By default, registrations are randomly delayed by a small amount to prevent too many registrations from being made simultaneously.<br>

Depending on your system usage, it may be desirable to set this to a smaller or larger value to have fine grained control over the size of this random delay.<br>


##### max_retries

This sets the maximum number of registration attempts that are made before stopping any further attempts. If set to 0 then upon failure no further attempts are made.<br>


##### outbound_auth

This is a comma-delimited list of _auth_ sections defined in *pjsip.conf* used to respond to outbound authentication challenges.<br>


/// note
Using the same auth section for inbound and outbound authentication is not recommended. There is a difference in meaning for an empty realm setting between inbound and outbound authentication uses. See the auth realm description for details.
///


##### security_mechanisms

This is a comma-delimited list of security mechanisms to use. Each security mechanism must be in the form defined by RFC 3329 section 2.2.<br>


##### security_negotiation


* `no`

* `mediasec`

##### server_uri

This is the URI at which to find the registrar to send the outbound REGISTER. This URI is used as the request URI of the outbound REGISTER request from Asterisk.<br>

For registration with an ITSP, the setting may often be just the domain of the registrar, e.g. sip:sip.example.com.<br>


##### support_path

When this option is enabled, outbound REGISTER requests will advertise support for Path headers so that intervening proxies can add to the Path header as necessary.<br>


##### transport


/// note
A _transport_ configured in 'pjsip.conf'. As with other 'res\_pjsip' modules, this will use the first available transport of the appropriate type if unconfigured.
///



### Generated Version

This documentation was generated from Asterisk branch 16 using version GIT 